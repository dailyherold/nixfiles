{pkgs, ...}: {
  # Enable networking
  networking.networkmanager.enable = true;

  # use resolved for hostname resolution
  services.resolved.enable = true;

  # Tailscale
  services.tailscale.enable = true;
  # Exit node support: https://tailscale.com/kb/1408/quick-guide-exit-nodes
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };

  # enable mdns resolution for resolved on all connections
  # see https://man.archlinux.org/man/NetworkManager.conf.5#CONNECTION_SECTION
  networking.networkmanager.connectionConfig."connection.mdns" = 2;

  environment.systemPackages = [
    pkgs.tailscale
  ];
}
