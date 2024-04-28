# Nixfiles

Once upon a time I [dotfile'd](https://github.com/dailyherold/dotfiles) with Ansible, now I'm exploring [NixOS](https://nixos.org/learn/) as my host with ~native tooling for system (`[nix](https://nixos.org/manual/nix/stable/)`) and user (`[home-manager](https://nix-community.github.io/home-manager/)`) config. Usage requires [Flakes](https://nixos.wiki/wiki/Flakes).

## Structure

Given I'm the big nerd in my household, I have a relatively simple single-`dailyherold`-user setup mapping to _n_ hosts. Differnt hosts will have different needs, therefore being able to tailor the config via imports for both overall system and user home gives me some nice flexibility.

- `flake.nix`: entrypoint for system and user config
- `home-manager/`
  - `cli/`: non-gui config for import
  - `desktop/`: gui config for import
  - `${hostname}.nix`: host specific home config
- `hosts/`
  - `common/`: config for import
    - `input/`: input device config
    - `users/`: standard user config from any `../hostname/default.nix` config
  - `${hostname}/`: host specific config with `default.nix` utilizing imports and generated `hardware-configuration.nix`
- `shell.nix`: use with `nix develop` for bootstrapping a machine

## Use

From repo root:

```bash
# Build and activate new system config
sudo nixos-rebuild switch --flake .#hostname
```

```bash
# Build and activate new user config
home-manager switch --flake .#dailyherold@hostname
```

```bash
# Start an ephemeral subshell with random package to test
nix shell nixpkgs#random
```

```bash
# Subshell for bootstrapping (or developing)
nix develop
```

```bash
# Update system (nixos-rebuild after)
nix flake update

# Or replace only a specific package, such as home-manager (nixos-rebuild after)
nix flake lock --update-input home-manager
```

## Clean Install

```bash
# From live install media
$ git clone https://github.com/dailyherold/nixfiles.git && cd nixfiles
$ nix --extra-experimental-features 'nix-command flakes' develop # subshell with packages like home-manager (defined in shell.nix)
$ nix flake upgrade # unless wanting to keep pinned, typically I'm wanting newest packages on install though
$ sudo nix --extra-experimental-features 'nix-command flakes' run 'github:nix-community/disko#disko-install' -- --write-efi-boot-entries --flake .#nixzen --disk root /dev/nvme0n1 # from disko docs, formats disks and nix-installs
$ reboot
# From install
$ passwd # change initial password
$ nix shell nixpkgs#git # can change this to a run command to also pull repo perhaps
$ git clone https://github.com/dailyherold/nixfiles.git && cd nixfiles
$ home-manager switch --flake .#dailyherold@hostname
$ git remote set-url origin git@github.com:dailyherold/nixfiles.git
$ # ssh keys and other secret bootstrapping
```

## Troubleshooting

- `cached failure of attribute`: Flake usage can cache eval errors leading to this ambiguous error without much context
  - There is an [open issue](https://github.com/NixOS/nix/issues/3872) discussion, with [best suggestion](https://github.com/NixOS/nix/issues/3872#issuecomment-1637052258) being the use of `--option eval-cache false`
- `No such file or directory`: For flakes in git repos, only files in the working tree will be copied to the store, therefore be sure to `git add` anything new

## History

Declarative, composable, shareable config isn't new to me, as I've been enjoying the 9 years of rather frictionless Ansible playbook runs to quickly provision my primary workstations (usually a primary desktop and work laptop). What is new is functional programming, atomic OS upgrades and rollbacks, and nix as a cross-platform package manager with massive AUR-esque repo/collection behind it.

## Why change?

Random list of factors that led to creation of this repo and installing NixOS on a recent build:
- [Jupiter Broadcasting](https://www.jupiterbroadcasting.com/) mostly
- SCaLE/NixCon videos
- Frustration with package managment fracturing on my normal Pop!\_OS Ubuntu-based distro (insert meme about apt/pip/snap/flatpak/appimage wrangling)
- Interest in clean, reproducible dev environments that didn't require virtualization or containers
- Not keeping up with Ansible, and sensing my localhost pattern for local machine config didn't have a strong community around it (loved the general community and remote use cases though!)
- Increased homelab needs and desire to learn something new

## Special thanks to

- Jupiter Broadcasting for mentioning nix enough to make me finally give it a go
- [Misterio77's config](https://github.com/Misterio77/nix-config) and great [nix-starter-config](https://github.com/Misterio77/nix-starter-configs)
