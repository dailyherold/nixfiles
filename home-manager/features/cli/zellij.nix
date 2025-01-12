{pkgs, ...}: {
  programs.zellij = {
    enable = true;
    settings = {
      default_shell = "fish";
      scrollback_editor = "nvim";
    };
  };

  # Theme
  catppuccin.zellij.enable = true;
}
