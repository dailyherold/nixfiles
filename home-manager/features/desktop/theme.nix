{
  lib,
  pkgs,
  ...
}: {
  home.pointerCursor = lib.mkDefault {
    name = "Adwaita";
    package = pkgs.adwaita-icon-theme;
    size = 16;
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      icon-theme = "Adwaita";
      cursor-theme = "Adwaita";
    };
  };
}
