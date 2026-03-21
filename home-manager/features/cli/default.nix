{
  lib,
  pkgs,
  config,
  ...
}: {
  imports = [
    ./atuin.nix
    ./aws.nix
    ./claude.nix
    ./fish.nix
    ./github.nix
    ./gitlab.nix
    ./google.nix
    ./himalaya.nix
    ./javascript.nix
    ./nvim.nix
    ./opencode.nix
    ./scarlett.nix
    ./starship.nix
    ./tmux.nix
    ./zellij.nix
    ./glow.nix
    ./protonmail-bridge.nix
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
      uv # Python package and project manager
      python3Packages.markitdown # Convert files/URLs to Markdown (Microsoft)
    ]
    ++ lib.optionals pkgs.stdenv.isLinux [
      wl-clipboard # copy pasta utilities for wayland
    ];
}
