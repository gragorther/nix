# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  config,
  lib,
  pkgs,
  ...
}:

{

  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];
  nixpkgs.config.allowUnfree = true;
  #  programs.firefox.enable = true;
  programs.steam.enable = true;
  #  programs.thunderbird.enable = true;
  programs.localsend.enable = true;
  programs.gamemode.enable = true;
  services.flatpak.enable = true;
  programs.nano = {
    enable = true;
    syntaxHighlight = true;
  };
  environment.systemPackages = with pkgs; [ pinentry-qt ];
  #  environment.systemPackages = with pkgs; [
  #    openssl
  #    signal-desktop
  #    gparted
  #    prismlauncher
  #    whois
  #    ghc
  #    cabal-install
  #    haskell-language-server
  #    haskellPackages.hlint
  #    libreoffice-qt
  #    hunspell
  #    mpv
  #    nixfmt
  #    #    hunspellDicts.sl_SI
  #    #    hunspellDicts.en_GB
  #  ];

  sops = {
    hostPubKey = "age1eecfk9ncl6v76s49k72jegxheje5u5shf7tchll9w4pwdphjtgwsyas4pt";
    defaultSopsFile = "/etc/secrets.yaml";
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    validateSopsFiles = false;
  };
  sops.secrets."dav" = {
    collect = {
      rbw.id = "Radicale";
    };
    owner = "gregor";
    mode = "0400";
  };
  sops.secrets."email" = {
    collect.rbw.id = "purelymail.com";
    owner = "gregor";
    mode = "0400";
  };
  systemd.sleep.settings.Sleep = {
    AllowSuspend = "yes";
    AllowHibernation = "no";
    AllowHybridSleep = "no";
    AllowSuspendThenHibernate = "no";
  };
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  services.displayManager.autoLogin = {
    enable = true;
    user = "gregor";
  };
  # services.displayManager.autoLogin.user = "gregor";
  security.pki.certificateFiles = [
    ./wisekey.pem
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.kernelModules = [
    "dm-snapshot"
    "cryptd"
  ];
  #  boot.initrd.luks.devices = {"cryptroot1" = {device = "/dev/disk/by-uuid/00190075-9188-46cc-8171-81ee1ac9e356"; }; {"cryptroot2" = {device = "/dev/disk/by-uuid/b8731852-f20c-47c1-8cf9-4fde23761384";};}}

  #boot.initrd.luks.reusePassphrases = true;
  boot.initrd.systemd.emergencyAccess = true;

  boot.initrd.systemd.enable = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "gregor-nix"; # Define your hostname.

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Ljubljana";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";
  #i18n.extraLocales = ["sl_SI/UTF-8"];
  # i18n.extraLocaleSettings = {
  #     LC_ALL = "sl_SI.UTF-8"; # This overrides all other LC_* settings.
  # };
  i18n.extraLocaleSettings = {
    # LC_ALL = "en_US.UTF-8"; # This overrides all other LC_* settings.
    LC_CTYPE = "sl_SI.UTF-8";
    LC_ADDRESS = "sl_SI.UTF-8";
    LC_MEASUREMENT = "sl_SI.UTF-8";
    LC_MESSAGES = "en_GB.UTF-8";
    LC_MONETARY = "sl_SI.UTF-8";
    LC_NAME = "sl_SI.UTF-8";
    LC_NUMERIC = "sl_SI.UTF-8";
    LC_PAPER = "sl_SI.UTF-8";
    LC_TELEPHONE = "sl_SI.UTF-8";
    LC_TIME = "sl_SI.UTF-8";
    LC_COLLATE = "sl_SI.UTF-8";
  };

  console = {
    font = "Lat2-Terminus16";
    #     keyMap = "si";
    useXkbConfig = true; # use xkb.options in tty.
  };

  # Enable the X11 windowing system.
  #  services.xserver.enable = true;

  services = {
    desktopManager.plasma6 = {
      enable = true;
      #    enableQt5Integration = true; #disable for qt6 full version
    };
    displayManager = {
      defaultSession = "plasma";
      sddm = {
        enable = true;
        wayland.enable = true;
      };
    };
  };

  hardware.graphics.enable = true;

  # Configure keymap in X11
  services.xserver.xkb.layout = "si";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.gregor = {
    isNormalUser = true;
    description = "Gregor Podjed";
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      tree
    ];
  };

  #programs.firefox.enable = true;

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  # environment.systemPackages = with pkgs; [
  #   vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #   wget
  # ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "26.05"; # Did you read the comment?

}
