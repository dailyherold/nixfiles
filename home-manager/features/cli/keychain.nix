{
  pkgs,
  lib,
  ...
}: {
  programs.keychain = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
    enable = true;
    keys = ["id_ed25519" "sembi_ed25519"];
  };
}
