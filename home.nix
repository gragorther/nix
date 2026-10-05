{
  config,
  pkgs,
  osConfig,
  ...
}:
let
  me = {
    email = "gregor@gregtech.eu";
  };
in
{
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

  };
  programs.bash.enable = true;
  home.sessionVariables = {
    SSH_AUTH_SOCK = "/home/gregor/.bitwarden-ssh-agent.sock";
  };
}
