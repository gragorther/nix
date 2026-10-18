{ pkgs, ... }: {
  programs.vscodium = {
    #package = pkgs.vscodium;
    #haskell = {enable };
    enable = true;
    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        jnoortheen.nix-ide
        haskell.haskell
      ];
    };
    profiles.default.userSettings = {
      "workbench.startupEditor" = "none";
      "nix.enableLanguageServer" = true;
      "nix.formatterPath" = "nixfmt";
      "nix.serverPath" = "nixd";
      "nix.serverSettings" = {
        # check https://github.com/oxalica/nil/blob/main/docs/configuration.md for all options available
        "nil" = {
          # "diagnostics": {
          #  "ignored": ["unused_binding", "unused_with"],
          # },
          "formatting" = {
            "command" = [
              "nixfmt"
            ];
          };
        };
        # check https://github.com/nix-community/nixd/blob/main/nixd/docs/configuration.md for all nixd config
        "nixd" = {
          "options" = {
            "home-manager" = {
              "expr" =
                "(builtins.getFlake (builtins.toString ./.)).nixosConfigurations.<name>.options.home-manager.users.type.getSubOptions []";
            };
          };
        };
      };
      "editor.formatOnSave" = true;
    };

  };
}
