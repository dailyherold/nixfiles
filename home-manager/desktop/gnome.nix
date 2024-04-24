{pkgs, ...}: {
  dconf.settings = {
    "org/gnome/desktop/wm/preferences" = {
      focus-mode = "sloppy";
      button-layout = "appmenu:minimize,maximize,close";
    };

    "org/gnome/desktop/interface" = {
      clock-show-seconds = true;
      clock-show-date = true;
      clock-show-weekday = true;
      color-scheme = "prefer-dark";
    };

    "org/gnome/desktop/peripherals/trackball" = {
      scroll-wheel-emulation-button = 2;
    };

  };
}
