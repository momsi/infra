{ config, pkgs, lib, ... }:

{
  # Time and locale
  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "de_DE.UTF-8";

  # German keyboard layout in initrd (LUKS prompt)
  boot.initrd.preDeviceCommands = ''
    loadkeys de
  '';

  # Nix
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # Firewall
  networking.firewall.enable = true;

  # Base packages
  environment.systemPackages = with pkgs; [
    git
    vim
    wget
    curl
    keepassxc
    brave
    kitty
    fuzzel
    waybar
  ];

  # Network
  networking.networkmanager.enable = true;

  # Audio
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Display Manager (autologin momsi)
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.hyprland}/bin/Hyprland --config /etc/xdg/hypr/hyprland.conf";
        user = "momsi";
      };
    };
  };

  # Hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # Hyprland config
  environment.etc."xdg/hypr/hyprland.conf".text = ''
    $terminal = kitty
    $menu = fuzzel
    $mainMod = SUPER

    bind = $mainMod, Return, exec, $terminal
    bind = $mainMod, Space, exec, $menu
    bind = $mainMod, Q, killactive,
    bind = $mainMod, F, fullscreen,
    bind = $mainMod SHIFT, M, exit,
    bind = $mainMod, V, togglefloating,
    bind = ALT, Tab, cyclenext,

    bindm = $mainMod, mouse:272, movewindow
    bindm = $mainMod, mouse:273, resizewindow

    exec-once = waybar
  '';

  # XDG portal for Wayland
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # Polkit
  security.polkit.enable = true;

  system.stateVersion = "25.11";
}