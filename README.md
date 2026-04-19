# Nixfiles

Once upon a time I [dotfile'd](https://github.com/dailyherold/dotfiles) with Ansible, now I'm managing my systems declaratively with [NixOS](https://nixos.org/learn/) and [nix-darwin](https://github.com/nix-darwin/nix-darwin) using [home-manager](https://nix-community.github.io/home-manager/) for user config across platforms. Usage requires [Flakes](https://nixos.wiki/wiki/Flakes).

## Structure

Given I'm the big nerd in my household, I have a relatively simple single-`dailyherold`-user setup mapping to _n_ hosts. Different hosts will have different needs, therefore being able to tailor the config via imports for both overall system and user home gives me some nice flexibility.

- `flake.nix`: entrypoint for system and user config
- `home-manager/`
  - `common.nix`: shared home-manager config (git, vim, catppuccin, CLI features) imported by all hosts
  - `features/cli/`: non-gui config for import
  - `features/desktop/`: gui config for import
  - `${hostname}.nix`: host specific home config (NixOS and macOS)
- `hosts/`
  - `common/`: NixOS config for import
    - `input/`: input device config
    - `users/`: standard user config from any `../hostname/default.nix` config
  - `nixzen/`: NixOS desktop config
  - `Mac-K74WPYK2/`: macOS (nix-darwin) config
- `shell.nix`: use with `nix develop` for bootstrapping a machine

## Use

From repo root:

### NixOS

```bash
# Build and activate new system config
sudo nixos-rebuild switch --flake .#hostname
```

```bash
# Build and activate new user config
home-manager switch --flake .#dailyherold@hostname
```

### macOS (nix-darwin)

```bash
# Build and activate darwin + home-manager config
sudo darwin-rebuild switch --flake .#Mac-K74WPYK2
```

### General

```bash
# Start an ephemeral subshell with random package to test
nix shell nixpkgs#random
```

```bash
# Subshell for bootstrapping, secrets work, or general nixfiles admin
# (provides git, home-manager, sops, age, ssh-to-age at locked versions)
nix develop
```

```bash
# Update system (nixos-rebuild/darwin-rebuild after)
nix flake update

# Or replace only a specific package, such as home-manager (rebuild after)
nix flake lock --update-input home-manager

# Update secrets after pushing nix-secrets (rebuild after)
nix flake update nix-secrets
```

## Secrets

This repo uses a private `nix-secrets` flake for secrets management, inspired by [EmergentMind's nix-config](https://github.com/EmergentMind/nix-config#secrets-management).

## Clean Install

Soft secrets are pulled from the private `nix-secrets` flake at build time over SSH. Before the first build, make sure SSH access to GitHub is in place.
If any shared hard secrets are in use, also place your personal age key before building.

### NixOS

```bash
# From live install media
# If git is not already available, use a temporary nix shell for it.
$ mkdir ~/dev
$ nix shell nixpkgs#git -c git clone https://github.com/dailyherold/nixfiles.git ~/dev/nixfiles
$ cd ~/dev/nixfiles
$ nix --extra-experimental-features 'nix-command flakes' develop # subshell with default packages (defined in shell.nix)
$ nix flake upgrade # unless wanting to keep pinned, typically I'm wanting newest packages on install though

# Format + mount disk layout (separate from install so we can place secrets before activation runs)
$ sudo nix --extra-experimental-features 'nix-command flakes' run github:nix-community/disko -- --mode disko hosts/nixzen/disks.nix

# Place the personal age key (from password manager) onto the new root before install.
# sops-nix needs it during activation to decrypt the user password secret.
$ sudo mkdir -p /mnt/root/.config/sops/age
$ sudo vim /mnt/root/.config/sops/age/keys.txt  # paste personal age private key
$ sudo chmod 600 /mnt/root/.config/sops/age/keys.txt

# Temporarily add private SSH key for secrets repo pull
$ sudo mkdir -p /root/.ssh
$ sudo chmod 700 /root/.ssh
$ sudo vim /root/.ssh/id_ed25519
$ sudo chmod 600 /root/.ssh/id_ed25519

# Set needed env vars for unfree/insecure packages at install time
$ export NIXPKGS_ALLOW_UNFREE=1
$ export NIXPKGS_ALLOW_INSECURE=1
# --impure let's nix commands read env vars
# --no-root-passwd because user password is brought in as a secret using sops
$ sudo -E nixos-install --impure --flake .#nixzen --no-root-passwd

# Clean up temporary live-environment SSH material before rebooting.
$ sudo rm -rf /root/.ssh
$ reboot

# From installed system
# Restore SSH private key from password manager to ~/.ssh/id_ed25519
$ vim ~/.ssh/id_ed25519
$ chmod 600 ~/.ssh/id_ed25519

# If git is not yet available in the base user environment, use a temporary nix shell.
$ mkdir ~/dev
$ nix shell nixpkgs#git -c git clone git@github.com:dailyherold/nixfiles.git ~/dev/nixfiles
$ cd ~/dev/nixfiles
$ nix develop
# backup flag will backup then replace any existing config files from previously run system config (e.g. fish)
$ home-manager switch -b backup --flake .#dailyherold@nixzen
```

### macOS


```bash
# Install Determinate Nix (https://docs.determinate.systems/determinate-nix/)
# Download and run the macOS graphical installer:
#   https://install.determinate.systems/determinate-pkg/stable/Universal

# Clone the repo
$ mkdir ~/dev
$ git clone git@github.com:dailyherold/nixfiles.git ~/dev/nixfiles && cd ~/dev/nixfiles

# Place the personal age key used for shared hard secrets
$ mkdir -p ~/Library/Application\ Support/sops/age
$ vim ~/Library/Application\ Support/sops/age/keys.txt

# First build (bootstraps nix-darwin)
$ sudo nix run nix-darwin -- switch --flake ~/dev/nixfiles#Mac-K74WPYK2

# Subsequent rebuilds
$ sudo darwin-rebuild switch --flake ~/dev/nixfiles#Mac-K74WPYK2
```

## Working with AI Agents

This repo includes an `AGENTS.md` with conventions and structure documentation designed for AI coding agents (Claude Code, opencode, etc.). Open a session from the repo root and the agent will understand the layout, platform constraints, and patterns.

**Example prompts:**

- "Add support for a new host" — walks through NixOS vs darwin setup, flake wiring, and which `features/cli/` and `features/desktop/` modules to include
- "Add ghostty/firefox/obsidian to my config" — picks the right approach (HM module, `home.packages`, or Homebrew cask) and adds platform guards if needed
- "Make this desktop module work on macOS too" — adds surgical platform guards only where darwin actually breaks
- "What's different between nixzen and Mac-K74WPYK2?" — explains the config differences across hosts
- "Update all flake inputs and rebuild" — runs the update and rebuild for your current platform

### Manual AI Tooling

A few agent-related tools are still installed out-of-band rather than declaratively.

#### Plannotator
Plannotator is currently being evaluated and may be installed manually into `~/.local/bin`.

Typical update flow:

```bash
curl -fsSL https://plannotator.ai/install.sh | bash
```

Known installer side effects:
- may create `~/.agents`
- may create `~/.claude/skills/plannotator-compound`
- requires a `home-manager switch` afterward to restore Pi-managed config such as `~/.pi/agent/settings.json`

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
