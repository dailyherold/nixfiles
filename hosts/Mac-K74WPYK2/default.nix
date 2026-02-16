# nix-darwin system configuration for Mac-K74WPYK2
{pkgs, ...}: {
  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true;

  # Determinate Nix manages the daemon and nix.conf; disable nix-darwin's nix management
  nix.enable = false;

  # User
  system.primaryUser = "e133949";
  users.knownUsers = ["e133949"];
  users.users.e133949 = {
    home = "/Users/e133949";
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
      "ghostty"
    ];
    brews = [
      # Add CLI tools not in nixpkgs here, e.g.:
      # "awssaml"
    ];
  };

  system.stateVersion = 6;
}
