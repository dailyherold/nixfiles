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
  };

  # Theme
  catppuccin.ghostty.enable = true;
}
