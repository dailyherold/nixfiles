{pkgs, ...}: {
  services.flameshot = {
    enable = true;
    package = pkgs.flameshot;
    # Settings example: https://github.com/flameshot-org/flameshot/blob/master/flameshot.example.ini
    settings = {
      General = {
        checkForUpdates = "false";
        disabledTrayIcon = true;
        showDesktopNotification = "false";
        startupLaunch = "true";
      };
    };
  };

  home.sessionVariables = {
    QT_QPA_PLATFORM = "wayland";
  };
}
