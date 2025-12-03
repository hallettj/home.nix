{ config, lib, pkgs, inputs, outputs, ... }:

{
  imports = [
    outputs.homeManagerModules.screen-type
    outputs.homeManagerModules.useOutOfStoreSymlinks
    inputs.niri.homeModules.niri
    ../common.nix
    ../profiles/desktop
  ];

  screen-type.aspect-ratio = "ultrawide";

  # Increase font sizes - it's cleaner than applying a display scaling factor.
  dconf.settings."org/gnome/desktop/interface" = {
    text-scaling-factor = 1.25;
  };

  programs.kitty.extraConfig = ''
    font_size 12.0
  '';

  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    nerd-fonts.symbols-only
    inputs.ddn-cli-nix.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  # Use different colors on lock screen to help me see which partition I'm
  # logged into
  programs.swaylock.settings =
    let
      # Color palette generated from promptql-neon as a starting point
      # https://coolors.co/b6fc34-ffffff-922d50-000000-639fab
      promptql-neon = "b6fc34";
      quinacridone-magenta = "922d50";
      moonstone = "639fab";
      black = "000000";
      white = "ffffff";
    in
    lib.mkForce {
      color = black;
      font-size = 48;
      font = "Cantarell";

      indicator-radius = 160;
      indicator-thickness = 20;

      ring-color = white;
      inside-color = black;
      text-color = white;

      key-hl-color = promptql-neon;
      bs-hl-color = quinacridone-magenta;

      ring-clear-color = white;
      inside-clear-color = white;
      text-clear-color = black;

      # "ver" is short for "Verifying"
      ring-ver-color = moonstone;
      inside-ver-color = moonstone;
      text-ver-color = black;

      ring-wrong-color = quinacridone-magenta;
      inside-wrong-color = quinacridone-magenta;
      text-wrong-color = white;

      line-color = black;
      separator-color = black;

      ignore-empty-password = true;
      indicator-idle-visible = false;
      show-failed-attempts = true;
    };

  # Need to add niri to gdm session list manually - see notes below
  programs.niri = {
    enable = true;
    config = null; # don't write a config - one is linked in the features/niri module
  };

  # niri-session starts this service to run Niri
  systemd.user.services.niri = {
    Unit = {
      Description = "A scrollable-tiling Wayland compositor";
      BindsTo = [ "graphical-session.target" ];
      Before = [ "graphical-session.target" "xdg-desktop-autostart.target" ];
      Wants = [ "graphical-session-pre.target" "xdg-desktop-autostart.target" ];
      After = [ "graphical-session-pre.target" ];
    };
    Service = {
      Slice = "session.slice";
      Type = "notify";
      ExecStart = "${config.programs.niri.package}/bin/niri --session";
    };
  };

  # niri invokes this target to shut down
  systemd.user.targets.niri-shutdown = {
    Unit = {
      Description = "Shutdown running niri session";
      DefaultDependencies = "no";
      StopWhenUnneeded = true;
      Conflicts = [ "graphical-session.target" "graphical-session-pre.target" ];
      After = [ "graphical-session.target" "graphical-session-pre.target" ];
    };
  };

  # Enables settings that make Home Manager work better on GNU/Linux
  # distributions other than NixOS. This includes configuring GPU drivers for
  # programs that use hardware acceleration.
  #
  # Requires sudo access to host. A message appears when running `home-manager
  # switch` when necessary with a sudo command needed to set up GPU drivers.
  #
  # On Fedora I had to configure SELinux to authorize the unit that Home Manager installs:
  #
  #     sudo semanage fcontext -a -t systemd_unit_file_t '/nix/store/[^/]+/resources/non-nixos-gpu.service'
  #
  # See https://gist.github.com/matthewpi/08c3d652e7879e4c4c30bead7021ff73
  #
  targets.genericLinux.enable = true;

  home.useOutOfStoreSymlinks = true;

  home.stateVersion = "23.05"; # Please read the comment before changing.
}

# This configuration runs on a non-NixOS host which means there are some
# non-declarative setup steps required.
#
# Add Niri to the GDM session list. Create this file at
# /usr/share/wayland-sessions/niri.desktop, and run `chmod 644`:
#
#     [Desktop Entry]
#     Name=Niri
#     Comment=A scrollable-tiling Wayland compositor
#     Exec=/home/jesse/.nix-profile/bin/niri-session
#     Type=Application
#     DesktopNames=niri
#
# Install Cartograph CF font in ~/.local/share/fonts/
#
# Install system blueman-applet
#
# ## Special setup for swaylock:
#
# Install PAM config - this may need to be run again after dnf updates
#
#     sudo cp /home/jesse/.nix-profile/etc/pam.d/swaylock /etc/pam.d/
#
# The nixpkgs version of swaylock assumes a password-checking program is
# available at /run/wrappers/bin/unix_chkpwd, but on Fedora that program is at
# /sbin/unix_chkpwd. To fix this up create a symlink. But for the symlink to
# work it needs to be on a mount point that permits suid. So we create a special
# tmpfs mount point at /run/wrappers, and a systemd unit that creates the
# symlink on each boot.
#
# Create the mount point,
#
#     echo "tmpfs /run/wrappers tmpfs defaults,nodev,noatime,mode=755 0 0" | sudo tee -a /etc/fstab
#
# Install the systemd unit,
#
#     cat <<EOF | sudo tee /etc/systemd/system/install-unix_chkpwd-wrapper.service
#     [Unit]
#     After=run-wrappers.mount
#     Wants=run-wrappers.mount
#     
#     [Service]
#     Type=oneshot
#     ExecStart=/usr/bin/mkdir -p /run/wrappers/bin
#     ExecStart=/usr/bin/ln -sf /sbin/unix_chkpwd /run/wrappers/bin/unix_chkpwd
#     
#     [Install]
#     WantedBy=multi-user.target
#     EOF
#
# Enable the unit
#
#     systemctl enable install-unix_chkpwd-wrapper
#
# That procedure for setting up a link comes from
# https://github.com/NixOS/nixpkgs/issues/158025#issuecomment-1616807870
