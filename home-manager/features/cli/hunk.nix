{...}: {
  programs.hunk = {
    enable = true;
    enableGitIntegration = true;
    settings = {
      theme = "catppuccin-mocha";
      mode = "split";
      line_numbers = true;
      transparent_background = true;
    };
  };
}
