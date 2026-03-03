{
  lib,
  pkgs,
  ...
}: {
  home.packages = [pkgs.protonmail-bridge];

  # One-time password setup per machine (Proton Bridge generates this password).
  # To retrieve the password:
  #   protonmail-bridge -c    # enter CLI
  #   > list                  # find your account index
  #   > info 0                # shows IMAP/SMTP settings including the password
  #   > exit
  #
  # Then store it:
  #   macOS: security add-generic-password -a proton-bridge -s himalaya -w <password>
  #   NixOS: sops ~/dev/nix-secrets/secrets/shared.yaml → fill in proton-bridge/password

  home.activation.checkBridgePassword = lib.mkIf pkgs.stdenv.isDarwin (
    lib.hm.dag.entryAfter ["writeBoundary"] ''
      if ! security find-generic-password -a proton-bridge -s himalaya > /dev/null 2>&1; then
        echo ""
        echo "WARNING: Proton Bridge password missing from Keychain"
        echo "himalaya auth will fail until you run (once):"
        echo "  security add-generic-password -a proton-bridge -s himalaya -w <password>"
        echo "  (find it in Proton Bridge app → Settings → Mailboxes)"
        echo ""
      fi
    ''
  );

  # Linux: systemd user service
  systemd.user.services.protonmail-bridge = lib.mkIf pkgs.stdenv.isLinux {
    Unit = {
      Description = "Proton Mail Bridge";
      After = ["graphical-session.target"];
    };
    Service = {
      ExecStart = "${pkgs.protonmail-bridge}/bin/protonmail-bridge --noninteractive";
      Restart = "on-failure";
    };
    Install = {
      WantedBy = ["graphical-session.target"];
    };
  };

  # macOS: launchd user agent
  launchd.agents.protonmail-bridge = lib.mkIf pkgs.stdenv.isDarwin {
    enable = true;
    config = {
      ProgramArguments = ["${pkgs.protonmail-bridge}/bin/protonmail-bridge" "--noninteractive"];
      KeepAlive = true;
      RunAtLoad = true;
      StandardOutPath = "/tmp/protonmail-bridge.log";
      StandardErrorPath = "/tmp/protonmail-bridge.err";
    };
  };
}
