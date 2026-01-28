{ config, pkgs, ... }:
let
  dotfiles = "${config.home.homeDirectory}/nixos-dotfiles/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;

  configs = {
    hypr = "hypr";
    waybar = "waybar";
    wezterm = "wezterm";
    quickshell = "quickshell";
    matugen = "matugen";
    rofi = "rofi";
    swaync = "swaync";
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
      nrs = "sudo nixos-rebuild switch --flake ~/nixos-dotfiles#hyprland-btw";
      vim = "nvim";
    };
    profileExtra = ''
      if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
          exec uwsm start hyprland-uwsm.desktop
      fi
    '';
  };

  home.packages = with pkgs; [
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
            matugen image "$1"
        '';
    })


    quickshell

  ];

  programs.fish = {
    enable = true;
    shellAliases = {
      nrs = "sudo nixos-rebuild switch --flake ~/nixos-dotfiles#nixos";
      wallset = "";
    };
  };

  programs.wezterm = {
    enable = true;
  };

  xdg.configFile = builtins.mapAttrs
    (name: subpath: {
      source = create_symlink "${dotfiles}/${subpath}";
      recursive = true;
    })
    configs;
}
