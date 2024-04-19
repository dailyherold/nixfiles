{
  lib,
  pkgs,
  config,
  ...
}: {
  imports = [
    ./firefox.nix
  ];
}
