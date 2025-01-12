{pkgs, ...}: let
  kitty-scrollback-nvim = pkgs.vimUtils.buildVimPlugin rec {
    name = "kitty-scrollback-nvim";
    version = "5.0.0";
    src = pkgs.fetchFromGitHub {
      owner = "mikesmithgh";
      repo = "kitty-scrollback.nvim";
      rev = "v${version}";
      hash = "sha256-TV++v8aH0Vi9UZEdTT+rUpu6HKAfhu04EwAgGbfk614=";
    };
  };
in {
  home.sessionVariables.EDITOR = "nvim";

  programs.neovim = {
    enable = true;
    extraConfig = ''
      let g:loaded_netrw = 1
      let g:loaded_netrwPlugin = 1

      let mapleader = " "

      "Use system clipboard
      set clipboard=unnamedplus

      "Line numbers
      set number relativenumber
    '';
    extraLuaConfig = ''
      local telescopeBuiltin = require('telescope.builtin')
      vim.keymap.set('n', '<leader>ff', telescopeBuiltin.find_files, {})
      vim.keymap.set('n', '<leader>fg', telescopeBuiltin.live_grep, {})
      vim.keymap.set('n', '<leader>fb', telescopeBuiltin.buffers, {})
      vim.keymap.set('n', '<leader>fh', telescopeBuiltin.help_tags, {})
      vim.keymap.set('n', '<leader>e', ':NvimTreeFindFileToggle<CR>', { silent = true })
    '';
    plugins = with pkgs.vimPlugins; [
      diffview-nvim
      telescope-nvim
      {
        plugin = kitty-scrollback-nvim;
        type = "lua";
        config = ''
          require("kitty-scrollback").setup()
        '';
      }
      {
        plugin = bufferline-nvim;
        type = "lua";
        config = ''
          require("bufferline").setup()
        '';
      }
      {
        plugin = nvim-tree-lua;
        type = "lua";
        config = ''
          require('nvim-tree').setup({ update_cwd = true })
        '';
      }
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

  # Theme
  catppuccin.nvim.enable = true;

}
