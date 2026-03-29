{pkgs, ...}: {
  imports = [
    ./chromium.nix
    ./element.nix
    ./firefox.nix
    ./flameshot.nix
    ./font.nix
    ./ghostty.nix
    ./gnome.nix
    ./obs.nix
    ./obsidian.nix
    ./slack.nix
    ./theme.nix
    ./wayland.nix
  ];
}
