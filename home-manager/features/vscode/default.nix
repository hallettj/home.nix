{ ... }:

{
  programs.vscode = {
    enable = true;
  };

  home.file.vscode-argv = {
    target = ".vscode/argv.json";
    text = builtins.toJSON {
      enable-crash-reporter = true;
      crash-reporter-id = "c93a0a9e-2861-4c1a-bda5-7cff36314259";
      password-store = "gnome-libsecret"; # vscode isn't detecting gnome-keyring automatically
    };
  };
}
