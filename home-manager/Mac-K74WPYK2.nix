# macOS home-manager configuration
{
  inputs,
  lib,
  config,
  pkgs,
  outputs,
  ...
}: {
  imports = [
    ./common.nix
    ./features/desktop/ghostty.nix
    ./features/desktop/element.nix
    ./features/desktop/font.nix
  ];

  home = {
    username = "e133949";
    homeDirectory = "/Users/e133949";
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
