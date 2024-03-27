{ lib, config, pkgs, ... }:

{

imports = [ 
    # Include hardware scan.
    ./hardware-configuration.nix
];

# Bootloader
boot.loader.systemd-boot.enable = true;
boot.loader.efi.canTouchEfiVariables = true;

# Kernel
boot.kernelPackages = pkgs.linuxPackages_latest;
boot.kernelModules = [ "amdgpu" "nct6775" ];
boot.initrd.availableKernelModules = [ "xhci_pci" "usb_storage" ];

# Platform specific
nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

# CPU configuration
powerManagement.cpuFreqGovernor = lib.mkDefault "ondemand";
hardware.cpu.amd.updateMicrocode = true;

# Graphics and sound
sound.enable = true;
services = {
		pipewire = {
				enable = true;
				audio = {
						enable = true;
				};
				alsa = {
						enable = true;
				};
				jack = {
						enable = true;
				};
				pulse = {
						enable = true;
				};
		};
};
hardware = {
    opengl = {
        driSupport = true;
        driSupport32Bit = true;
        extraPackages = [
            pkgs.rocmPackages.clr.icd
            pkgs.amdvlk
        ];
        extraPackages32 = [
            pkgs.driversi686Linux.amdvlk
        ];
    }; 
};
environment.variables.VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json";

# Networking
networking = {
    hostName = "NixOS";
    firewall = {
        allowPing = false;
    };
    enableIPv6 = false;
    useDHCP = false;
    defaultGateway = {
        address = "192.168.1.1";
        interface = "enp8s0";
    };
    nameservers = [ "208.67.222.222" "208.67.220.220" ];
    wireless.enable = false;
    interfaces = {
        enp8s0 = {
            useDHCP = true;
        };
    };
};

# User specification
time.timeZone = "Europe/Copenhagen";
i18n.defaultLocale = "da_DK.UTF-8";
console.keyMap = "dk-latin1";
users.users = {
    jannik = {
        isNormalUser = true;
        createHome = true;
        homeMode = "777";
        home = "/home/jannik";
        description = "jannik";
        extraGroups = [ "wheel" "video" "audio" "disk" ];
    };
};

# Polkit authentication
security.polkit.enable = true;
systemd = {
  user.services.polkit-gnome-authentication-agent-1 = {
    description = "polkit-gnome-authentication-agent-1";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };
};

# Applications and /etc modifications
nixpkgs.config.allowUnfree = true;
programs.steam.enable = true;
hardware.xone.enable = true;
environment = {
    systemPackages = with pkgs; [ 
        
        # Terminal
        kitty
        starship
        mc
        htop
        fastfetch

        # System utilities
        polkit_gnome
        pciutils
        psutils
        dconf
        lm_sensors
        nerdfonts
        pwvucontrol
				helvum
        xorg.xrandr

        # Development
        git
        vscodium

        # Browsers
        firefox

        # Gaming
        protonup-ng

        # Streaming
				spotify
        spotify-tui
        youtube-tui
        mpv

        # Image manipulation
        gimp-with-plugins

        # Music production
        ardour
				reaper
				hydrogen
				carla
				drumgizmo

        # Video editing
        libsForQt5.kdenlive

    ];

    etc = {
    
        # Sensors detected
        "sysconfig/lm_sensors".text = ''
            HWMON_MODULES="nct6775"
        '';
    };
};

# Xserver frontend
services.xserver = {
    enable = true;
    autorun = true;
    videoDrivers = [ "amdgpu" ];
    deviceSection = ''
    Option "Tearfree" "true"
    Option "VariableRefresh" "true"
    '';
    xkb.layout = "dk";
    displayManager = {
        autoLogin = {
            enable = true;
            user = "jannik";
        };
        defaultSession = "none+qtile";
        setupCommands = lib.mkDefault ''
        ${pkgs.xorg.xrandr}/bin/xrandr \
          --output DP-2 --primary --mode 1920x1080 --rate 60 --left-of HDMI-1 \
          --output HDMI-1 --mode 2560x1080 --rate 75
        '';
        sddm = {
            enable = true;
            autoNumlock = true;
        };    
    };
    windowManager = {
        qtile = {
            enable = true;
        };
    };
		desktopManager = {
				 plasma5 = {
						 enable = true;
				};
		};
};

system.stateVersion = "23.11";

}