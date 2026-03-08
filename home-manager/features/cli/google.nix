{
  pkgs,
  inputs,
  ...
}: {
  home.packages = [
    inputs.googleworkspace-cli.packages.${pkgs.system}.default
    pkgs.google-cloud-sdk # gcloud CLI, required for gws auth setup
  ];
}
