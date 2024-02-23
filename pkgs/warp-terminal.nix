{ appimageTools
, fetchurl
}:

appimageTools.wrapType2 rec {
  name = "warp-terminal";
  version = "v0.2024.02.20.08.01.stable_01";
  src = fetchurl {
    url = "https://releases.warp.dev/stable/${version}/Warp-x86_64.AppImage";
    hash = "sha256-541IHjrtUGzZwQh5+q4M27/UF2ZTqhznPX6ieh2nqUQ=";
  };
  extraPkgs = pkgs: [];
}
