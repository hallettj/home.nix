{ appimageTools
, fetchzip
}:

let
  version = "0.10.17";
  build = "665";
  tar_content = fetchzip {
    url = "https://releases.gitbutler.com/releases/release/${version}-${build}/linux/x86_64/git-butler_${version}_amd64.AppImage.tar.gz";
    hash = "sha256-BuONrcIx/LNbcsSFjrb/Lr0+NPY18NUTvdiUevBP9gA=";
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
