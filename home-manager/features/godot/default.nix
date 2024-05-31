{ pkgs, ... }:

# I'm learning Godot with Erik
{
  home.packages = with pkgs; [
    # Learning Godot with Erik
    gitg
    godot_4
    pixelorama
  ];
}
