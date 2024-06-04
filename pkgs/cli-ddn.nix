# Hasura cli-ddn
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
  version = "2024.03.28";
  src =
    if hostPlatform.system == "x86_64-linux" then
      {
        url = "https://graphql-engine-cdn.hasura.io/ddn/cli/${version}/cli-hasura3-linux-amd64";
        hash = "sha256-wN16p1aUyq4tmkhsUaI6RopAF8wKMWpjssGU/p+X3Oc=";
      }
    else if hostPlatform.system == "x86_64-darwin" then
      {
        url = "https://graphql-engine-cdn.hasura.io/ddn/cli/${version}/cli-hasura3-darwin-amd64";
        hash = "sha256-dzQVv42VpYcR/0js+VYVV/yKFT1UxDxwtNCfgJuWAuA=";
      }
    else if hostPlatform.system == "aarch64-darwin" then
      {
        url = "https://graphql-engine-cdn.hasura.io/ddn/cli/${version}/cli-hasura3-darwin-arm64";
        hash = "sha256-Peue4UlUJU6iG6uQyu+CT42amziRRJec+edIU7BQie8=";
      }
    else
      builtins.throw "no hasuar3 cli builds available for system, ${hostPlatform.system}"
  ;
in
stdenvNoCC.mkDerivation {
  name = "ddn";
  inherit version;
  src = fetchurl { inherit (src) url hash; };
  phases = [ "installPhase" "patchPhase" ];
  installPhase = ''
    mkdir -p "$out/bin"
    cp $src "$out/bin/ddn"
    chmod +x "$out/bin/ddn"
  '';
}
