# xwayland-satellite provides rootless Xwayland integration for Wayland
# compositors.
{ pkgs, ... }:

{
  home.packages = with pkgs; [
    xwayland-satellite
  ];

  systemd.user.services.xwayland-satellite = {
    Unit = {
      Description = "Xwayland outside your Wayland";
      BindsTo = "graphical-session.target";
      PartOf = "graphical-session.target";
      After = "graphical-session.target";
      Requisite = "graphical-session.target";
    };
    Service = {
      Type = "notify";
      NotifyAccess = "all";
      Environment = "PATH=${pkgs.xwayland}/bin";
      ExecStart = "${pkgs.xwayland-satellite}/bin/xwayland-satellite";
      StandardOutput = "journal";
    };
    Install.WantedBy = [ "niri.service" ];
  };
}
