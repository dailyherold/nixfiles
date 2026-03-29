{pkgs, ...}: {
  programs.keychain = pkgs.lib.mkIf pkgs.stdenv.isLinux {
    enable = true;
    keys = ["id_ed25519"];
  };
}
