{
  config,
  lib,
  ...
}: {
  home.sessionVariables = {
    XCURSOR_THEME = "${config.home.pointerCursor.name}";
    XCURSOR_SIZE = "${builtins.toString config.home.pointerCursor.size}";
  };
}
