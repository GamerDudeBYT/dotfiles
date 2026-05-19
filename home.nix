{ config, pkgs, unstable, ... }:
let
  dotfiles = "${config.home.homeDirectory}/nixos-dotfiles/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
  configs = {
    hypr = "hypr";
    waybar = "waybar";
    quickshell = "quickshell";
    matugen = "matugen";
    rofi = "rofi";
    swaync = "swaync";
    gtk3 = "gtk-3.0";
    gtk4 = "gtk-4.0";
    btop = "btop";
    satty = "satty";
    cava = "cava";
    ghostty = "ghostty";
    uwsm = "uwsm";
    zed = "zed";
  };
in
{
  home.username = "ethan";
  home.homeDirectory = "/home/ethan";
  home.stateVersion = "25.11";

  programs.bash = {
    enable = true;
    shellAliases = {
      btw = "echo i use hyprland btw";
      nrs = "sudo nixos-rebuild switch --flake ~/nixos-dotfiles#nixos";
      vim = "nvim";
    };
    profileExtra = ''
      if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
          exec uwsm start hyprland-uwsm.desktop
      fi
    '';
  };

  programs.fish = {
    enable = true;
    loginShellInit = ''
      if test -z "$WAYLAND_DISPLAY" && test "$XDG_VTNR" = 1
      exec uwsm start hyprland-uwsm.desktop
      end
    '';
    shellAliases = {
      nrs = "sudo nixos-rebuild switch --flake ~/nixos-dotfiles#nixos";
      nrsi = "sudo nixos-rebuild switch --flake ~/nixos-dotfiles#nixos --install-bootloader";
      nrsu = "sudo nixos-rebuild switch --flake ~/nixos-dotfiles#nixos --upgrade";
      nrbi = "sudo nixos-rebuild boot --flake ~/nixos-dotfiles#nixos --install-bootloader";
      audiovis = "~/nixos-dotfiles/scripts/launch_cava.sh";
    };
  };

  programs.zed-editor = {
    enable = true;
  };

  home.packages = with pkgs; [
    # Shell utilities
    (pkgs.writeShellApplication {
      name = "ns";
      runtimeInputs = with pkgs; [
        fzf
        (nix-search-tv.overrideAttrs {
          env.GOEXPERIMENT = "jsonv2";
        })
      ];
      text = ''exec "${pkgs.nix-search-tv.src}/nixpkgs.sh" "$@"'';
    })
    (pkgs.writeShellApplication {
      name = "wallset";
      runtimeInputs = [ pkgs.matugen pkgs.swww ];
      text = ''
        swww img "$1"
        matugen image "$1"
        notify-send "Wallpaper Changed" "$1"
      '';
    })
    (pkgs.writeShellApplication {
      name = "asm";
      runtimeInputs = [
        pkgs.nasm
        pkgs.binutils
      ];
      text = ''
        if [ -z "$1" ]; then
            echo "Usage: asm <file.asm | file> [program args...]"
            exit 1
        fi
        file="''${1%.asm}"
        asm_file="$file.asm"
        obj_file="$file.o"
        out_file="$file"
        shift
        if [ ! -f "$asm_file" ]; then
            echo "Error: $asm_file not found"
            exit 1
        fi
        nasm -f elf64 "$asm_file" -o "$obj_file"
        ld "$obj_file" -o "$out_file"
        rm "$obj_file"
        echo "✓ Built ./$out_file"
        echo "▶ Running:"
        exec "./$out_file" "$@"
      '';
    })

    # Media & entertainment
    spotify
    davinci-resolve
    cava

    # Communication
    discord
    whatsapp-electron
    teams-for-linux
    p3x-onenote

    # Productivity
    libreoffice

    # Tools with home config symlinks
    rofi
    rofimoji
    rofi-calc
    rofi-bluetooth
    satty
    ghostty
    btop

    # Fun
    chocolate-doom
    asciiquarium
    ascii

    # Rofi launchers
    tail-tray

    # Dev Tools
    godotPackages_4_6.godot
    unstable.arduino-ide
  ];

  xdg.configFile = builtins.mapAttrs
    (name: subpath: {
      source = create_symlink "${dotfiles}/${subpath}";
      recursive = true;
    })
    configs;
}
