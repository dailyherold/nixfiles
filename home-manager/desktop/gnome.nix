{
  pkgs,
  lib,
  config,
  ...
}:
with lib.hm.gvariant; {
  dconf.settings = {
    "org/gnome/desktop/wm/preferences" = {
      focus-mode = "sloppy";
      button-layout = "appmenu:minimize,maximize,close";
      titlebar-font = "${config.fontProfiles.bold.family} 11";
    };

    "org/gnome/desktop/interface" = {
      clock-show-seconds = true;
      clock-show-date = true;
      clock-show-weekday = true;
      color-scheme = "prefer-dark";
      # No middle click paste because I use it as a trackball scroll button
      gtk-enable-primary-paste = false;
      # Fonts
      monospace-font-name = "${config.fontProfiles.monospace.family} 10";
      font-name = "${config.fontProfiles.regular.family} 11";
      document-font-name = "${config.fontProfiles.regular.family} 11";
    };

    # Trackball scroll button aka ninja scrolling
    "org/gnome/desktop/peripherals/trackball" = {
      scroll-wheel-emulation-button = 2;
    };

    "org/gtk/settings/file-chooser" = {
      clock-format = "24h";
    };

    "org/gnome/settings-daemon/plugins/power" = {
      sleep-inactive-battery-type = "nothing";
    };

    "org/gnome/settings-daemon/plugins/color" = {
      night-light-enabled = true;
      night-light-schedule-automatic = true;
      night-light-temperature = mkUint32 2700;
    };

    "org/gnome/shell" = {
      enabled-extensions = ["pop-shell@system76.com" "pano@elhan.io"];
      favorite-apps = ["element-desktop.desktop" "firefox.desktop" "slack.desktop" "kitty.desktop"];
    };

    "org/gnome/shell/extensions/pop-shell" = {
      smart-gaps = true;
      gap-outer = mkUint32 2;
      gap-inner = mkUint32 2;
      tile-by-default = true;
    };

    "org/gnome/shell/extensions/pano" = {
      send-notifications-on-copy = false;
      play-audio-on-copy = false;
      show-indicator = false;
      wiggle-indicator = false;
      link-previews = false;
      history-length = 20;
    };
  };

  home.packages = with pkgs; [
    # Tiling
    gnomeExtensions.pop-shell

    # Clipboard manager
    gnomeExtensions.pano
  ];
}
