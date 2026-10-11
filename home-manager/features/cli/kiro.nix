# kiro coding agent (https://kiro.dev/)
#
# Install kiro (desktop IDE) — not in nixpkgs yet (PR: https://github.com/NixOS/nixpkgs/pull/425607)
#   macOS:  brew install --cask kiro
#   Linux:  download from https://kiro.dev/downloads/
#
# Install kiro-cli — not in nixpkgs, installed manually:
#   macOS/Linux:  curl -fsSL https://cli.kiro.dev/install | bash
{...}: {
  # Shared skills (see modules/home-manager/agent-skills.nix)
  agentSkills.targets = [".kiro/skills"];
}
