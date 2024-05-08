{pkgs, ...}: let
  kitty-scrollback-nvim = pkgs.vimUtils.buildVimPlugin rec {
    name = "kitty-scrollback-nvim";
    version = "4.3.3";
    src = pkgs.fetchFromGitHub {
      owner = "mikesmithgh";
      repo = "kitty-scrollback.nvim";
      rev = "v${version}";
      hash = "sha256-HARxd+oY/2s5o/w5L63bSX1lSQlJ/dxMjW7q6GgA9ds=";
    };
  };
in {
  home.sessionVariables.EDITOR = "nvim";

  programs.neovim = {
    enable = true;
    catppuccin.enable = true;
    extraConfig =
      /*
      vim
      */
      ''
        "Use system clipboard
        set clipboard=unnamedplus

        "Line numbers
        set number relativenumber
      '';

    plugins = with pkgs.vimPlugins; [
      kitty-scrollback-nvim
    ];
  };

  xdg.desktopEntries = {
    nvim = {
      name = "Neovim";
      genericName = "Text Editor";
      comment = "Edit text files";
      exec = "nvim %F";
      icon = "nvim";
      mimeType = [
        "text/english"
        "text/plain"
        "text/x-makefile"
        "text/x-c++hdr"
        "text/x-c++src"
        "text/x-chdr"
        "text/x-csrc"
        "text/x-java"
        "text/x-moc"
        "text/x-pascal"
        "text/x-tcl"
        "text/x-tex"
        "application/x-shellscript"
        "text/x-c"
        "text/x-c++"
      ];
      terminal = true;
      type = "Application";
      categories = [
        "Utility"
        "TextEditor"
      ];
    };
  };
}
