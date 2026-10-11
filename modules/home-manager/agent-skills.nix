# Central agent skills (agentskills.io spec) linking for all agent harnesses.
#
# Each source is a directory whose immediate children are skill dirs (containing
# SKILL.md). Sources may use shell globs, expanded at activation time, so new
# repos cloned under a glob are picked up on the next switch. Every skill is
# symlinked individually into each target, which stays a real directory so
# harness-owned state (e.g. Claude Code's synced/) never lands in a source repo.
{
  lib,
  config,
  ...
}: let
  cfg = config.agentSkills;

  hasGlob = s: builtins.match ".*[*?[].*" s != null;

  # Longest leading path without glob characters, e.g. ~/src/*/skills -> ~/src
  globRoot = src: let
    parts = lib.splitString "/" src;
    idx = lib.lists.findFirstIndex hasGlob (builtins.length parts) parts;
  in
    lib.concatStringsSep "/" (lib.take idx parts);
in {
  options.agentSkills = {
    enable = lib.mkEnableOption "centrally managed agent skills";

    sources = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = ''
        Ordered absolute paths to skill source directories; shell globs allowed.
        On a skill name collision the first source wins and a warning is printed.
      '';
      example = ["/home/me/dev/ai/skills" "/home/me/dev/work/src/*/skills"];
    };

    targets = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "Harness skill directories, relative to $HOME.";
      example = [".claude/skills"];
    };

    roots = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      readOnly = true;
      default = lib.unique (map globRoot cfg.sources);
      description = "Glob-free parent dirs of all sources, e.g. for sandbox mounts.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.activation.agentSkills = lib.hm.dag.entryAfter ["linkGeneration"] ''
      shopt -s nullglob
      declare -A agentSkill=()
      agentSkillOrder=()

      # Resolve skills across sources, first source wins
      for src in ${lib.concatStringsSep " " cfg.sources}; do
        for dir in "$src"/*/; do
          dir="''${dir%/}"
          [[ -f "$dir/SKILL.md" ]] || continue
          name="''${dir##*/}"
          if [[ -n "''${agentSkill[$name]:-}" ]]; then
            echo "WARNING: agent skill '$name' in $src shadowed by ''${agentSkill[$name]}"
            continue
          fi
          agentSkill[$name]="$dir"
          agentSkillOrder+=("$name")
        done
      done

      for target in ${lib.escapeShellArgs (map (t: "${config.home.homeDirectory}/${t}") cfg.targets)}; do
        # Migrate from the old whole-dir symlink layout
        if [[ -L "$target" ]]; then
          run rm "$target"
        fi
        run mkdir -p "$target"

        # Drop links we manage (anything pointing into a source root)
        for link in "$target"/*; do
          [[ -L "$link" ]] || continue
          dest="$(readlink "$link")"
          for root in ${lib.escapeShellArgs cfg.roots}; do
            if [[ "$dest" == "$root"/* ]]; then
              run rm "$link"
              break
            fi
          done
        done

        for name in "''${agentSkillOrder[@]}"; do
          if [[ -e "$target/$name" || -L "$target/$name" ]]; then
            echo "WARNING: $target/$name exists and is not managed by agentSkills; skipping"
            continue
          fi
          run ln -s "''${agentSkill[$name]}" "$target/$name"
        done
      done
    '';
  };
}
