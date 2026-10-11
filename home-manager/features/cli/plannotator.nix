# Plannotator (https://plannotator.ai): browser review UI for agent plans, diffs and docs
#
# Its installer can wire every harness itself; this repo owns each piece instead:
#   binary:   ~/.local/bin/plannotator, out-of-band (runs via nix-ld on NixOS)
#   skills:   ~/dev/ai/skills/setup.sh (backnotprop/plannotator core skills) -> agentSkills
#   claude:   ExitPlanMode hook in claude.nix
#   opencode: plugin in opencode.nix
#   pi:       npm extension in pi.nix
#
# Install and update commands: README "Agent Tooling". The first install passes
# skip flags (installCmd below) so install.sh writes only the binary and its
# sidecars; they are saved to ~/.plannotator/install-flags.json and reused by
# `plannotator update` and background auto-updates.
{
  config,
  lib,
  ...
}: let
  installCmd = "curl -fsSL https://plannotator.ai/install.sh | bash -s -- --skip-skills --skip-opencode --skip-kiro --skip-codex --skip-gemini --skip-vibe";
in {
  home.activation.checkPlannotator = lib.hm.dag.entryAfter ["writeBoundary"] ''
    home="${config.home.homeDirectory}"
    if [[ ! -x "$home/.local/bin/plannotator" ]]; then
      echo ""
      echo "WARNING: plannotator binary not installed. Install it with:"
      echo "  ${installCmd}"
      echo ""
    elif ! grep -q skip-skills "$home/.plannotator/install-flags.json" 2>/dev/null; then
      echo ""
      echo "WARNING: plannotator was installed without skip flags; updates may write"
      echo "skills and agent config this repo manages. Reinstall with:"
      echo "  ${installCmd}"
      echo ""
    fi

    # Leftovers from installer runs without the skip flags
    shopt -s nullglob
    leftovers=(
      "$home"/.agents/skills/plannotator*
      "$home"/.claude/commands/plannotator-*.md
      "$home"/.config/opencode/command/plannotator-*.md
      "$home"/.config/opencode/commands/plannotator-*.md
      "$home"/.kiro/agents/plannotator*.json
    )
    shopt -u nullglob
    if (( ''${#leftovers[@]} )); then
      echo ""
      echo "WARNING: Plannotator installer leftovers duplicate skills managed by agentSkills."
      echo "Remove them with:"
      printf '  rm -rf %q\n' "''${leftovers[@]}"
      echo ""
    fi
  '';
}
