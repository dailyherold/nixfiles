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
          # Catppuccin window name + title (simplified)
          set -g @catppuccin_window_text "#W | #T"
          set -g @catppuccin_window_current_text "#W | #T"

          set -g @resurrect-capture-pane-contents 'on'
          set -g @resurrect-processes 'false'
        '';
      }
      continuum
      {
        plugin = vim-tmux-navigator;
        extraConfig = ''
          # Extend is_vim pattern to match neovim installed via nix store
          set -g @vim_navigator_pattern "(\S+/)?g?\.(view|l?n?vim?x?|fzf)(diff)?(-wrapped)?|neovim"
        '';
      }
      tmux-thumbs
    ];

    extraConfig = ''
      # truecolor passthrough for outer terminal
      set -as terminal-features ",xterm-256color:RGB"

      # reload config
      bind r source-file ~/.config/tmux/tmux.conf \; display "Config reloaded"

      # keep tmux copy buffer separate from system clipboard (use C-a C-y to explicitly copy)
      set -g set-clipboard off

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

      ## PANE TRANSPARENCY
      # Active pane gets opaque mocha base, inactive inherits terminal transparency
      set -g window-active-style 'bg=#1e1e2e'
      set -g window-style 'bg=default'

      ## PANE BORDERS
      set -g pane-active-border-style 'fg=#89b4fa' # catppuccin mocha "blue"

      ## VIM-TMUX-NAVIGATOR
      # Re-bind after plugin runs with unquoted send-keys (plugin hardcodes send-keys 'C-h' which sends literal string, not ^H).
      # is_vim check walks two levels of pgrep rather than querying by tty
      bind-key -T root C-h if-shell "pgrep -P $(pgrep -P #{pane_pid}) | xargs -I{} ps -o comm= -p {} 2>/dev/null | grep -iqE '(view|l?n?vim?x?|fzf)(diff)?(-wrapped)?|neovim'" "send-keys C-h" "select-pane -L"
      bind-key -T root C-j if-shell "pgrep -P $(pgrep -P #{pane_pid}) | xargs -I{} ps -o comm= -p {} 2>/dev/null | grep -iqE '(view|l?n?vim?x?|fzf)(diff)?(-wrapped)?|neovim'" "send-keys C-j" "select-pane -D"
      bind-key -T root C-k if-shell "pgrep -P $(pgrep -P #{pane_pid}) | xargs -I{} ps -o comm= -p {} 2>/dev/null | grep -iqE '(view|l?n?vim?x?|fzf)(diff)?(-wrapped)?|neovim'" "send-keys C-k" "select-pane -U"
      bind-key -T root C-l if-shell "pgrep -P $(pgrep -P #{pane_pid}) | xargs -I{} ps -o comm= -p {} 2>/dev/null | grep -iqE '(view|l?n?vim?x?|fzf)(diff)?(-wrapped)?|neovim'" "send-keys C-l" "select-pane -R"
    '';
  };

  # Theme
  catppuccin.tmux.enable = true;
}
