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
    ./gnome.nix
    ./slack.nix
  ];
}
