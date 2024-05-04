{pkgs, ...}: {
  # Enable networking
  networking.networkmanager.enable = true;

  # use resolved for hostname resolution
  services.resolved.enable = true;

  # enable mdns resolution for resolved on all connections
  # see https://man.archlinux.org/man/NetworkManager.conf.5#CONNECTION_SECTION
  networking.networkmanager.connectionConfig."connection.mdns" = 2;
}
