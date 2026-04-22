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
    ./features/desktop/font.nix
    ./features/desktop/obsidian.nix
  ];

  home = {
    username = inputs.nix-secrets.personal.sembiId;
    homeDirectory = "/Users/${inputs.nix-secrets.personal.sembiId}";
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
