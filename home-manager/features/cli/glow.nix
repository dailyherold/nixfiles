{pkgs, ...}: {
  # glow - Markdown terminal renderer: renders markdown files in the terminal with syntax highlighting and nice formatting (https://github.com/charmbracelet/glow)
  home.packages = [pkgs.glow];
}
