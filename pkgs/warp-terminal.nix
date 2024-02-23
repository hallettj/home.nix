{ appimageTools
, fetchurl
}:

appimageTools.wrapType2 rec {
  name = "warp-terminal";
  version = "v0.2024.02.20.08.01.stable_02";
  src = fetchurl {
    url = "https://releases.warp.dev/stable/${version}/Warp-x86_64.AppImage";
    hash = "sha256-p9aLcV20BDJIk4phjXXerSD9b2AwKdbjWSQIs5m7Wsc=";
  };
  extraPkgs = pkgs: [];
}
