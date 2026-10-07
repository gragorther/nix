{ pkgs, ... }: {
  programs.prismlauncher = {
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
}
