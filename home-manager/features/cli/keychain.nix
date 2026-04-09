{pkgs, lib, ...}: {
  programs.keychain = lib.mkIf pkgs.stdenv.isLinux {
    enable = true;
    keys = ["id_ed25519"];
  };
}
