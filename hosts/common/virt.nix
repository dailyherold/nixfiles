{pkgs, ...}: {
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  # Quickemu
  environment.systemPackages = with pkgs; [quickemu];
  virtualisation.spiceUSBRedirection.enable = true;
}
