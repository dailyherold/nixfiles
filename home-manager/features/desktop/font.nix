{pkgs, ...}: {
  fontProfiles = {
    enable = true;
    monospace = {
      family = "JetBrainsMono Nerd Font";
      package = pkgs.nerd-fonts.jetbrains-mono;
    };
    regular = {
      family = "Fira Sans";
      package = pkgs.fira;
    };
    bold = {
      family = "Fira Sans Bold";
      package = pkgs.fira;
    };
  };
}
