{pkgs, ...}: {
  programs.fish = {
    enable = true;
    shellAbbrs = {
      ls = "eza";
      lla = "eza -la";
      vim = "nvim";
    };
    functions = {
      # Disable greeting https://fishshell.com/docs/current/language.html#envvar-fish_greeting
      fish_greeting = "";
    };
  };

  # Theme
  catppuccin.fish.enable = true;
}
