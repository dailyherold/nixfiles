# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  outputs,
  ...
}: {
  # You can import other home-manager modules here
  imports =
    [
      # You can also split up your configuration and import pieces of it here:
      ./features/desktop
      ./features/cli
      ./features/virt.nix # see also hosts/common/virt.nix for system level settings
    ]
    ++ (builtins.attrValues outputs.homeManagerModules);

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      inputs.nix-vscode-extensions.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  xdg.enable = true;

  home = {
    username = "dailyherold";
    homeDirectory = "/home/dailyherold";
  };

  # Theme
  catppuccin.flavor = "mocha";

  # Vim
  programs.vim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
      nerdtree
    ];
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

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git = {
    enable = true;
    userName = "dailyherold";
    userEmail = "git@dailyherold.simplelogin.com";
    aliases = {
      st = "status";
      lg = "log --all --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%ci) %C(bold blue)<%an>%Creset' --abbrev-commit";
      hist = "log --pretty=format:\"%h %ad | %s%d [%an]\" --graph --date=short";
    };
    extraConfig = {
      user.useConfigOnly = true;
      core.editor = "nvim";
      color.ui = true;
      diff.tool = "diffsitter";
      difftool.prompt = false;
      difftool.diffsitter.cmd = "diffsitter \"$LOCAL\" \"$REMOTE\"";
    };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
