{pkgs, ...}: {
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
              name = "heli-gemini-2-5-flash-lite";
            };
          };
        };
      };
      model = "helicone/gemini-3-pro";
      small_model = "helicone/gemini-2-5-flash-lite";
    };
  };
}
