{config, ...}: {
  xdg.mimeApps = {
    associations.added = {
      "x-scheme-handler/terminal" = "kitty.desktop";
    };
    defaultApplications = {
      "x-scheme-handler/terminal" = "kitty.desktop";
    };
  };
  programs.kitty = {
    enable = true;
    catppuccin.enable = true;
    font = {
      name = config.fontProfiles.monospace.family;
      size = 10;
    };
    settings = {
      allow_remote_control = "socket-only";
      listen_on = "unix:/tmp/kitty";
      shell_integration = "enabled";
      scrollback_lines = 4000;
      scrollback_pager_history_size = 2048;
      window_padding_width = 10;
    };
  };
}
