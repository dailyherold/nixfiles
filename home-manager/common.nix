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
      inputs.sops-nix.homeManagerModules.sops
      ./features/cli
    ]
    ++ (builtins.attrValues outputs.homeManagerModules);

  sops.age.keyFile =
    if pkgs.stdenv.isDarwin
    then "${config.home.homeDirectory}/Library/Application Support/sops/age/keys.txt"
    else "${config.home.homeDirectory}/.config/sops/age/keys.txt";
  sops.age.sshKeyPaths = ["${config.home.homeDirectory}/.ssh/id_ed25519"];

  home.activation.checkSopsAgeKey = lib.hm.dag.entryAfter ["writeBoundary"] ''
    if [ ! -s "${config.sops.age.keyFile}" ]; then
      echo ""
      echo "WARNING: No user sops age key found at ${config.sops.age.keyFile}"
      echo "Running 'sops' CLI as your user will fail without it."
      echo "Copy the personal age key from Bitwarden:"
      echo "  mkdir -p ${builtins.dirOf config.sops.age.keyFile}"
      echo "  echo 'AGE-SECRET-KEY-1...' > ${config.sops.age.keyFile}"
      echo "  chmod 600 ${config.sops.age.keyFile}"
      echo ""
    fi
  '';

  xdg.enable = pkgs.stdenv.isLinux;
  xdg.mimeApps.enable = pkgs.stdenv.isLinux;

  # Theme
  catppuccin.flavor = "mocha";

  # Vim
  programs.vim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
      nerdtree
    ];
  };

  # Commit message template
  home.file.".gitcommit.txt".text = ''
    <=50char imperative subject line

    what and why
  '';

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git = {
    enable = true;
    # home.stateVersion = "24.05" causes HM to default signing.format to "openpgp" for
    # backwards compatibility. Explicitly set null to adopt new default and silence warning.
    # We don't use commit signing — revisit if we want to set up SSH signing in the future.
    signing.format = null;
    includes = [
      {
        condition = "gitdir:~/dev/work/sembi/";
        path = "~/dev/work/sembi/.gitconfig";
      }
    ];
    settings = {
      aliases = {
        st = "status";
        lg = "log --all --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%ci) %C(bold blue)<%an>%Creset' --abbrev-commit";
        hist = "log --pretty=format:\"%h %ad | %s%d [%an]\" --graph --date=short";
      };
      user.email = "git@dailyherold.simplelogin.com";
      user.name = "John Paul Herold";
      user.useConfigOnly = true;
      core.editor = "nvim";
      core.commentChar = ";";
      pull.ff = "only";
      color.ui = true;
      commit.template = "~/.gitcommit.txt";
      diff.tool = "diffsitter";
      difftool.prompt = false;
      difftool.diffsitter.cmd = "diffsitter \"$LOCAL\" \"$REMOTE\"";
    };
  };
}
