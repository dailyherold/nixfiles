{
  lib,
  pkgs,
  ...
}: {
  programs.tmux = {
    enable = true;

    # HM native options
    terminal = "tmux-256color";
    shell = "${pkgs.fish}/bin/fish";
    mouse = true;
    prefix = "C-a";
    historyLimit = 50000;
    escapeTime = 0;
    keyMode = "vi";
    baseIndex = 1;
    focusEvents = true;

    plugins = with pkgs.tmuxPlugins; [
      {
        plugin = resurrect;
        extraConfig = ''
          set -g @resurrect-capture-pane-contents 'on'
          set -g @resurrect-processes 'false'
        '';
      }
      continuum
      vim-tmux-navigator
      tmux-thumbs
    ];

    extraConfig = ''
      # truecolor passthrough for outer terminal
      set -as terminal-features ",xterm-256color:RGB"

      # longer messages
      set-option -g display-time 4000

      # unbind arrow keys (use vim-style hjkl navigation)
      unbind-key Up
      unbind-key Down
      unbind-key Left
      unbind-key Right

      ## CLIPBOARD
      ${lib.optionalString pkgs.stdenv.isDarwin ''
        # macOS clipboard
        unbind C-y
        bind C-y run-shell -b "tmux show-buffer | pbcopy" \; display-message "Copied tmux buff[top] to sys clip"
        unbind C-p
        bind C-p run-shell -b "tmux display -p -F '#{pane_current_path}' | pbcopy" \; display "Copied current path '#{pane_current_path}' to the clipboard."
      ''}
      ${lib.optionalString pkgs.stdenv.isLinux ''
        # Linux clipboard (Wayland)
        unbind C-y
        bind C-y run-shell -b "tmux show-buffer | wl-copy" \; display-message "Copied tmux buff[top] to sys clip"
        unbind C-p
        bind C-p run-shell -b "tmux display -p -F '#{pane_current_path}' | wl-copy" \; display "Copied current path '#{pane_current_path}' to the clipboard."
      ''}

      ## PANES
      set -g pane-base-index 1
      unbind %
      bind-key | split-window -h -c "#{pane_current_path}"
      bind-key - split-window -v -c "#{pane_current_path}"

      # Cycle Panes
      bind o select-pane -t :.+
      bind O select-pane -t :.-

      # Resize Panes
      bind -r   h resize-pane -L 2
      bind -r C-h resize-pane -L 10
      bind -r   j resize-pane -D 2
      bind -r C-j resize-pane -D 10
      bind -r   k resize-pane -U 2
      bind -r C-k resize-pane -U 10
      unbind l
      bind -r   l resize-pane -R 2
      bind -r C-l resize-pane -R 10

      ## WINDOWS
      set-option -g renumber-windows on
      set -g allow-rename off
      bind C-a last-window
      bind -r p previous-window
      bind -r n next-window
    '';
  };

  # Theme
  catppuccin.tmux.enable = true;
}
