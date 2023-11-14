{ src # src comes from a flake input which is expected to have a `lastModifiedDate` attribute
, lib
, stdenv
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "monaspace";
  version = src.lastModifiedDate;
  inherit src;

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/share/fonts"
    cp -r fonts/variable "$out/share/fonts/"

    runHook postInstall
  '';

  meta = {
    homepage = "https://monaspace.githubnext.com/";
    description = "The Monaspace type system is a monospaced type superfamily with some modern tricks up its sleeve. It consists of five variable axis typefaces. Each one has a distinct voice, but they are all metrics-compatible with one another, allowing you to mix and match them for a more expressive typographical palette.";
    changelog = "https://github.com/githubnext/monaspace/releases";
    platforms = lib.platforms.all;
  };
})
