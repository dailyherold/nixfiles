{
  pkgs,
  config,
  lib,
  ...
}: {
  # Configure your system-wide user settings (groups, etc), add more users as needed.
  users.users = {
    dailyherold = {
      # Bootstrap password for nixos-install only. Pass '--no-root-passwd' to nixos-install to skip root password.
      # On hosts with sops configured, hashedPasswordFile (see hosts/<hostname>/sops.nix) overrides this on every activation.
      # Change with 'passwd' after first boot if sops isn't yet configured on the new host.
      initialPassword = "correcthorsebatterystaple";
      isNormalUser = true;
      shell = pkgs.fish;
      openssh.authorizedKeys.keys = [
        # TODO: Add your SSH public key(s) here, if you plan on using SSH to connect
      ];
      # TODO: Be sure to add any other groups you need (such as networkmanager, audio, docker, etc)
      extraGroups = ["wheel" "networkmanager" "libvirtd" "cdrom"];
      packages = [pkgs.home-manager];
    };
  };
}
