# Shared home-manager config imported by all hosts
{
  inputs,
  lib,
  config,
  pkgs,
  outputs,
  ...
}: {
  imports =
    [
      ./features/cli
    ]
    ++ (builtins.attrValues outputs.homeManagerModules);

  xdg.enable = pkgs.stdenv.isLinux;

  # Theme
  catppuccin.flavor = "mocha";

  # Vim
  programs.vim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
      nerdtree
    ];
  };

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git = {
    enable = true;
    settings = {
      aliases = {
        st = "status";
        lg = "log --all --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%ci) %C(bold blue)<%an>%Creset' --abbrev-commit";
        hist = "log --pretty=format:\"%h %ad | %s%d [%an]\" --graph --date=short";
      };
      user.email = "git@dailyherold.simplelogin.com";
      user.name = "dailyherold";
      user.useConfigOnly = true;
      core.editor = "nvim";
      color.ui = true;
      diff.tool = "diffsitter";
      difftool.prompt = false;
      difftool.diffsitter.cmd = "diffsitter \"$LOCAL\" \"$REMOTE\"";
    };
  };
}
