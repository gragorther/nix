{
  config,
  pkgs,
  osConfig,
  lib,
  pkgs-pr,
  ...
}:
let
  me = {
    email = "gregor@gregtech.eu";
  };
  firefox_desktop = pkgs.runCommand "firefox-desktop" { } ''
    sed '/^StartupWMClass=firefox$/d' \
      ${pkgs.firefox}/share/applications/firefox.desktop > "$out"
  '';
  #  lib = pkgs.lib;
in
{
  imports = lib.filesystem.listFilesRecursive ./modules;
  #  imports = [ pkgs.prismix.homeModules.default ];
  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "26.05";
  home.packages =
    with pkgs;
    [
      tor-browser
      kdePackages.isoimagewriter
      kdePackages.ghostwriter
      #    logseq
      ncdu
      ente-desktop
      bitwarden-cli
      bitwarden-desktop
      feishin
      openssl
      signal-desktop
      gparted
      #    prismlauncher
      whois
      ghc
      cabal-install
      haskell-language-server
      haskellPackages.hlint
      libreoffice-qt
      hunspell
      mpv
      nixfmt
      nixd
      dig
      bat
    ]
    ++ [ pkgs-pr.logseq_2 ];
  programs = {
    rbw.enable = true;
    git-credential-oauth.enable = true;
    git = {
      enable = true;
      settings = {
        user = {
          name = osConfig.users.users.gregor.description;
          email = me.email;
        };
        safe.directory = [ "/etc/nixos" ];
      };
    };
    firefox = {
      enable = true;
    };
    #    thunderbird = {
    #      enable = true;
    #      profiles.main = {
    #        isDefault = true;
    #        settings = {
    #          "extensions.autoDisableScopes" = 0;
    #        };
    #      };
    #    };
  };
  programs.bash.enable = true;
  home.sessionVariables = {
    SSH_AUTH_SOCK = "/home/gregor/.bitwarden-ssh-agent.sock";
  };
  xdg.dataFile."applications/firefox.desktop".source = firefox_desktop;
}
