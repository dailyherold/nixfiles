{
  lib,
  pkgs,
  config,
  ...
}: {
  imports = [
    ./fish.nix
    ./scarlett.nix
    ./starship.nix
  ];

  home.packages = with pkgs; [
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
  ];
}
