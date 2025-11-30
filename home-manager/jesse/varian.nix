{ lib, pkgs, inputs, outputs, ... }:

{
  imports = [
    outputs.homeManagerModules.screen-type
    ../common.nix
    ../profiles/desktop
    ../features/mesa
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

  home.useOutOfStoreSymlinks = true;

  home.stateVersion = "23.05"; # Please read the comment before changing.
}

# This configuration runs on a non-NixOS host which means there are some
# non-declarative setup steps required.
#
# Niri is installed by a system package, which sets up GDM, portals, etc.
#
# Install Cartograph CF font in ~/.local/share/fonts/
#
# Install system blueman-applet
#
# ## Special setup for swaylock:
#
# Install PAM config
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
