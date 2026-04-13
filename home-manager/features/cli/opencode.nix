{
  pkgs,
  config,
  inputs,
  ...
}: {
  # Shared skills (agentskills.io spec) and opencode-specific agents
  home.file.".config/opencode/skills".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dev/ai/skills";
  home.file.".config/opencode/agents".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dev/ai/agents/opencode";

  programs.opencode = {
    enable = true;
    tui.theme = "system";
    settings = {
      "$schema" = "https://opencode.ai/config.json";
      provider = {
        portkey = {
          npm = "@ai-sdk/openai-compatible";
          name = "Portkey";
          options = {
            baseURL = "https://api.portkey.ai/v1";
            headers = {
              x-portkey-api-key = inputs.nix-secrets.apis.portkeyOpenCodeApiKey;
            };
          };
          models = {
            # Anthropic
            "@claude/claude-haiku-4-5-20251001" = {
              name = "portkey-claude-haiku-4-5";
            };
            "@claude/claude-sonnet-4-6" = {
              name = "portkey-claude-sonnet-4-6";
            };
            "@claude/claude-opus-4-6" = {
              name = "portkey-claude-opus-4-6";
            };
            # Open Source
            "@fireworks/accounts/fireworks/models/kimi-k2p5" = {
              name = "portkey-kimi-2.5";
            };
            # Google
            "@gemini/gemini-2.5-flash-lite" = {
              name = "portkey-gemini-2.5-flash-lite";
            };
            "@gemini/gemini-2.5-pro" = {
              name = "portkey-gemini-2.5-pro";
            };
            "@gemini/gemini-3.1-flash-lite-preview" = {
              name = "portkey-gemini-3.1-flash-lite";
            };
            "@gemini/gemini-3.1-pro-preview" = {
              name = "portkey-gemini-3.1-pro";
            };
            # xAI
            "@grok/grok-4-1-fast-reasoning" = {
              name = "portkey-grok-4-1-fast-reasoning";
            };
            "@grok/grok-4.20" = {
              name = "portkey-grok-4.20";
            };
            "@grok/grok-4.20-reasoning" = {
              name = "portkey-grok-4.20-reasoning";
            };
            # OpenAI
            "@openai/gpt-5-mini" = {
              name = "portkey-gpt-5-mini";
            };
            "@openai/gpt-5.4" = {
              name = "portkey-gpt-5.4";
            };
          };
        };
        portkey-responses = {
          npm = "@ai-sdk/openai";
          name = "Portkey (Responses)";
          options = {
            baseURL = "https://api.portkey.ai/v1";
            apiKey = inputs.nix-secrets.apis.portkeyOpenCodeApiKey;
          };
          models = {
            # xAI
            "@grok/grok-4.20-multi-agent" = {
              name = "portkey-grok-4.20-multi-agent";
            };
            # OpenAI
            "@openai/gpt-5.4-pro" = {
              name = "portkey-gpt-5.4-pro";
            };
          };
        };
        sembi = {
          npm = "@ai-sdk/openai-compatible";
          name = "Sembi-LiteLLM";
          options = {
            baseURL = inputs.nix-secrets.apis.sembiLiteLLMUrl;
            apiKey = inputs.nix-secrets.apis.sembiLiteLLMKey;
          };
          models = {
            "claude-sonnet-4-6" = {
              name = "sembi-claude-sonnet-4-6";
            };
            "claude-opus-4-6" = {
              name = "sembi-claude-opus-4-6";
            };
            "claude-haiku-4-5-20251001" = {
              name = "sembi-claude-haiku-4-5-20251001";
            };
          };
        };
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
      model = "portkey/@claude/claude-sonnet-4-6";
      small_model = "portkey/@gemini/gemini-3.1-flash-lite-preview";
    };
  };
}
