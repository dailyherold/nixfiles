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
      theme = "Catppuccin Mocha";
      background-opacity = 0.80;
    };
  };
}
