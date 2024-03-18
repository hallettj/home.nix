{ appimageTools
, fetchzip
}:

let
  version = "0.10.24";
  build = "718";
  tar_content = fetchzip {
    url = "https://releases.gitbutler.com/releases/release/${version}-${build}/linux/x86_64/git-butler_${version}_amd64.AppImage.tar.gz";
    hash = "sha256-3kNEOlp9aBrA/4VldIgz2lcsSTTynxfRj2Rchv4Dkyg=";
  };
  name = "git-butler";
  src = "${tar_content}/git-butler_${version}_amd64.AppImage";
in
appimageTools.wrapType2 {
  inherit name src;
  version = "${version}-${build}";
  extraPkgs = pkgs: with pkgs; [
    libthai
  ];
  passthru.appimage_content = appimageTools.extract { inherit name src; };
}
