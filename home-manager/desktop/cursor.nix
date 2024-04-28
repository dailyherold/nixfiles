{
  lib,
  pkgs,
  ...
}: {
  home.pointerCursor = lib.mkDefault {
    name = "Adwaita";
    package = pkgs.gnome.adwaita-icon-theme;
    size = 16;
  };
}
