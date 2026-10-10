{
  inputs = {
    # This is pointing to an unstable release.
    # If you prefer a stable release instead, you can change the word unstable to the latest number shown here: https://nixos.org/download
    # i.e. nixos-24.11
    # Use `nix flake update` to update the flake to the latest revision of the chosen release channel.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    firefox-addons = {
      url = "git+https://gitlab.com/rycee/nur-expressions.git?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    prismix = {
      url = "git+https://codeberg.org/OliMoli/prismix.git";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sopsidy.url = "github:timewave-computer/sopsidy";
    sopsidy.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      plasma-manager,
      prismix,
      sopsidy,
      ...
    }:
    let
      pkgs = import nixpkgs {
        system = "x86_64-linux";
      };
    in
    {

      # NOTE: 'nixos' is the default hostname
      nixosConfigurations.gregor-nix = nixpkgs.lib.nixosSystem {
        modules = [
          inputs.sops-nix.nixosModules.default
          inputs.sopsidy.nixosModules.default
          ./configuration.nix
          home-manager.nixosModules.default
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = { inherit inputs; }; # If you want access to inputs in your home.nix
              users.gregor = ./home.nix; # replace <USERNAME> with your actual username
              sharedModules = [
                plasma-manager.homeModules.plasma-manager
                prismix.homeModules.default
                ({ pkgs, ... }: {
                  home.stateVersion = "26.05";
                  programs.rbw = {
                    enable = true;
                    settings = {
                      email = "gregor@gregtech.eu";
                      base_url = "https://vaultwarden.gregtech.eu";
                      pinentry = pkgs.pinentry-qt;
                    };
                  };
                })
              ];
            };
          }

        ];

        #      extraSpecialArgs = {
        #        # This can also be useful
        #        inherit inputs;
        #      };
      };
      packages.x86_64-linux.collect-secrets = sopsidy.lib.buildSecretsCollector {
        inherit pkgs;
        hosts = self.nixosConfigurations;
      };
    };

}
