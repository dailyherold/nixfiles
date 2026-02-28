{
  lib,
  pkgs,
  ...
}: let
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
    initLua = ''
      -- Leader
      vim.g.mapleader = ' '

      -- Disable netrw (nvim-tree replaces it)
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1

      -- Editor settings
      vim.opt.clipboard = 'unnamedplus'
      vim.opt.number = true
      vim.opt.relativenumber = true
      vim.opt.autoread = true
      vim.opt.signcolumn = 'yes'
      vim.opt.wrap = false
      vim.opt.colorcolumn = '90'
      vim.opt.laststatus = 2
      vim.opt.showmode = false

      -- Telescope
      local telescopeBuiltin = require('telescope.builtin')
      vim.keymap.set('n', '<leader>ff', telescopeBuiltin.find_files, {})
      vim.keymap.set('n', '<leader>fg', telescopeBuiltin.live_grep, {})
      vim.keymap.set('n', '<leader>fb', telescopeBuiltin.buffers, {})
      vim.keymap.set('n', '<leader>fh', telescopeBuiltin.help_tags, {})

      -- nvim-tree
      vim.keymap.set('n', '<leader>n', ':NvimTreeToggle<CR>', { silent = true })
      vim.keymap.set('n', '<leader>j', ':NvimTreeFindFile<CR>', { silent = true })

      -- Clear search highlight on Escape
      vim.keymap.set('n', '<Esc>', ':nohlsearch<CR>', { silent = true })

      -- Toggle relative numbers off in insert mode / on focus lost
      local augroup = vim.api.nvim_create_augroup('NumberToggle', { clear = true })
      vim.api.nvim_create_autocmd({ 'InsertEnter', 'FocusLost' }, {
        group = augroup,
        callback = function() vim.opt.relativenumber = false end,
      })
      vim.api.nvim_create_autocmd({ 'InsertLeave', 'FocusGained' }, {
        group = augroup,
        callback = function() vim.opt.relativenumber = true end,
      })
    '';
    plugins = with pkgs.vimPlugins; [
      diffview-nvim
      telescope-nvim
      {
        plugin = vim-tmux-navigator;
        type = "lua";
        config = ''
          -- Ghostty sends <BS> for <C-h>; map both to navigate left
          vim.keymap.set('n', '<BS>', '<cmd>TmuxNavigateLeft<CR>', { noremap = true, silent = true })
        '';
      }
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
          require('nvim-tree').setup({
            update_cwd = true,
            filters = { dotfiles = false },
          })
        '';
      }
      {
        plugin = gitsigns-nvim;
        type = "lua";
        config = ''
          require('gitsigns').setup()
        '';
      }
    ];
  };

  xdg.desktopEntries = lib.mkIf pkgs.stdenv.isLinux {
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
  catppuccin.nvim = {
    enable = true;
    settings.transparent_background = true;
  };
}
