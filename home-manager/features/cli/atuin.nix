{pkgs,...}: {
  # To login:
  # $ atuin login -u <USERNAME>
  # See Bitwarden for username and key
  programs.atuin = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      auto_sync = true;
      sync_address = "https://api.atuin.sh";
      sync_frequency = "20m";
      update_check = false;
      inline_height = 50;
    };
  };
}
