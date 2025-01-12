{pkgs, ...}: {
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    enableBashIntegration = true;
    enableTransience = true;
    settings = {
      # Configuration written to ~/.config/starship.toml
      # Reference: https://starship.rs/config/

      # module when inside a nix shell
      nix_shell = {
        #nix3 shell support based on nix store in path ([not perfect](https://github.com/NixOS/nix/issues/3862))
        heuristic = true;
      };
    };
  };

  # Theme
  catppuccin.starship.enable = true;
}
