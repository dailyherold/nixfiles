{pkgs, ...}: {
  home.packages = [
    pkgs.glab
    # pkgs.gitlab-duo # marked as broken in nixpkgs
  ];
}
