{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  boot = {
    extraModulePackages = with config.boot.kernelPackages; [
      v4l2loopback.out
    ];

    kernelModules = [ "v4l2loopback" "snd-aloop" ];
    extraModprobeConfig = ''
      options v4l2loopback exclusive_caps=1 card_label="Virtual Camera"
    '';

    loader.systemd-boot.enable = lib.mkForce false;
    loader.grub.enable = lib.mkForce false;    

    loader.efi.canTouchEfiVariables = true;
    
    loader.limine = {
      enable = true;
      #efiSupport = true;
      secureBoot.enable = false;
      extraEntries = ''
        /Windows 11
         protocol: efi
         path: uuid(c9618cff-49a7-422f-949a-2ea48b87b2fe):/EFI/Microsoft/Boot/bootmgfw.efi
      '';
      style = {
        wallpapers = [
          ./wallpapers/NixOS/NixOS-Dark.png
	];
      };
    };
  };

  networking.hostName = "nixos"; # Define your hostname.
  networking.networkmanager.enable = true;

  networking.firewall.enable = false;

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

  programs.droidcam.enable = true;
  
  environment.systemPackages = with pkgs; [
    vim
    wget
    neovim
    kitty
    waybar
    git
    hyprpicker
    nautilus
    pavucontrol
    sbctl
    matugen
    swww
    vscode
    nwg-look
    rofi
    teams-for-linux
    swaynotificationcenter
    libnotify
    cliphist
    clipman
    wl-clip-persist
    davinci-resolve
    godot
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

