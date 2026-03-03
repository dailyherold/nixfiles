{
  lib,
  pkgs,
  config,
  inputs,
  ...
}: let
  personal = inputs.nix-secrets.personal;
  bridgePasswordEval =
    if pkgs.stdenv.isDarwin
    then "security find-generic-password -w -a proton-bridge -s himalaya"
    else "cat /run/secrets/proton-bridge/password";

  # Exported Bridge TLS cert for IMAP fingerprint pinning (himalaya v1.2.0 / io-imap).
  # One-time setup per machine after Bridge is running and logged in:
  #   launchctl unload .../protonmail-bridge.plist   # stop Bridge
  #   protonmail-bridge --cli
  #   > cert export ~/.config/protonmail/bridge-cert.pem
  #   > exit
  #   launchctl load .../protonmail-bridge.plist     # restart Bridge
  bridgeCert = "${config.home.homeDirectory}/.config/protonmail/bridge-cert.pem";
in {
  programs.himalaya.enable = true;

  # msmtp handles SMTP to Bridge. himalaya's lettre SMTP backend uses plain rustls/webpki
  # which hard-rejects Bridge's self-signed cert regardless of danger-accept-invalid-certs
  # (tracked: pimalaya/himalaya#493, no fix in any release). tls_certcheck off is safe
  # for localhost-only Bridge traffic.
  programs.msmtp = {
    enable = true;
    configContent = ''
      account proton
      host 127.0.0.1
      port 1025
      auth on
      user ${personal.email}
      passwordeval ${bridgePasswordEval}
      tls on
      tls_starttls on
      tls_certcheck off
      from ${personal.email}

      account default : proton
    '';
  };

  # Warn on rebuild if the cert file hasn't been exported yet.
  home.activation.checkBridgeCert = lib.hm.dag.entryAfter ["writeBoundary"] ''
    if [ ! -f "${bridgeCert}" ]; then
      echo ""
      echo "WARNING: Proton Bridge cert missing at ${bridgeCert}"
      echo "IMAP will fail until you run (once per machine):"
      echo "  launchctl unload ~/Library/LaunchAgents/org.nix-community.home.protonmail-bridge.plist"
      echo "  protonmail-bridge --cli"
      echo "  > cert export ${bridgeCert}"
      echo "  > exit"
      echo "  launchctl load ~/Library/LaunchAgents/org.nix-community.home.protonmail-bridge.plist"
      echo ""
    fi
  '';

  accounts.email.accounts.proton = {
    enable = true;
    primary = true;
    address = personal.email;
    realName = personal.fullName;
    userName = personal.email;
    passwordCommand =
      if pkgs.stdenv.isDarwin
      then ["security" "find-generic-password" "-w" "-a" "proton-bridge" "-s" "himalaya"]
      else ["cat" "/run/secrets/proton-bridge/password"];

    imap = {
      host = "127.0.0.1";
      port = 1143;
      tls.useStartTls = true;
    };

    folders = {
      inbox = "INBOX";
      sent = "Sent";
      drafts = "Drafts";
      trash = "Trash";
    };

    himalaya = {
      enable = true;
      settings = {
        downloads-dir = "~/Downloads";
        # IMAP: fingerprint cert pinning via io-imap FingerprintVerifier (v1.2.0).
        # Bypasses rustls-platform-verifier's rejection of Bridge's self-signed cert.
        # Requires bridgeCert to exist — see one-time setup comment above.
        backend.encryption.cert = bridgeCert;
        # SMTP: delegate to msmtp (sendmail backend) — see programs.msmtp above.
        message.send.backend.type = "sendmail";
        message.send.backend.cmd = "msmtp -t";
      };
    };
  };
}
