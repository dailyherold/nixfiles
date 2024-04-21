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
    ./slack.nix
  ];
}
