{pkgs, ...}: {
  home.packages = let
    scarlett =
      pkgs.writers.writePython3Bin "scarlett" {
        flakeIgnore = ["E275" "E501" "E712" "E265" "E266" "E305" "E302" "W291" "W391"];
      }
      ./scripts/scarlett.py;
  in [
    scarlett
  ];
}
