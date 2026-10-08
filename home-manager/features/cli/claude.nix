{config, ...}: {
  programs.claude-code = {
    enable = true;
    settings = {
      env = {
        CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS = "1";
      };
      teammateMode = "tmux";
      mcpServers = {
        Testmo = {
          type = "sse";
          url = "https://testmo.sembi.com/mcp";
        };
        TestRail = {
          type = "sse";
          url = "https://testrail.sembi.com/mcp";
        };
        Xray = {
          type = "sse";
          url = "https://xray.sembi.com/mcp";
        };
      };
      hooks = {
        PermissionRequest = [
          {
            matcher = "ExitPlanMode";
            hooks = [
              {
                type = "command";
                command = "plannotator";
                timeout = 345600;
              }
            ];
          }
        ];
      };
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
