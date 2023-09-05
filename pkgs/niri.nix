{ inputs
, pkg-config
, rust-bin
, system
, wlroots
}:

let
  rustToolchain = rust-bin.stable.latest.default;
  craneLib = inputs.crane.lib.${system}.overrideToolchain rustToolchain;
in
craneLib.buildPackage {
  src = inputs.niri-source;
  nativeBuildInputs = [
    pkg-config
  ];
  buildInputs = wlroots.buildInputs;
}
