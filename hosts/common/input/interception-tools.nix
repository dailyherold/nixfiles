{
  config,
  lib,
  pkgs,
  ...
}: let
  # Dual function keys: map Left Ctrl to Esc on tap, and keep Left Ctrl on hold
  dfk = {
    MAPPINGS = [
      {
        KEY = "KEY_LEFTCTRL";
        TAP = "KEY_ESC";
        HOLD = "KEY_LEFTCTRL";
      }
    ];
  };
  configFile = pkgs.writeTextFile {
    name = "interception-dfk.yaml";
    text = lib.generators.toYAML {} dfk;
  };
in {
  services.interception-tools = {
    enable = true;
    udevmonConfig = ''
      - JOB: "${pkgs.interception-tools}/bin/intercept -g $DEVNODE | ${pkgs.interception-tools-plugins.dual-function-keys}/bin/dual-function-keys -c ${configFile} | ${pkgs.interception-tools}/bin/uinput -d $DEVNODE"
        DEVICE:
          EVENTS:
            EV_KEY: [KEY_LEFTCTRL]
    '';
  };
}
