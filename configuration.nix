{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Boot params
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelParams = [ "nvidia-drm.modeset=1" ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Locales and other bs
  time.timeZone = "Asia/Kolkata";

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IN";
    LC_IDENTIFICATION = "en_IN";
    LC_MEASUREMENT = "en_IN";
    LC_MONETARY = "en_IN";
    LC_NAME = "en_IN";
    LC_NUMERIC = "en_IN";
    LC_PAPER = "en_IN";
    LC_TELEPHONE = "en_IN";
    LC_TIME = "en_IN";
  };

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

	# Env variables
	environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    XDG_SESSION_TYPE = "wayland";
    AQ_DRM_DEVICES = "/dev/dri/intel-igpu:/dev/dri/nvidia-dgpu";
		FREETYPE_PROPERTIES = "cff:no-stem-darkening=0 autofitter:no-stem-darkening=0";
  };

	# Graphics card bs
  services.udev.extraRules = ''
    KERNEL=="card*", KERNELS=="0000:00:02.0", SUBSYSTEM=="drm", SUBSYSTEMS=="pci", SYMLINK+="dri/intel-igpu"
    KERNEL=="card*", KERNELS=="0000:01:00.0", SUBSYSTEM=="drm", SUBSYSTEMS=="pci", SYMLINK+="dri/nvidia-dgpu"
  '';

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;

    powerManagement.enable = true;
    powerManagement.finegrained = true;

    open = true;

    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };

      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

	# Userslop
  users.users."proteus" = {
    isNormalUser = true;
    description = "proteus";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
		shell = pkgs.zsh;
    packages = with pkgs; [];
  };

  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
		# Compilers and languages and such
    gcc
		go
		python3
		nodejs
		pnpm

		# Dev tools
    git
		docker-compose
    docker-buildx
    tree-sitter
		neovim
		tmux
		man
		man-pages
		man-pages-posix

		# CLI tools
		wget
		unzip
		fzf
		zoxide
		eza
		ripgrep
		btop
		glib
		wireguard-tools
    jq
    playerctl
		direnv

		# WM / Desktop related
		hyprpaper
		hyprlock
		hyprshot
		quickshell
    wl-clipboard
    cliphist
    libnotify
    nwg-look
    libsForQt5.qt5ct
    kdePackages.qt6ct
    libsForQt5.qtstyleplugin-kvantum
    kdePackages.qtstyleplugin-kvantum
    dconf

		#Apps
    zsh
    kitty
    firefox
    vesktop
    yazi
    nautilus
    file-roller
    qbittorrent
    mpv
		ghidra
		onlyoffice-desktopeditors
		stremio-linux-shell
  ];

	# Hyprland initialization
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];
    config = {
      common = {
        default = [ "hyprland" "gtk" ];
      };
      hyprland = {
        default = [ "hyprland" "gtk" ];
        "org.freedesktop.impl.portal.Settings" = [ "gtk" ];
      };
    };
  };

	# Program Enabling
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  programs.dconf.enable = true;

	programs.zsh.enable = true;

	# For some poop
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
  ];

	# Fontslop
  fonts = {
    packages = with pkgs; [
      inter
      rubik
      nerd-fonts.roboto-mono
      nerd-fonts.symbols-only
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      liberation_ttf
    ];
   
    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [ "RobotoMono Nerd Font" "Noto Color Emoji" ];
        sansSerif = [ "Inter" "Noto Color Emoji" ];
        serif     = [ "Liberation Serif" ];
        emoji     = [ "Noto Color Emoji" ];
      };
			hinting = {
				enable = true;
				style = "slight";
			};
			antialias = true;
    };
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Services 
  services.openssh.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
    };
  };

	hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  boot.extraModprobeConfig = ''
    options bluetooth disable_ertm=Y
  '';
  services.blueman.enable = true;

	services.printing.enable = true;

	security.rtkit.enable = true;

	#Networking
  networking.extraHosts = ''
    172.16.91.124  hpc01.sharanga.local hpc01
    172.16.91.125  hpc02.sharanga.local hpc02
  '';

  networking.hostName = "nix";

	networking.networkmanager.enable = true;

  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

	# Virtualisation
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;

    rootless = {
      enable = false;
    };

    daemon.settings = {
      features = {
        buildkit = true;
      };
    };

    autoPrune = {
      enable = true;
      dates = "weekly";
    };
  };

	# Filesystem related things
  fileSystems."/mnt/ssdihh" = {
  device = "/dev/disk/by-uuid/7548a1ed-3d14-4e48-b512-baa41300e8ec";
  fsType = "ext4";
  options = [ "defaults" "nofail" ];
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  system.stateVersion = "26.05";
}
