# nix-darwin system configuration for Mac-K74WPYK2
{
  pkgs,
  inputs,
  ...
}: let
  swaId = inputs.nix-secrets.personal.swaId;
in {
  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true;

  # Determinate Nix manages the daemon and nix.conf; disable nix-darwin's nix management
  nix.enable = false;

  # User
  system.primaryUser = swaId;
  users.knownUsers = [swaId];
  users.users.${swaId} = {
    home = "/Users/${swaId}";
    uid = 503;
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
