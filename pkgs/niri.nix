{
  # inputs from the flake in the root of this repo. Flake inputs provide the Niri
  # source code, crane (creating a derivation from a Rust project), and an overlay
  # that sets up `pkgs.rust-bin`.
  inputs

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
