{
  lib,
  pkgs,
  config,
  ...
}: {
  imports = [
    ./element.nix
    ./firefox.nix
  ];
}