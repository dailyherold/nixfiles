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
    ./gpaste.nix
    ./github.nix
    ./kiro.nix
    ./gitlab.nix
    ./google.nix
    # ./himalaya.nix # disabled: nixpkgs 26.11 has broken himalaya 1.2.0 pkg; needs v2 migration
    ./javascript.nix
    ./nvim.nix
    ./opencode.nix
    ./pi.nix
    ./scarlett.nix
    ./starship.nix
    ./tmux.nix
    ./glow.nix
    ./hunk.nix
    ./keychain.nix
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
    ]
    ++ lib.optionals pkgs.stdenv.isLinux [
      wl-clipboard # copy pasta utilities for wayland
    ];
}
