{ fetchFromGitHub
, stdenvNoCC
}:

let
  src = fetchFromGitHub {
    owner = "catppuccin";
    repo = "warp";
    rev = "1d4bef101a85451aeae6ce440803c31424746d15";
    hash = "sha256-s2DIO5ZKHL5od3EUyuvAUqSxvQHvDvgepP24z+Sb1As=";
  };
in
stdenvNoCC.mkDerivation {
  inherit src;
  name = "catppuccin-warp-terminal";
  phases = [ "installPhase" "patchPhase" ];
  installPhase = ''
    mkdir -p "$out/share/warp-terminal/themes"
    cp "$src"/dist/* "$out/share/warp-terminal/themes/"
  '';
}
