{ pkgs, ... }:

# I'm learning Godot with Erik
{
  home.packages = with pkgs; [
    # Learning Godot with Erik
    gitg
    unstable.godot_4
    pixelorama
  ];
}
