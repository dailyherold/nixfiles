{config, ...}: {
  programs.zed-editor = {
    enable = true;
    extensions = [
      "catppuccin"
    ];
    userSettings = {
      theme = {
        mode = "dark";
        dark = "Catppuccin Mocha";
        light = "Catppuccin Latte";
      };
    };
  };
}
