{
  lib,
  pkgs,
  config,
  ...
}: {
  programs.ghostty = {
    enable = true;
    package = lib.mkIf pkgs.stdenv.isDarwin null;
    enableFishIntegration = true;
    settings = {
      background-opacity = 0.80;
      font-family = config.fontProfiles.monospace.family;
      font-size = 10;
    };
  };

  catppuccin.ghostty.enable = true;
}
