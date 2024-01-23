{ hostPlatform
, fetchurl
, stdenvNoCC
}:
let
  # If you change this version you will have to update all of the hashes below.
  # You can get each hash by running:
  #
  #     $ nix store prefetch-file <url>
  #
  # Make sure to preserve the "sha256-" prefix when pasting here.
  version = "2024.01.15";
  src =
    if hostPlatform.system == "x86_64-linux" then
      {
        url = "https://graphql-engine-cdn.hasura.io/ddn/cli/${version}/cli-hasura3-linux-amd64";
        hash = "sha256-Y0ZeixmQ+MYm7GYZPLKp4gpNonyQ0xFbjAg23zdTm6I=";
      }
    else if hostPlatform.system == "x86_64-darwin" then
      {
        url = "https://graphql-engine-cdn.hasura.io/ddn/cli/${version}/cli-hasura3-darwin-amd64";
        hash = "sha256-tYRfTp+xLWbb8bDY+e79grhneV0bB2S76nb0kSJIzLc=";
      }
    else if hostPlatform.system == "aarch64-darwin" then
      {
        url = "https://graphql-engine-cdn.hasura.io/ddn/cli/${version}/cli-hasura3-darwin-arm64";
        hash = "sha256-AuERNYOUSSklkbYRNXTgrL6EXz/DGQStgNUpWJCPaH0=";
      }
    else
      builtins.throw "no hasuar3 cli builds available for system, ${hostPlatform.system}"
  ;
in
stdenvNoCC.mkDerivation {
  name = "hasura3";
  inherit version;
  src = fetchurl { inherit (src) url hash; };
  phases = [ "installPhase" "patchPhase" ];
  installPhase = ''
    mkdir -p "$out/bin"
    cp $src "$out/bin/hasura3"
    chmod +x "$out/bin/hasura3"
  '';
}
