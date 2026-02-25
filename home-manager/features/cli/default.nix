{
  lib,
  pkgs,
  config,
  ...
}: {
  imports = [
    ./atuin.nix
    ./fish.nix
    ./github.nix
    ./gitlab.nix
    ./nvim.nix
    ./opencode.nix
    ./scarlett.nix
    ./starship.nix
    ./tmux.nix
    ./zellij.nix
    ./glow.nix
  ];

  home.packages = with pkgs;
    [
      bc # Calculator
      htop # Process monitor
      bottom # System viewer
      eza # Better ls
      ripgrep # Better grep
      fd # Better find
      httpie # Better curl
      diffsitter # Better diff
      jq # JSON pretty printer and manipulator
      alejandra # Nix formatter
      tree # tree list
      bun # JavaScript runtime and package manager
      nodejs # Node.js runtime
      uv # Python package and project manager
    ]
    ++ lib.optionals pkgs.stdenv.isLinux [
      wl-clipboard # copy pasta utilities for wayland
    ];
}
