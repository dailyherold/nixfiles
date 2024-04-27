{pkgs, ...}: {
  imports = [
    ./chromium.nix
    ./element.nix
    ./firefox.nix
    ./flameshot.nix
    ./font.nix
    ./gnome.nix
    ./kitty.nix
    ./slack.nix
    ./wezterm.nix
  ];
}
