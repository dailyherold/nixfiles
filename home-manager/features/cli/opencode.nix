{
  pkgs,
  config,
  ...
}: {
  # Shared skills (agentskills.io spec) and opencode-specific agents
  home.file.".config/opencode/skills".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dev/ai/skills";
  home.file.".config/opencode/agents".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dev/ai/agents/opencode";

  programs.opencode = {
    enable = true;
    settings = {
      "$schema" = "https://opencode.ai/config.json";
      theme = "system";
      provider = {
        helicone = {
          npm = "@ai-sdk/openai-compatible";
          name = "Helicone";
          options = {
            baseURL = "https://ai-gateway.helicone.ai";
            headers = {
              Helicone-Cache-Enabled = true;
              Helicone-User-Id = "opencode";
            };
          };
          models = {
            "claude-4.6-sonnet" = {
              name = "heli-claude-4.6-sonnet";
            };
            "claude-4.6-opus" = {
              name = "heli-claude-4.6-opus";
            };
            "claude-4.5-haiku" = {
              name = "heli-claude-4.5-haiku";
            };
            "gpt-5.2" = {
              name = "heli-gpt-5.2";
            };
            "gpt-5.2-codex" = {
              name = "heli-gpt-5.2-codex";
            };
            grok-code-fast-1 = {
              name = "heli-grok-code-fast-1";
            };
            grok-4-1-fast-non-reasoning = {
              name = "heli-grok-4-1-fast";
            };
            grok-4-1-fast-reasoning = {
              name = "heli-grok-4-1-fast-reasoning";
            };
            gemini-3-flash-preview = {
              name = "heli-gemini-3-flash";
            };
            gemini-3-pro-preview = {
              name = "heli-gemini-3-pro";
            };
            "gemini-2.5-flash-lite" = {
              name = "heli-gemini-2.5-flash-lite";
            };
          };
        };
      };
      model = "helicone/claude-4.6-sonnet";
      small_model = "helicone/claude-4.5-haiku";
    };
  };
}
