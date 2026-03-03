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
  ];

  home = {
    username = inputs.nix-secrets.personal.swaId;
    homeDirectory = "/Users/${inputs.nix-secrets.personal.swaId}";
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
