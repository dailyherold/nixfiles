{
  pkgs,
  inputs,
  ...
}: {
  # Shared skills (see modules/home-manager/agent-skills.nix)
  agentSkills.targets = [".config/opencode/skills"];

  programs.opencode = {
    enable = true;
    tui.theme = "system";
    settings = {
      "$schema" = "https://opencode.ai/config.json";
      # Plan review UI (see plannotator.nix)
      plugin = ["@plannotator/opencode@latest"];
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
            "@claude/claude-opus-4-7" = {
              name = "portkey-claude-opus-4-7";
            };
            # Open Source
            "@fireworks/accounts/fireworks/models/kimi-k2p6" = {
              name = "portkey-kimi-2.6";
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
            # OpenAI (Responses API - max_completion_tokens instead of max_tokens)
            "@openai/gpt-5.4-mini" = {
              name = "portkey-gpt-5.4-mini";
            };
            "@openai/gpt-5.4" = {
              name = "portkey-gpt-5.4";
            };
            "@openai/gpt-5.4-pro" = {
              name = "portkey-gpt-5.4-pro";
            };
          };
        };
        bifrost = {
          npm = "@ai-sdk/openai-compatible";
          name = "Sembi-Bifrost";
          options = {
            baseURL = inputs.nix-secrets.apis.sembiBifrostUrl;
            apiKey = inputs.nix-secrets.apis.sembiBifrostKey;
          };
          # IDs, limits and prices (USD per 1M tokens) from Bifrost's /v1/models,
          # 2026-11-10. Latest generation per tier only. Gemma 3 and Llama 3.3 are
          # omitted: they emit tool calls as text, not tool_calls.
          models = {
            # Anthropic
            "bedrock/us.anthropic.claude-haiku-5-5" = {
              name = "sembi-claude-haiku-5-5";
              limit = {
                context = 1000000;
                output = 128000;
              };
              cost = {
                input = 0.11;
                output = 0.55;
                cache_read = 0.011;
                cache_write = 0.1375;
              };
            };
            "bedrock/us.anthropic.claude-sonnet-5-5" = {
              name = "sembi-claude-sonnet-5-5";
              limit = {
                context = 1000000;
                output = 128000;
              };
              cost = {
                input = 2.2;
                output = 11;
                cache_read = 0.11;
                cache_write = 2.75;
              };
            };
            "bedrock/us.anthropic.claude-opus-5-5" = {
              name = "sembi-claude-opus-5-5";
              limit = {
                context = 1000000;
                output = 128000;
              };
              cost = {
                input = 4.4;
                output = 22;
                cache_read = 0.22;
                cache_write = 5.5;
              };
            };
            # OpenAI (gpt-6-luna: no 6.1 luna yet)
            "bedrock/us.openai.gpt-6-luna" = {
              name = "sembi-gpt-6-luna";
              limit = {
                context = 922000;
                output = 131072;
              };
              cost = {
                input = 0.11;
                output = 0.55;
                cache_read = 0.011;
                cache_write = 0.1375;
              };
            };
            "bedrock/us.openai.gpt-6.1-terra" = {
              name = "sembi-gpt-6.1-terra";
              limit = {
                context = 922000;
                output = 128000;
              };
              cost = {
                input = 1.1;
                output = 5.5;
                cache_read = 0.055;
                cache_write = 1.375;
              };
            };
            "bedrock/us.openai.gpt-6.1-sol" = {
              name = "sembi-gpt-6.1-sol";
              limit = {
                context = 1050000;
                output = 131072;
              };
              cost = {
                input = 2.2;
                output = 11;
                cache_read = 0.11;
                cache_write = 2.75;
              };
            };
            # Meta (no prompt caching)
            "bedrock/us.meta.llama4-scout-17b-instruct-v1:0" = {
              name = "sembi-llama4-scout";
              limit = {
                context = 10000000;
                output = 8192;
              };
              cost = {
                input = 0.17;
                output = 0.66;
                cache_read = 0;
                cache_write = 0;
              };
            };
            "bedrock/us.meta.llama4-maverick-17b-instruct-v1:0" = {
              name = "sembi-llama4-maverick";
              limit = {
                context = 1000000;
                output = 8192;
              };
              cost = {
                input = 0.24;
                output = 0.97;
                cache_read = 0;
                cache_write = 0;
              };
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
      mcp = {
        Testmo = {
          type = "remote";
          url = "https://testmo.sembi.com/mcp";
        };
        atlassianSembi = {
          type = "remote";
          url = "https://mcp.atlassian.com/v1/mcp/authv2";
        };
        TestRail = {
          type = "remote";
          url = "https://testrail.sembi.com/mcp";
        };
        Xray = {
          type = "remote";
          url = "https://xray.sembi.com/mcp";
          headers.Authorization = inputs.nix-secrets.apis.sembiAtlassianMcpAuth;
        };
      };
    };
  };
}
