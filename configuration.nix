# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
 
  boot.initrd.kernelModules = [ "amdgpu" ];
 
  security.polkit.enable = true;

  services.udev.packages = with pkgs; [
    via
  ];
  networking.hostName = "dreadnought"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.
  # Set your time zone.
  time.timeZone = "America/Chicago";
  
  networking.interfaces.enp5s0.wakeOnLan.enable = true;
  networking.interfaces.tailscale0.wakeOnLan.enable = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  services = {
    desktopManager.plasma6.enable = true;
    xserver = {
      enable = true;
      videoDrivers = [ "amdgpu" ];
    #   desktopManager.gnome = {
    #     enable = true;
    #   };
      #  displayManager.gdm.enable = true;
    };
    displayManager.sddm.enable = true;
  };
  
  programs.ssh.askPassword = pkgs.lib.mkForce "${pkgs.ksshaskpass.out}/bin/ksshaskpass";

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1"; 
    QT_QPA_PLATFORMTHEME = "qt6ct";
  };
 
  nixpkgs.config.allowUnfree = true;

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  hardware.pulseaudio.enable = false;
  # OR
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
    wireplumber.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.muell = {
    isNormalUser = true;
    initialPassword = "Extrallian";
    extraGroups = [ "wheel"  "gamemode" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      tree
    ];
  };
  users.defaultUserShell = pkgs.zsh;
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    git
    protonup-qt
    gnome.gnome-tweaks
    prismlauncher
    liberation_ttf
    lutris
    v4l-utils
    adb-sync
    easyeffects
    sunshine
    vesktop
    solaar
    corectrl
    brave
    latte-dock
    uxplay
    killall
    glib
    papirus-icon-theme
    networkmanagerapplet
    kdePackages.plasma-pa
    kdePackages.qtstyleplugin-kvantum
    gnome.gnome-remote-desktop
    gnome.gnome-control-center
    gnomeExtensions.dash-to-panel
    gnomeExtensions.appindicator
    BeatSaberModManager 
    plexamp
    yt-dlp
    stow
    wineWowPackages.stable
 
    # Stuff for Hyprland
    eww
    kitty
    qt6ct
    qt5ct
    rofi-wayland
    waybar
    wlogout
    hyprcursor
    dunst
    kdePackages.polkit-kde-agent-1

    # Wallpaper
    #swww
    hyprpaper
  ];

  programs.hyprland.enable = true;
  programs.nix-ld.enable = true;
  services.gnome.gnome-keyring.enable = true;
  programs.alvr.enable = true; 
  services.flatpak.enable = true;
  programs.nm-applet.enable = true;
  programs.dconf.enable = true;
  
  programs.steam = {
    enable = true;
    };

  nixpkgs.config.packageOverrides = pkgs: { steam = pkgs.steam.override { extraPkgs = pkgs: with pkgs; [ libgdiplus keyutils libkrb5 libpng libpulseaudio libvorbis stdenv.cc.cc.lib xorg.libXcursor xorg.libXi xorg.libXinerama xorg.libXScrnSaver ]; }; };

  programs.firefox.enable = true;
  programs.gamemode.enable = true;
  programs.gamescope.enable = true; 
  services.sunshine.enable = true;
  services.sunshine.capSysAdmin = true;
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
  
    shellAliases = {
      update = "sudo nixos-rebuild switch";
      nixconf = "sudo vim /etc/nixos/configuration.nix";
      hyprconf = "vim ~/.config/hypr/hyprland.conf";
    };
    ohMyZsh = {
      enable = true;
      plugins = [ "git" "sudo" ];
      theme = "robbyrussell";
    };
  };
 

  fonts.packages = with pkgs; [
    nerdfonts
    noto-fonts
    liberation_ttf
  ];
  
  # Tailscale for home server
  services.tailscale = {
    enable = true;
  };
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  networking.firewall = {
    enable = true;
    allowedTCPPortRanges = [
      { from = 30000; to = 60000; }
    ];
    allowedUDPPortRanges = [
      { from = 30000; to = 60000; }
    ];
  };
  

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  system.copySystemConfiguration = true;

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
  system.stateVersion = "24.05"; # Did you read the comment?

}
