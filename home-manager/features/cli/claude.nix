{...}: {
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

  # Shared skills (see modules/home-manager/agent-skills.nix)
  agentSkills.targets = [".claude/skills"];

  # Global Claude Code instructions
  home.file.".claude/CLAUDE.md".text = ''
    If an AGENTS.md exists in the current repo, read it before taking any action and follow all instructions precisely.
  '';
}
