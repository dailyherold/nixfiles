# NixOS home-manager configuration for nixzen
{
  inputs,
  lib,
  config,
  pkgs,
  outputs,
  ...
}: let
  jailedLib = inputs.jailed-agents.lib.x86_64-linux;
  home = config.home.homeDirectory;
in {
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

  # Bubblewrap-jailed agent wrappers — full session isolation with declared file access.
  # ai dirs are symlinks and must be mounted explicitly
  home.packages = lib.optionals pkgs.stdenv.isLinux [
    # rw access to skills (some skills write into thier subdirs)
    # ro access to agent configs
    (jailedLib.makeJailedClaudeCode {
      extraReadwriteDirs = [
        "${home}/dev/ai/skills"
      ];
      extraReadonlyDirs = [
        "${home}/dev/ai/agents/claude"
      ];
    })

    # opencode
    (jailedLib.makeJailedOpencode {
      extraReadwriteDirs = [
        "${home}/dev/ai/skills"
      ];
      extraReadonlyDirs = [
        "${home}/dev/ai/agents/opencode"
      ];
    })
  ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
