{pkgs, ...}: {
  imports = [
    ./chromium.nix
    ./cursor.nix
    ./element.nix
    ./firefox.nix
    ./flameshot.nix
    ./font.nix
    ./gnome.nix
    ./kitty.nix
    ./slack.nix
    ./wayland.nix
    ./wezterm.nix
  ];
}
