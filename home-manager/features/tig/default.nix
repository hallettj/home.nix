{ pkgs, ... }:

let
  colorscheme = builtins.fetchGit {
    url = "https://github.com/edentsai/tig-theme-molokai-like.git";
    rev = "24dfc9fd74c14056b8d0e3dc47e3fd690d875394";
  };
in
{
  home.packages = with pkgs; [
    tig
  ];

  xdg.configFile."tig/config".text = ''
    source ${colorscheme}/colors/molokai-like-theme.tigrc
  '';
}
