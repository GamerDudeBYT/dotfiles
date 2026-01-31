{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  system.nixos.label = "NixOS";

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
    
    lanzaboote = {
        enable = true;
        pkiBundle = "/var/lib/sbctl";
    };
    #loader.limine = {
    #  enable = false;
    #  #efiSupport = true;
    #  secureBoot.enable = false;
    #  extraEntries = ''
    #    /Windows 11
    #     protocol: efi
    #     path: uuid(c9618cff-49a7-422f-949a-2ea48b87b2fe):/EFI/Microsoft/Boot/bootmgfw.efi
    #  '';
    #  style = {
    #    wallpapers = [
    #      ./wallpapers/NixOS/NixOS-Dark.png
    #    ];
    #  };
    #};

    plymouth = {
        enable = true;
        theme = "hexa_retro";
        themePackages = with pkgs; [
            (adi1090x-plymouth-themes.override {
                selected_themes = [ "hexa_retro" ];
            })
        ];
    };

    consoleLogLevel = 3;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "udev.log_level=3"
      "systemd.show_status=auto"
    ];


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
    extraConfig.pipewire."99-extra-config" = ''
context.modules = [
    { name = libpipewire-module-filter-chain
        flags = [ nofail ]
        args = {
            node.description = "Virtual Surround Sink"
            media.name       = "Virtual Surround Sink"
            filter.graph = {
                nodes = [
                    # duplicate inputs
                    { type = builtin label = copy name = copyFL  }
                    { type = builtin label = copy name = copyFR  }
                    { type = builtin label = copy name = copyFC  }
                    { type = builtin label = copy name = copyRL  }
                    { type = builtin label = copy name = copyRR  }
                    { type = builtin label = copy name = copySL  }
                    { type = builtin label = copy name = copySR  }
                    { type = builtin label = copy name = copyLFE }

                    # apply hrir - HeSuVi 14-channel WAV (not the *-.wav variants) (note: */44/* in HeSuVi are the same, but resampled to 44100)
                    { type = builtin label = convolver name = convFL_L config = { filename = "hrir_hesuvi/hrir.wav" channel =  0 } }
                    { type = builtin label = convolver name = convFL_R config = { filename = "hrir_hesuvi/hrir.wav" channel =  1 } }
                    { type = builtin label = convolver name = convSL_L config = { filename = "hrir_hesuvi/hrir.wav" channel =  2 } }
                    { type = builtin label = convolver name = convSL_R config = { filename = "hrir_hesuvi/hrir.wav" channel =  3 } }
                    { type = builtin label = convolver name = convRL_L config = { filename = "hrir_hesuvi/hrir.wav" channel =  4 } }
                    { type = builtin label = convolver name = convRL_R config = { filename = "hrir_hesuvi/hrir.wav" channel =  5 } }
                    { type = builtin label = convolver name = convFC_L config = { filename = "hrir_hesuvi/hrir.wav" channel =  6 } }
                    { type = builtin label = convolver name = convFR_R config = { filename = "hrir_hesuvi/hrir.wav" channel =  7 } }
                    { type = builtin label = convolver name = convFR_L config = { filename = "hrir_hesuvi/hrir.wav" channel =  8 } }
                    { type = builtin label = convolver name = convSR_R config = { filename = "hrir_hesuvi/hrir.wav" channel =  9 } }
                    { type = builtin label = convolver name = convSR_L config = { filename = "hrir_hesuvi/hrir.wav" channel = 10 } }
                    { type = builtin label = convolver name = convRR_R config = { filename = "hrir_hesuvi/hrir.wav" channel = 11 } }
                    { type = builtin label = convolver name = convRR_L config = { filename = "hrir_hesuvi/hrir.wav" channel = 12 } }
                    { type = builtin label = convolver name = convFC_R config = { filename = "hrir_hesuvi/hrir.wav" channel = 13 } }

                    # treat LFE as FC
                    { type = builtin label = convolver name = convLFE_L config = { filename = "hrir_hesuvi/hrir.wav" channel =  6 } }
                    { type = builtin label = convolver name = convLFE_R config = { filename = "hrir_hesuvi/hrir.wav" channel = 13 } }

                    # stereo output
                    { type = builtin label = mixer name = mixL }
                    { type = builtin label = mixer name = mixR }
                ]
                links = [
                    # input
                    { output = "copyFL:Out"  input="convFL_L:In"  }
                    { output = "copyFL:Out"  input="convFL_R:In"  }
                    { output = "copySL:Out"  input="convSL_L:In"  }
                    { output = "copySL:Out"  input="convSL_R:In"  }
                    { output = "copyRL:Out"  input="convRL_L:In"  }
                    { output = "copyRL:Out"  input="convRL_R:In"  }
                    { output = "copyFC:Out"  input="convFC_L:In"  }
                    { output = "copyFR:Out"  input="convFR_R:In"  }
                    { output = "copyFR:Out"  input="convFR_L:In"  }
                    { output = "copySR:Out"  input="convSR_R:In"  }
                    { output = "copySR:Out"  input="convSR_L:In"  }
                    { output = "copyRR:Out"  input="convRR_R:In"  }
                    { output = "copyRR:Out"  input="convRR_L:In"  }
                    { output = "copyFC:Out"  input="convFC_R:In"  }
                    { output = "copyLFE:Out" input="convLFE_L:In" }
                    { output = "copyLFE:Out" input="convLFE_R:In" }

                    # output
                    { output = "convFL_L:Out"  input="mixL:In 1" }
                    { output = "convFL_R:Out"  input="mixR:In 1" }
                    { output = "convSL_L:Out"  input="mixL:In 2" }
                    { output = "convSL_R:Out"  input="mixR:In 2" }
                    { output = "convRL_L:Out"  input="mixL:In 3" }
                    { output = "convRL_R:Out"  input="mixR:In 3" }
                    { output = "convFC_L:Out"  input="mixL:In 4" }
                    { output = "convFC_R:Out"  input="mixR:In 4" }
                    { output = "convFR_R:Out"  input="mixR:In 5" }
                    { output = "convFR_L:Out"  input="mixL:In 5" }
                    { output = "convSR_R:Out"  input="mixR:In 6" }
                    { output = "convSR_L:Out"  input="mixL:In 6" }
                    { output = "convRR_R:Out"  input="mixR:In 7" }
                    { output = "convRR_L:Out"  input="mixL:In 7" }
                    { output = "convLFE_R:Out" input="mixR:In 8" }
                    { output = "convLFE_L:Out" input="mixL:In 8" }
                ]
                inputs  = [ "copyFL:In" "copyFR:In" "copyFC:In" "copyLFE:In" "copyRL:In" "copyRR:In", "copySL:In", "copySR:In" ]
                outputs = [ "mixL:Out" "mixR:Out" ]
            }
            capture.props = {
                node.name      = "effect_input.virtual-surround-7.1-hesuvi"
                media.class    = Audio/Sink
                audio.channels = 8
                audio.position = [ FL FR FC LFE RL RR SL SR ]
            }
            playback.props = {
                node.name      = "effect_output.virtual-surround-7.1-hesuvi"
                node.passive   = true
                audio.channels = 2
                audio.position = [ FL FR ]
            }
        }
    }
]

    '';
  };

  services.libinput.enable = true;

  users.users.ethan = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      tree
    ];
  };

  hardware.bluetooth.enable = true;

  services.blueman.enable = true;

  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "ethan" ];
  };

  programs.firefox.enable = true;

  programs.fish.enable = true;

  programs.droidcam.enable = true;

  programs.steam.enable = true;
  
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
    wl-clipboard
    cliphist
    clipman
    wl-clip-persist
    nwg-clipman
    davinci-resolve
    godot
    brightnessctl
    bluez
    bluez-tools
    libreoffice
    spotify
    glib
    gtk3
    gtk4
    gsettings-desktop-schemas
    discord
    flatpak
    rofi-bluetooth
    kdePackages.dolphin
    quickshell
    btop
    whatsapp-electron
    rofimoji
    rofi-calc
    efibootmgr
    usbutils
    
    easyeffects
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.hurmit
  ];

  # Razer devices

  hardware.openrazer = {
    enable = true;
  };

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

