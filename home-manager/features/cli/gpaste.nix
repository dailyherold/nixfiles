# GPaste clipboard manager
# - Simple, reliable clipboard history for GNOME
# - Automatically tracks normal clipboard activity (Ctrl+C)
# - Uses native GNOME UI for history
{
  config,
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    gpaste
  ];

  # Match GPaste's packaged D-Bus/systemd integration exactly.
  # The D-Bus service files expect these exact unit names.
  systemd.user.services."org.gnome.GPaste" = {
    Unit = {
      Description = "GPaste daemon";
      PartOf = ["graphical-session.target"];
      After = ["graphical-session.target"];
    };
    Service = {
      Type = "dbus";
      BusName = "org.gnome.GPaste";
      ExecStart = "${pkgs.gpaste}/libexec/gpaste/gpaste-daemon";
    };
    Install.WantedBy = ["graphical-session.target"];
  };

  systemd.user.services."org.gnome.GPaste.Ui" = {
    Unit = {
      Description = "GPaste user interface";
    };
    Service = {
      Type = "dbus";
      BusName = "org.gnome.GPaste.Ui";
      ExecStart = "${pkgs.gpaste}/libexec/gpaste/gpaste-ui --gapplication-service";
    };
  };

  # GPaste settings + GNOME keybinding for history
  dconf.settings = lib.mkIf pkgs.stdenv.isLinux {
    "org/gnome/GPaste" = {
      images-support = true;
    };

    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = ["/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/gpaste/"];
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/gpaste" = {
      name = "GPaste History";
      binding = "<Super><Shift>v";
      command = "${pkgs.gpaste}/bin/gpaste-client ui";
    };
  };
}
