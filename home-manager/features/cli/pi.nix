# pi coding agent (https://shittycodingagent.ai/)
#
# Out-of-band installs (not managed by nix):
#   pi itself:    npm install -g @mariozechner/pi-coding-agent
#   pi update:    npm update -g @mariozechner/pi-coding-agent
#
# Extensions are declared in settings.json below (packages = [...]).
# The home.activation block installs them on first switch.
# To add more extensions: add to the packages list, then run:
#   home-manager switch
# To install/update extensions manually:
#   pi install npm:<package>    # install and persist to settings.json
#   pi update                   # update all installed extensions
#   pi list                     # list installed extensions
{
  lib,
  config,
  inputs,
  ...
}: {
  home.sessionVariables = {
    # Extended prompt cache (Anthropic: 1h)
    PI_CACHE_RETENTION = "long";
  };

  # Set PI_PACKAGE_DIR in shellInit so it always applies, bypassing the
  # __HM_SESS_VARS_SOURCED guard that prevents sessionVariables from being
  # re-read when environment is inherited across shells/sessions.
  programs.fish.shellInit = ''
    set -gx PI_PACKAGE_DIR "${config.home.homeDirectory}/.npm-global/lib/node_modules/@mariozechner/pi-coding-agent"
  '';

  # Global instructions — same pattern as CLAUDE.md in claude.nix
  home.file.".pi/agent/AGENTS.md".text = ''
    If an AGENTS.md exists in the current repo, read it before taking any action and follow all instructions precisely.
  '';

  # Shared skills dir — same live symlink pattern as claude.nix and opencode.nix
  home.file.".pi/agent/skills".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dev/ai/skills";

  # Model IDs match opencode's working Portkey config (@provider/model format).
  home.file.".pi/agent/models.json".text = builtins.toJSON {
    providers = {
      "sembi-litellm" = {
        baseUrl = inputs.nix-secrets.apis.sembiLiteLLMUrl;
        api = "openai-completions";
        apiKey = inputs.nix-secrets.apis.sembiLiteLLMKey;
        compat = {
          supportsStore = false;
          supportsDeveloperRole = false;
          supportsReasoningEffort = false;
          maxTokensField = "max_tokens";
        };
        models = [
          {
            id = "claude-sonnet-4-6";
            name = "sembi-claude-sonnet-4-6";
            reasoning = true;
            input = ["text" "image"];
            contextWindow = 1000000;
            maxTokens = 64000;
            cost = {
              input = 0;
              output = 0;
              cacheRead = 0;
              cacheWrite = 0;
            };
          }
          {
            id = "claude-opus-4-6";
            name = "sembi-claude-opus-4-6";
            reasoning = true;
            input = ["text" "image"];
            contextWindow = 1000000;
            maxTokens = 128000;
            cost = {
              input = 0;
              output = 0;
              cacheRead = 0;
              cacheWrite = 0;
            };
          }
          {
            id = "claude-haiku-4-5-20251001";
            name = "sembi-claude-haiku-4-5-20251001";
            reasoning = true;
            input = ["text" "image"];
            contextWindow = 200000;
            maxTokens = 64000;
            cost = {
              input = 0;
              output = 0;
              cacheRead = 0;
              cacheWrite = 0;
            };
          }
        ];
      };
      portkey = {
        baseUrl = "https://api.portkey.ai/v1";
        api = "openai-completions";
        apiKey = inputs.nix-secrets.apis.portkeyOpenCodeApiKey;
        headers = {
          x-portkey-api-key = inputs.nix-secrets.apis.portkeyOpenCodeApiKey;
        };
        models = [
          # Anthropic
          {
            id = "@claude/claude-haiku-4-5-20251001";
            name = "Claude Haiku 4.5";
            reasoning = true;
            input = ["text" "image"];
            contextWindow = 200000;
            maxTokens = 64000;
          }
          {
            id = "@claude/claude-sonnet-4-6";
            name = "Claude Sonnet 4.6";
            reasoning = true;
            input = ["text" "image"];
            contextWindow = 1000000;
            maxTokens = 64000;
          }
          {
            id = "@claude/claude-opus-4-6";
            name = "Claude Opus 4.6";
            reasoning = true;
            input = ["text" "image"];
            contextWindow = 1000000;
            maxTokens = 128000;
          }
          {
            id = "@claude/claude-opus-4-7";
            name = "Claude Opus 4.7";
            reasoning = false;
            input = ["text" "image"];
            contextWindow = 1000000;
            maxTokens = 128000;
          }
          # Open Source
          {
            id = "@fireworks/accounts/fireworks/models/kimi-k2p5";
            name = "Kimi K2.5";
            reasoning = true;
            input = ["text"];
            contextWindow = 131072;
            maxTokens = 16384;
          }
          # Google
          {
            id = "@gemini/gemini-2.5-flash-lite";
            name = "Gemini 2.5 Flash Lite";
            reasoning = false;
            input = ["text" "image"];
            contextWindow = 1048576;
            maxTokens = 65536;
          }
          {
            id = "@gemini/gemini-2.5-pro";
            name = "Gemini 2.5 Pro";
            reasoning = true;
            input = ["text" "image"];
            contextWindow = 1048576;
            maxTokens = 65536;
          }
          {
            id = "@gemini/gemini-3.1-flash-lite-preview";
            name = "Gemini 3.1 Flash Lite";
            reasoning = false;
            input = ["text" "image"];
            contextWindow = 1048576;
            maxTokens = 65536;
          }
          {
            id = "@gemini/gemini-3.1-pro-preview";
            name = "Gemini 3.1 Pro";
            reasoning = true;
            input = ["text" "image"];
            contextWindow = 1048576;
            maxTokens = 65536;
          }
          # xAI
          {
            id = "@grok/grok-4-1-fast-reasoning";
            name = "Grok 4.1 Fast (Reasoning)";
            reasoning = false;
            input = ["text" "image"];
            contextWindow = 131072;
            maxTokens = 16384;
          }
          {
            id = "@grok/grok-4.20";
            name = "Grok 4.20";
            reasoning = false;
            input = ["text" "image"];
            contextWindow = 131072;
            maxTokens = 16384;
          }
          {
            id = "@grok/grok-4.20-reasoning";
            name = "Grok 4.20 (Reasoning)";
            reasoning = false;
            input = ["text" "image"];
            contextWindow = 131072;
            maxTokens = 16384;
          }
          {
            id = "@grok/grok-4.20-multi-agent";
            name = "Grok 4.20 Multi-Agent";
            api = "openai-responses";
            reasoning = false;
            input = ["text" "image"];
            contextWindow = 131072;
            maxTokens = 16384;
          }
          # OpenAI
          {
            id = "@openai/gpt-5.4-mini";
            name = "GPT-5.4 Mini";
            reasoning = true;
            input = ["text" "image"];
            contextWindow = 128000;
            maxTokens = 16384;
          }
          {
            id = "@openai/gpt-5.4";
            name = "GPT-5.4";
            api = "openai-responses";
            reasoning = true;
            input = ["text" "image"];
            contextWindow = 128000;
            maxTokens = 16384;
          }
          {
            id = "@openai/gpt-5.4-pro";
            name = "GPT-5.4 Pro";
            api = "openai-responses";
            reasoning = true;
            input = ["text" "image"];
            contextWindow = 128000;
            maxTokens = 16384;
          }
        ];
      };
    };
  };

  # Global settings
  home.file.".pi/agent/settings.json".text = builtins.toJSON {
    defaultProvider = "portkey";
    defaultModel = "@claude/claude-sonnet-4-6";
    theme = "dark";
    packages = [{source = "npm:@plannotator/pi-extension";}];
  };

  # Install plannotator pi extension into global npm if not already present.
  # Pi resolves extensions via `npm root -g`, so the package must exist on disk.
  home.activation.piPlannotator = lib.hm.dag.entryAfter ["writeBoundary"] ''
    if [[ ! -d "$HOME/.npm-global/lib/node_modules/@plannotator/pi-extension" ]]; then
      $HOME/.npm-global/bin/npm install -g @plannotator/pi-extension
    fi
  '';

  # Plannotator is used across multiple agent harnesses, but its installer can
  # clobber Pi-managed state. Keep the warnings here because the consequences
  # below are Pi-specific.
  home.activation.piPlannotatorWarnings = lib.hm.dag.entryAfter ["writeBoundary"] ''
    if [[ -d "$HOME/.agents" ]]; then
      echo ""
      echo "WARNING: Plannotator installer left ~/.agents behind."
      echo "If this is stale, remove it with: rm -rf ~/.agents"
      echo ""
    fi

    if [[ -d "$HOME/.claude/skills/plannotator-compound" ]]; then
      echo ""
      echo "WARNING: Plannotator installer created ~/.claude/skills/plannotator-compound."
      echo "This repo expects Claude skills to be managed via ~/dev/ai/skills/setup.sh."
      echo "If this is stale, remove it with:"
      echo "  rm -rf ~/.claude/skills/plannotator-compound"
      echo ""
    fi
  '';
}
