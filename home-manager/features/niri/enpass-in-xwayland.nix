# Wrapper script to run Enpass in an Xwayland window via i3. I'm not able to run
# Enpass in native Wayland mode. This is a workaround to get it running in
# a window manager that does not support Xwayland in rootless mode.
{ enpass
, i3
, writeShellApplication
, xwayland
}:

let
  i3config = ./i3/config-enpass; 
in
writeShellApplication {
  name = "enpass-in-xwayland";
  runtimeInputs = [ enpass i3 xwayland ];
  text = ''
    Xwayland &

    env DISPLAY=:0 i3 -c "${i3config}"

    # Stop Xwayland
    pkill -P $$
  '';
}
