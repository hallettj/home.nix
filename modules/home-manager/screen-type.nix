{ lib, ... }:

with lib;
{
  options.screen-type = {
    aspect-ratio = mkOption {
      type = types.enum [ "full" "wide" "ultrawide" "super-ultrawide" ];
      default = "wide";
      description = ''
        Specify the aspect ratio of the screen used on the target machine. This
        setting doesn't do anything by itself, but can be read by other options
        to tweak configurations.

        Options are:
        - "full"            : 4:3 (old-fashioned displays)
        - "wide"            : 16:10 or 16:9 or similar (typical modern displays)
        - "ultrawide"       : 21:9 or so
        - "super-ultrawide" : 32:9 or so
      '';
    };
  };
}
