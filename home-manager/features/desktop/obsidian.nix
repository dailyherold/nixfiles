{config, ...}: {
  programs.obsidian = {
    enable = true;
    cli.enable = true;
    defaultSettings.appearance = {
      baseFontSize = 40;
      translucency = false;
      accentColor = "";
      monospaceFontFamily = config.fontProfiles.monospace.family;
      textFontFamily = config.fontProfiles.regular.family;
      interfaceFontFamily = config.fontProfiles.monospace.family;
    };
    vaults = {
      "Documents/obsidian/dailyherold" = {};
      "Documents/obsidian/agents" = {};
    };
  };
}
