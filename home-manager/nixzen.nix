# NixOS home-manager configuration for nixzen
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
    ./features/desktop
    ./features/virt.nix # see also hosts/common/virt.nix for system level settings
  ];

  nixpkgs = {
    overlays = [
      inputs.nix-vscode-extensions.overlays.default
    ];
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  home = {
    username = "dailyherold";
    homeDirectory = "/home/dailyherold";
  };

  # VSCodium
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    mutableExtensionsDir = false;

    profiles.default = {
      enableUpdateCheck = false;
      enableExtensionUpdateCheck = false;

      # Example of usage thanks to Arvivgeus https://github.com/arvigeus/nixos-config/blob/master/apps/vscode.nix
      extensions = with pkgs.open-vsx; [
        # https://raw.githubusercontent.com/nix-community/nix-vscode-extensions/master/data/cache/open-vsx-latest.json

        # Nix
        jnoortheen.nix-ide
      ];
    };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
