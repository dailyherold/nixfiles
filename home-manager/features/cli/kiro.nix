# kiro coding agent (https://kiro.dev/)
#
# Install kiro (desktop IDE) — not in nixpkgs yet (PR: https://github.com/NixOS/nixpkgs/pull/425607)
#   macOS:  brew install --cask kiro
#   Linux:  download from https://kiro.dev/downloads/
#
# Install kiro-cli — not in nixpkgs, installed manually:
#   macOS/Linux:  curl -fsSL https://cli.kiro.dev/install | bash
{
  config,
  ...
}: {
  # Shared skills (agentskills.io spec) — same live symlink pattern as claude.nix, opencode.nix, pi.nix
  home.file.".kiro/skills".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dev/ai/skills";
}
