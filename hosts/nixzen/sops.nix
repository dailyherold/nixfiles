{
  inputs,
  config,
  ...
}: {
  imports = [inputs.sops-nix.nixosModules.sops];

  # Decrypt secrets from nix-secrets private flake.
  #
  # Two age key sources are registered; sops tries both:
  #   1. SSH host key (normal operation after rekeying):
  #        nix run nixpkgs#ssh-to-age -- < /etc/ssh/ssh_host_ed25519_key.pub
  #      Add that output to nix-secrets/.sops.yaml and run: sops updatekeys secrets/shared.yaml
  #   2. Dev age key (bootstrap / fresh install fallback):
  #      Copy the personal age key to /root/.config/sops/age/keys.txt before nixos-install.
  #      Its public key is already in .sops.yaml so this works without rekeying.
  sops.defaultSopsFile = "${inputs.nix-secrets}/secrets/shared.yaml";
  sops.age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
  sops.age.keyFile = "/root/.config/sops/age/keys.txt";

  sops.secrets."users/dailyherold/password" = {
    neededForUsers = true;
  };

  sops.secrets."proton-bridge/password" = {
    owner = "dailyherold";
  };

  # Override the bootstrap initialPassword with the sops-managed hashed password.
  # Any NixOS host with sops configured should do the same for its user.
  # To generate the value: mkpasswd -m sha-512 (store result in sops secrets)
  users.users.dailyherold.hashedPasswordFile =
    config.sops.secrets."users/dailyherold/password".path;
}
