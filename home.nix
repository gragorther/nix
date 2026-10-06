{
  config,
  pkgs,
  osConfig,
  lib,
  ...
}:
let
  me = {
    email = "gregor@gregtech.eu";
  };
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
  home.packages = with pkgs; [
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
  ];
  programs = {
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
    prismlauncher = {
      enable = true;

      config.java = {
        path = "${pkgs.jdk25}/bin/java";
        mem = {
          min = 4096;
          max = 15000;
        };
      };

      instances.sigma = {
        minecraft.version = "26.3";
        icon = "creeper";
        #group = "Releases";
        servers = [
          {
            ip = "minecraft.gregtech.eu";
            name = "GregTech";
          }
        ];
        mod = {
          loader = {
            name = "fabric";
            version = "0.19.5";
          };
        };
      };
    };
  };
  programs.bash.enable = true;
  home.sessionVariables = {
    SSH_AUTH_SOCK = "/home/gregor/.bitwarden-ssh-agent.sock";
  };
}
