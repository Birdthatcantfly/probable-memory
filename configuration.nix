# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  #services.clamav.daemon.enable  = true;
  
#Zram
zramSwap.enable = true;
zramSwap.memoryPercent = 200;

#EarlyOOM
services.earlyoom.enable = true;

#Cpufreq
services.auto-cpufreq.enable = true;

 #Ananicy
 services.ananicy = {
            enable = true;
            package = pkgs.ananicy-cpp;
 };
 
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.supportedFilesystems = [ "ntfs" ];
  #Kernel 
  boot.kernelPackages = pkgs.linuxPackages_lqx;
  
  networking.hostName = "nixos-kira"; # Define your hostname.

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Moscow";

  # Select internationalisation properties.
  i18n.defaultLocale = "ru_RU.utf8";

  # Enable the X11 windowing system.
  services.xserver.enable = true;

services.xserver.videoDrivers = [ "nvidia" ];

#Vulkan
  hardware.opengl.enable = true;
  hardware.opengl.driSupport = true;
  hardware.opengl.driSupport32Bit = true;
  hardware.opengl.extraPackages = with pkgs; [ libvdpau-va-gl vaapiVdpau  ];
  hardware.opengl.extraPackages32 = with pkgs.pkgsi686Linux;
    [ libva libvdpau-va-gl vaapiVdpau ]
    ++ lib.optionals config.services.pipewire.enable [ pipewire ];
  hardware.opengl.setLdLibraryPath = true;
  hardware.pulseaudio.support32Bit = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.lxqt.enable = true;

  # Enable the GNOME Desktop Environment.
  #services.xserver.displayManager.gdm.enable = true;
  #  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Enable CUPS to print documents.
#  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  #sudo
 security.sudo.enable = true;
 security.sudo.wheelNeedsPassword = false;
 
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.kira = {
    isNormalUser = true;
    description = "Kira Jostar";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      
    ];
  };

  #NUR
  nixpkgs.config.packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
     inherit pkgs;
    };
  };

#Steam
programs.steam.enable = true;
  programs.gamemode.enable = true;

  # Enable automatic login for the user.
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "kira";

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    librewolf-wayland
#Games
wine-staging
      lutris
      protonup
#Networking
      tribler
#nheko
      element-desktop
#Office
      onlyoffice-bin
    winetricks
    git

  ];

  nix.gc = {
  automatic = true;
  dates = "weekly";
  options = "--delete-older-than 1d";
};

 
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?
  #Autoupgrade
  system.autoUpgrade.enable = true;
  system.autoUpgrade.dates =  "20:00";

}
