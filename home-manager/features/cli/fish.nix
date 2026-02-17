{pkgs, ...}: {
  programs.fish = {
    enable = true;
    shellAbbrs = {
      ls = "eza";
      lla = "eza -la";
      vim = "nvim";
      tnew = "tmux new-session -s";
    };
    functions = {
      # Disable greeting https://fishshell.com/docs/current/language.html#envvar-fish_greeting
      fish_greeting = "";
    };
    shellInit = ''
      fish_add_path ~/.bun/bin
    '';
  };

  # Theme
  catppuccin.fish.enable = true;
}
