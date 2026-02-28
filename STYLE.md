# Style Guide

## Theme System

All tools use **Catppuccin Mocha** via the [catppuccin/nix](https://github.com/catppuccin/nix) flake module.
The single source of truth is in `home-manager/common.nix`:

```nix
catppuccin.flavor = "mocha";
```

Each tool opts in:

| Tool | Nix option | Location |
|---|---|---|
| Ghostty | `catppuccin.ghostty.enable = true` | `features/desktop/ghostty.nix` |
| Tmux | `catppuccin.tmux.enable = true` | `features/cli/tmux.nix` |
| Neovim | `catppuccin.nvim.enable = true` | `features/cli/nvim.nix` |

To change the global theme, update `catppuccin.flavor` in `common.nix`. All tools follow automatically — except the hardcoded tmux color described below.

## Transparency Layer Model

Transparency is handled as a stack of layers, each deferring to the one below when its own background is unset:

```
Ghostty (background-opacity = 0.80)
  └── blends #1e1e2e with macOS wallpaper at 80% opacity

  tmux (inactive pane: window-style 'bg=default')
    └── passes through to Ghostty → transparent

  tmux (active pane: window-active-style 'bg=#1e1e2e')
    └── explicitly opaque — overrides Ghostty transparency

    Neovim (transparent_background = true → Normal.bg = none)
      └── falls through to tmux layer
          active pane:   sees #1e1e2e (opaque, matches mocha base)
          inactive pane: sees Ghostty at 80% opacity (transparent)
```

### Color authority by element

| Element | Controlled by | Value |
|---|---|---|
| Terminal window bg | Ghostty | `#1e1e2e` @ 80% opacity |
| ANSI 16 colors | Ghostty (Catppuccin Mocha theme) | mocha palette |
| Tmux status bar | catppuccin.tmux | mocha colors |
| Active pane bg | tmux `window-active-style` | `#1e1e2e` (opaque) |
| Inactive pane bg | tmux → Ghostty passthrough | `#1e1e2e` @ 80% |
| Neovim syntax/UI | catppuccin.nvim (mocha) | mocha palette |
| Neovim bg | none — transparent | falls to tmux layer |
| Neovim floats | catppuccin.nvim | mocha (explicit, opaque) |
| Pane borders | tmux `pane-active-border-style` | `#89b4fa` (mocha blue) |

## Known Coupling

`window-active-style 'bg=#1e1e2e'` in `features/cli/tmux.nix` hardcodes catppuccin mocha's
base color. tmux extraConfig is a raw string so it can't reference the nix catppuccin color
variables. If `catppuccin.flavor` is ever changed, this value must be updated manually to match
the new flavor's base color.
