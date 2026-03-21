# JavaScript tooling configuration (bun + node/npm)
# Since nix-managed node has a read-only store prefix, we redirect
# global installs to a user-writable directory.
{
  config,
  lib,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    bun
    nodejs
  ];

  # Add bun and npm-global bin dirs to PATH
  home.sessionPath = [
    "${config.home.homeDirectory}/.bun/bin"
    "${config.home.homeDirectory}/.npm-global/bin"
  ];

  # Set npm global prefix to a user-writable directory
  # This allows `npm install -g` to work despite nix's read-only node store
  home.file.".npmrc".text = ''
    prefix=${config.home.homeDirectory}/.npm-global
  '';

  # Ensure the npm-global bin directory exists so npm install -g works on first run
  home.activation.npmGlobalDir = lib.hm.dag.entryAfter ["writeBoundary"] ''
    mkdir -p ${config.home.homeDirectory}/.npm-global/bin
  '';
}
