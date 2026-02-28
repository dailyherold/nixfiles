{config, ...}: {
  programs.claude-code = {
    enable = true;
    settings = {
      env = {
        CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS = "1";
      };
      teammateMode = "tmux";
    };
  };

  # Shared skills (agentskills.io spec) and Claude Code-specific agents
  home.file.".claude/skills".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dev/ai/skills";
  home.file.".claude/agents".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dev/ai/agents/claude";

  # Global Claude Code instructions
  home.file.".claude/CLAUDE.md".text = ''
    If an AGENTS.md exists in the current repo, read it before taking any action and follow all instructions precisely.
  '';
}
