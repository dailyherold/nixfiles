{
  lib,
  pkgs,
  config,
  ...
}: let
  bridgeCert = "${config.home.homeDirectory}/.config/protonmail/cert.pem";
  bridgeGluonDb = "${config.home.homeDirectory}/.local/share/protonmail/bridge-v3/gluon/backend/db";
in {
  home.packages = [pkgs.protonmail-bridge];

  home.activation.checkBridgeLogin = lib.hm.dag.entryAfter ["writeBoundary"] ''
    if [ -z "$(ls -A "${bridgeGluonDb}" 2>/dev/null)" ]; then
      echo ""
      echo "WARNING: Proton Bridge not logged in (gluon db empty at ${bridgeGluonDb})"
      echo "Run the following to log in and retrieve the local IMAP/SMTP password:"
      ${if pkgs.stdenv.isDarwin then ''
      echo "  launchctl unload ~/Library/LaunchAgents/org.nix-community.home.protonmail-bridge.plist"
      echo "  protonmail-bridge --cli"
      echo "  > login"
      echo "  > list        # find your account index"
      echo "  > info 0      # shows IMAP/SMTP password"
      echo "  > exit"
      echo "  launchctl load ~/Library/LaunchAgents/org.nix-community.home.protonmail-bridge.plist"
      echo "Then store the password:"
      echo "  macOS: security add-generic-password -a proton-bridge -s himalaya -w <password>"
      '' else ''
      echo "  systemctl --user stop protonmail-bridge"
      echo "  protonmail-bridge --cli"
      echo "  > login"
      echo "  > list        # find your account index"
      echo "  > info 0      # shows IMAP/SMTP password"
      echo "  > exit"
      echo "  systemctl --user start protonmail-bridge"
      echo "Then store the password:"
      echo "  NixOS: sops ~/dev/nix-secrets/secrets/nixzen.yaml → fill in proton-bridge/password"
      ''}
      echo ""
    fi
  '';

  home.activation.checkBridgeCert = lib.hm.dag.entryAfter ["checkBridgeLogin"] ''
    if [ ! -f "${bridgeCert}" ]; then
      echo ""
      echo "WARNING: Proton Bridge cert missing at ${bridgeCert}"
      echo "IMAP will fail until you run (once per machine):"
      ${if pkgs.stdenv.isDarwin then ''
      echo "  launchctl unload ~/Library/LaunchAgents/org.nix-community.home.protonmail-bridge.plist"
      echo "  protonmail-bridge --cli"
      echo "  > cert export"
      echo "  > (enter path when prompted: ${builtins.dirOf bridgeCert})"
      echo "  > exit"
      echo "  launchctl load ~/Library/LaunchAgents/org.nix-community.home.protonmail-bridge.plist"
      '' else ''
      echo "  systemctl --user stop protonmail-bridge"
      echo "  protonmail-bridge --cli"
      echo "  > cert export"
      echo "  > (enter path when prompted: ${builtins.dirOf bridgeCert})"
      echo "  > exit"
      echo "  systemctl --user start protonmail-bridge"
      ''}
      echo ""
    fi
  '';

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
