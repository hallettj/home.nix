{ config, lib, ... }:

{
  config = lib.mkIf config.gnomeExtensions.enable {
    dconf.settings = {
      "org/gnome/shell/extensions/paperwm" = {
        cycle-width-steps = [ 0.25 0.33329999999999999 0.5 0.66659999999999997 0.75 ];
        winprops = [
          ''{"wm_class":"kitty","preferredWidth":"25%"}''
          ''{"wm_class":"neovide","preferredWidth":"75%"}''
        ];
      };
    };
  };
}
