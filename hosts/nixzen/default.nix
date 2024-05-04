# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other NixOS modules here
  imports = [
    # Hardware
    ./hardware-configuration.nix
    inputs.nix-hardware.nixosModules.common-cpu-amd
    inputs.nix-hardware.nixosModules.common-gpu-amd
    inputs.nix-hardware.nixosModules.common-pc-ssd
    # Not yet exported in the hardware flake (https://github.com/NixOS/nixos-hardware/blob/master/flake.nix)
    # Fixes a reported suspend bug that I _think_ I've experienced after computer locked for long duration (requires power button press to wake up sometimes vs just keeb/mouse)
    # inputs.nix-hardware.nixosModules.gigabyte-b550

    # Disks
    ./disks.nix

    # Config
    ../common/users/dailyherold
    ../common/input
    ../common/locale.nix
    ../common/pipewire.nix
    ../common/network.nix
    ../common/mount.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Specific unfree packages allowed
      # https://nixos.org/manual/nixpkgs/stable/#sec-allow-unfree
      allowUnfreePredicate = pkg:
        builtins.elem (lib.getName pkg) [
          "steam"
          "steam-original"
          "steam-run"
        ];
    };
  };

  nix = let
    flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Opinionated: disable global registry
      flake-registry = "";
      # Workaround for https://github.com/NixOS/nix/issues/9574
      nix-path = config.nix.nixPath;
    };
    # Opinionated: disable channels
    channel.enable = false;

    # Opinionated: make flake registry and nix path match flake inputs
    registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver = {
    xkb = {
      layout = "us";
      variant = "";
    };
  };

  ## Enable Ozone (enables Wayland for Chromium/Electron)
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Enable automatic login for the user.
  services.displayManager.autoLogin = {
    enable = true;
    user = "dailyherold";
  };

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Set your hostname
  networking.hostName = "nixzen";

  # Kernel
  # Using 6.8 for default enabled Scarlett drivers
  boot.kernelPackages = pkgs.linuxPackages_6_8;

  # Package/program installs
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  # Add Fish to system config for vendor fish completions provided by Nixpkgs, see also home-manager/cli/fish.nix
  programs.fish = {
    enable = true;
    vendor = {
      completions.enable = true;
      config.enable = true;
      functions.enable = true;
    };
  };

  environment.systemPackages = [
    pkgs.darktable
  ];

  # This setups a SSH server. Very important if you're setting up a headless system.
  # Feel free to remove if you don't need it.
  services.openssh = {
    enable = true;
    settings = {
      # Forbid root login through SSH.
      PermitRootLogin = "no";
      # Use keys only. Remove if you want to SSH using password (not recommended)
      PasswordAuthentication = false;
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.05";
}
