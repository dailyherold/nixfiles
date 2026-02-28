{...}: {
  programs.claude-code = {
    enable = true;
    settings = {
      env = {
        CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS = "1";
      };
      teammateMode = "tmux";
    };
  };
}
