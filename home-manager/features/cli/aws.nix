{pkgs, ...}: {
  home.packages = with pkgs; [
    awscli2 # AWS CLI v2
  ];
}
