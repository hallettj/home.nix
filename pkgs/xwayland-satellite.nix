# Modified from
# https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/by-name/xw/xwayland-satellite/package.nix
#
# I've modified this to expression to get the latest project commit, and to
# enable the "systemd" feature. When the package in nixpkgs is updated
# sufficiently the systemd feature can be enabled using the upstream expression
# like this:
#
#     {
#       overlays = final: prev: {
#         xwayland-satellite = prev.xwayland-satellite.overrideAttrs (oldAttrs: {
#           cargoBuildFeatures = oldAttrs.cargoBuildFeatures ++ [ "systemd" ];
#         });
#       }
#     }
#

{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, xwayland
, xcb-util-cursor
, libxcb
, nix-update-script
}:

rustPlatform.buildRustPackage {
  name = "xwayland-satellite-main";

  src = fetchFromGitHub {
    owner = "Supreeeme";
    repo = "xwayland-satellite";
    rev = "3140b7c83e0eade33abd94b1adac6a368db735f9"; # latest as of 2024-07-16
    hash = "sha256-RW++Divwh3BjY5MAR0pS7LftVtyvPsUhSB/l3fS7pUY=";
  };

  cargoHash = "sha256-N8pCYHoONGShlNr8llpNpkktFxn1QnxOvtHFrl8QVyw=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    xwayland
    libxcb
    xcb-util-cursor
  ];

  buildFeatures = [ "systemd" ];

  # disable Xwayland integration tests which need a running display server
  checkFlags = [
    "--exact"
    "--skip=copy_from_wayland"
    "--skip=copy_from_x11"
    "--skip=input_focus"
    "--skip=quick_delete"
    "--skip=reparent"
    "--skip=toplevel_flow"
    "--skip=different_output_position"
    "--skip=bad_clipboard_data"
  ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Rootless Xwayland integration to any Wayland compositor implementing xdg_wm_base";
    homepage = "https://github.com/Supreeeme/xwayland-satellite";
    license = licenses.mpl20;
    maintainers = with maintainers; [ if-loop69420 ];
    mainProgram = "xwayland-satellite";
    platforms = platforms.linux;
  };
}
