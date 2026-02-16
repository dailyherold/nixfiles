# Agents

When making structural changes to this repo, update both this file and README.md to reflect the change.

Multi-platform Nix configuration: NixOS desktop (`nixzen`) + macOS via nix-darwin (`Mac-K74WPYK2`), with home-manager for user config across both.

## Structure

```
flake.nix                          # Entrypoint: inputs, nixos/darwin/home-manager outputs
hosts/
  nixzen/                          # NixOS system config (x86_64-linux, AMD)
  Mac-K74WPYK2/                    # nix-darwin system config (aarch64-darwin)
  common/                          # Shared NixOS-only host modules (users, locale, network, etc.)
home-manager/
  common.nix                       # Shared user config (git, vim, catppuccin, CLI features)
  nixzen.nix                       # NixOS home config → imports common.nix + desktop + virt
  Mac-K74WPYK2.nix                 # macOS home config → imports common.nix + selective desktop modules
  features/cli/                    # Cross-platform CLI tools (fish, nvim, starship, atuin, zellij)
  features/desktop/                # GUI apps; default.nix is NixOS bundle, individual modules cherry-picked elsewhere
modules/home-manager/              # Reusable home-manager modules (fonts)
```

## Key Patterns

- **Shared config goes in `common.nix`**, host-specific config in `{hostname}.nix`
- **Platform guards**: use `lib.mkIf pkgs.stdenv.isLinux` or `lib.optionals pkgs.stdenv.isLinux` for Linux-only config in shared modules
- **`hosts/common/` is NixOS-only** — the darwin host does not import from it
- **Home-manager is integrated into `darwinConfigurations`** in `flake.nix`, not standalone
- **Home-manager is standalone for NixOS** via `homeConfigurations`
- **Determinate Nix** manages the nix daemon on macOS, so `nix.enable = false` in the darwin host config
- **Homebrew** is managed declaratively via nix-darwin for macOS-native apps (casks)
- **macOS GUI apps via HM**: Apps installed via `home.packages` land in `~/Applications/Home Manager Apps/` as nix store symlinks. Spotlight may not index them initially. After installing a new GUI app on darwin, advise the user to run `open ~/Applications/Home\ Manager\ Apps/<App>.app` to launch it the first time

## Build Commands

```bash
# NixOS system rebuild
sudo nixos-rebuild switch --flake .#nixzen

# macOS (nix-darwin + home-manager) rebuild
sudo darwin-rebuild switch --flake .#Mac-K74WPYK2

# NixOS home-manager only
home-manager switch --flake .#dailyherold@nixzen

# Format all nix files
nix fmt

# Update all flake inputs
nix flake update

# Update a single input
nix flake lock --update-input <input-name>
```

## Conventions

- Formatter: alejandra (run `nix fmt` before committing)
- Flake inputs track unstable/master branches
- Single user: `dailyherold` (NixOS) / `e133949` (macOS)
- Catppuccin mocha theme across all tools
- New CLI tool (cross-platform, no config): add to `home-manager/features/cli/default.nix` packages list
- New CLI tool (cross-platform, needs config): create `home-manager/features/cli/<tool>.nix`, import from `features/cli/default.nix`
- New GUI app: add a module in `home-manager/features/desktop/`. Prefer home-manager module > nixpkgs via `home.packages` > Homebrew cask
- **Desktop module convention**: `features/desktop/default.nix` is the kitchen-sink bundle for the main workstation (nixzen). All other hosts import individual modules selectively
- **Adding a new host**: ask the user which `features/cli/` and `features/desktop/` modules to include — don't assume the bundle
- **Adding a new app/config**: ask the user whether it should also work on macOS (or other platforms). Add platform guards only where needed based on that answer and the APIs used
- Platform-specific tool or config: add to `home-manager/<hostname>.nix` or use `lib.mkIf pkgs.stdenv.isLinux`/`isDarwin` guards in shared modules. Linux is the default — only guard where darwin actually breaks (Linux-only APIs, packages that don't build on darwin)
