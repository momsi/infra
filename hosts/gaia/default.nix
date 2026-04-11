{ config, pkgs, lib, ... }:

{
  imports = [
    ../desktop.nix
    ./disko.nix
  ];

  networking.hostName = "gaia";

  # User
  users.users.momsi = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" ];
    # hashedPassword = "$6$..."; # Use: openssl passwd -6 <password>
    password = "p4ssw0rd"; # placeholder
  };

  # Boot (system-specific)
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
    enableCryptodisk = true;
  };
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.luks.reusePassphrases = true;

  hardware.graphics = {
    enable = true;
  };

  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

# Gaia-specific packages
  environment.systemPackages = with pkgs; [
    neofetch
    vscodium
    python3
    opencode
    nodejs
  ];

  # ZRAM swap (replaces traditional swap)
  zramSwap.enable = true;
  swapDevices = [];

  # AMD CPU microcode
  hardware.cpu.amd.updateMicrocode = lib.mkDefault true;

  # Keyboard layout - German
  console.keyMap = "de";
  services.xserver.xkb.layout = "de";

  # Git configuration
  programs.git = {
    enable = true;
    config = {
      user.name = "momsi";
      user.email = "momsi@gaia";
      core.editor = "vim";
    };
  };
}