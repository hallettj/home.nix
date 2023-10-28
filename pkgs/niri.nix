{
  # inputs from the flake in the root of this repo. Flake inputs provide the Niri
  # source code, crane (creating a derivation from a Rust project), and an overlay
  # that sets up `pkgs.rust-bin`.
  inputs

, clang
, lib
, libclang
, libGL
, makeDesktopItem
, makeWrapper
, pipewire
, pkg-config
, rust-bin
, system
, wlroots
, xorg
}:

let
  rustToolchain = rust-bin.stable.latest.default;
  craneLib = inputs.crane.lib.${system}.overrideToolchain rustToolchain;

  launcher = makeDesktopItem {
    name = "Niri";
    comment = "A scrollable-tiling Wayland compositor";
    exec = "niri";
    type = "Application";
    desktopName = "niri";
  };
in
craneLib.buildPackage {
  src = inputs.niri-source;

  nativeBuildInputs = [
    clang
    makeWrapper
    pkg-config
  ];

  buildInputs = wlroots.buildInputs ++ [
    pipewire
    xorg.libXcursor
    xorg.libXi

    # from github issue
    xorg.libX11
    xorg.libXrandr
    # libGL
    libGL.dev # do we need this one?
  ];

  LIBCLANG_PATH = "${libclang.lib}/lib";
  # LD_LIBRARY_PATH = "${lib.makeLibraryPath buildInputs}";
  WINIT_UNIX_BACKEND = "wayland";

  passthru.providedSessions = [ "Niri" ];

  postInstall = ''
    # Set library path so that Niri can find dynamically-loaded libraries.
    wrapProgram $out/bin/niri \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [libGL]}

    mkdir -p $out/share/wayland-sessions/
    cp ${launcher}/share/applications/Niri.desktop $out/share/wayland-sessions/
  '';
}
