{
  lib,
  pkgs,
  config,
  ...
}: {
  imports = [
    ./chromium.nix
    ./element.nix
    ./firefox.nix
    ./font.nix
    ./gnome.nix
    ./kitty.nix
    ./slack.nix
  ];
}
