# Nixfiles

Once upon a time I [dotfile'd](https://github.com/dailyherold/dotfiles) with Ansible, now I'm exploring NixOS as my host with ~native tooling for system ([NixOS](https://nixos.org/learn/)) and user ([home-manager](https://nix-community.github.io/home-manager/)) config. Usage requires [Flakes](https://nixos.wiki/wiki/Flakes).

## Structure

Based off of Misterio77's great [nix-starter-config](https://github.com/Misterio77/nix-starter-configs) repo:

```bash
# Started with the minimal version
nix flake init -t github:misterio77/nix-starter-config#minimal
```

- `flake.nix`: entrypoint for system and user config
- `home-manager/`: user config for my only user
- `nixos/`
  - `configuration.nix`: NixOS system configuration
  - `hardware-configuration.nix`: generated hardware config for my main workstation
- `shell.nix`: use with `nix develop` 

## Use

From root of repo:

```bash
# Build and activate new system config
sudo nixos-rebuild switch --flake .
```

```bash
# Build and activate new user config
home-manager switch --flake .
```

## History

Declarative, composable, shareable config isn't new to me, as I've been enjoying the 9 years of rather frictionless Ansible playbook runs to quickly provision my primary workstations (usually a primary desktop and work laptop). What is new is functional programming, atomic OS upgrades and rollbacks, and nix as a cross-platform package manager with massive AUR-esque repo/collection behind it.

## Why change?

Random list of factors that led to creation of this repo and installing NixOS on a recent build:
- [Jupiter Broadcasting](https://www.jupiterbroadcasting.com/) mostly
- SCaLE/NixCon videos
- Frustration with package managment fracturing on my normal Pop!\_OS Ubuntu-based distro (insert meme about apt/pip/snap/flatpak/appimage wrangling)
- Interest in clean, reproducible dev environments that didn't require virtualization or containers
- Not keeping up with Ansible, and sensing my localhost pattern for machine config wasn't a community th
- Increased homelab needs and desire to learn something new
