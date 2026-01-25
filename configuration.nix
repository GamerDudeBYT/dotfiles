{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  boot = {
    loader.systemd-boot.enable = lib.mkForce false;
    loader.grub.enable = lib.mkForce false;

    loader.efi.canTouchEfiVariables = true;
    
    loader.limine = {
      enable = true;
      #efiSupport = true;
      secureBoot.enable = false;
      #extraEntries = ''
      #  \Windows
      #   protocol: efi
      #   path: boot():/EFI/Microsoft/Boot/bootmgfw.efi
      #'';
      style = {
        wallpapers = [
          ./wallpapers/NixOS/NixOS-Dark.png
	];
      };
    };
  };

  networking.hostName = "nixos"; # Define your hostname.
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/London";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  services.getty.autologinUser = "ethan";

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    withUWSM = true;
  };

  console.keyMap = "uk";

  services.printing.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.libinput.enable = true;

  users.users.ethan = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      tree
    ];
  };

  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "ethan" ];
  };

  programs.firefox.enable = true;

  programs.fish.enable = true;
  
  environment.systemPackages = with pkgs; [
    vim
    wget
    neovim
    kitty
    waybar
    git
    hyprpaper
    nautilus
    pavucontrol
    sbctl # for limine
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.hurmit
  ];

  # Fix Driver Errors
  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.open = true;
  hardware.nvidia.modesetting.enable = true;

  nixpkgs.config.allowUnfree = true;

  services.openssh.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ]; 

  system.stateVersion = "25.11";

}

