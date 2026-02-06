{pkgs, ...}: {
  imports = [
    ./chromium.nix
    ./element.nix
    ./firefox.nix
    ./flameshot.nix
    ./font.nix
    ./ghostty.nix
    ./gnome.nix
    ./kitty.nix
    ./obs.nix
    ./slack.nix
    ./theme.nix
    ./wayland.nix
    ./wezterm.nix
    ./zed.nix
  ];
}
