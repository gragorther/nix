{
  config,
  pkgs,
  osConfig,
  # inputs,
  ...
}:
let
  me = {
    email = "gregor@gregtech.eu";
  };
in
{
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
    vscode = {
      enable = true;
      #   haskell = {
      #     enable = true;
      #   };
    };
    firefox = {
      enable = true;
    };
    prismlauncher = {
      enable = true;

      config.java = {
        path = "${pkgs.jdk25}/bin/java";
        mem = {
          min = 4096;
          max = 15000;
        };
      };

      instances.main = {
        minecraft.version = "26.3";
        icon = "creeper";
        group = "Releases";
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
