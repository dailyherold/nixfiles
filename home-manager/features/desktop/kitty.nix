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
    keybindings = {
      # Browse scrollback buffer in nvim
      "kitty_mod+h" = "kitty_scrollback_nvim";
      # Browse output of the last shell command in nvim
      "kitty_mod+g" = "kitty_scrollback_nvim --config ksb_builtin_last_cmd_output";
    };
    extraConfig = ''
      # kitty-scrollback.nvim Kitten alias
      action_alias kitty_scrollback_nvim kitten /nix/store/2imv86kwfgl1w8i9gpdzvg2vjv21cxyx-vim-pack-dir/pack/myNeovimPackages/start/vimplugin-kitty-scrollback-nvim/python/kitty_scrollback_nvim.py

      # Show clicked command output in nvim
      mouse_map ctrl+shift+right press ungrabbed combine : mouse_select_command_output : kitty_scrollback_nvim --config ksb_builtin_last_visited_cmd_output
    '';
  };

  # Theme
  catppuccin.kitty.enable = true;
}
