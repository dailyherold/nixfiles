# nix-darwin system configuration for jp-sembi-mbp
{
  pkgs,
  inputs,
  ...
}: let
  sembiId = inputs.nix-secrets.personal.sembiId;
in {
  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true;

  # Determinate Nix manages the daemon and nix.conf; disable nix-darwin's nix management
  nix.enable = false;

  # User
  system.primaryUser = sembiId;
  users.knownUsers = [sembiId];
  users.users.${sembiId} = {
    home = "/Users/${sembiId}";
    uid = 501;
    shell = pkgs.fish;
  };

  # Shell
  programs.fish.enable = true;

  # Declarative Homebrew management
  homebrew = {
    enable = true;
    onActivation = {
      cleanup = "zap";
      autoUpdate = true;
      upgrade = true;
    };
    casks = [
      "element"
      "ghostty"
      "obs"
    ];
    brews = [
      # Add CLI tools not in nixpkgs here, e.g.:
    ];
  };

  system.stateVersion = 6;
}
