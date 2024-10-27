{ pkgs, ... }:

{
  home.packages = with pkgs; [
    localsend # send data over local network
  ];

  systemd.user.services.localsend = {
    Install.WantedBy = [ "tray.target" ];
    Service.ExecStart = "${pkgs.localsend}/bin/localsend_app --hidden";
    Unit = {
      Description = "An open source cross-platform alternative to AirDrop";
      After = "graphical-session-pre.target";
      PartOf = "graphical-session.target";
      Requires = "tray.target";
    };
  };
}
