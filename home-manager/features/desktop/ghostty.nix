{
  lib,
  pkgs,
  ...
}: {
  programs.ghostty = {
    enable = true;
    package = lib.mkIf pkgs.stdenv.isDarwin null;
    enableFishIntegration = true;
    settings = {
      background-opacity = 0.80;
    };
  };

  catppuccin.ghostty.enable = true;
}
