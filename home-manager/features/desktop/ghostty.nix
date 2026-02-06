{config, ...}: {
  programs.ghostty = {
    enable = true;
    enableFishIntegration = true;
    installVimSyntax = true;
  };

  # Theme
  catppuccin.ghostty.enable = true;
}
