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
    installVimSyntax = lib.mkIf (pkgs.stdenv.isLinux) true;
    settings = {
      theme = "Catppuccin Mocha";
      background-opacity = 0.80;
    };
  };
}
