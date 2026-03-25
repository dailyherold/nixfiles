{
  lib,
  pkgs,
  ...
}: {
  home.activation.checkAtuinLogin = lib.hm.dag.entryAfter ["writeBoundary"] ''
    if ! ${pkgs.atuin}/bin/atuin status 2>/dev/null | grep -q "Username:"; then
      echo ""
      echo "WARNING: atuin not logged in. History will not sync until you run:"
      echo "  atuin login -u <USERNAME>"
      echo "See Bitwarden for username and encryption key."
      echo ""
    fi
  '';

  programs.atuin = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      auto_sync = true;
      sync_address = "https://api.atuin.sh";
      sync_frequency = "20m";
      update_check = false;
      inline_height = 15;
      show_preview = true;
      style = "compact";
      keys.scroll_exits = false;
    };
  };
}
