{ lib, config, pkgs, ... }:

# Thrustmaster T300RS GT drivers
let
    hid-tmff2 = config.boot.kernelPackages.callPackage ./hid-tmff2.nix {};
in
{
    boot.blacklistedKernelModules = [ "hid-thrustmaster" ];
    boot.extraModulePackages = [ hid-tmff2 ];
    # boot.kernelModules = [ "hid-tmff2" ];
    # Use boot.kernelModules = [ hid-tmff2 ]; to enable the module. Then, the user can load it using:
    # $ sudo modprobe hid-tmff2
    # OR use "" to autoload the module at startup

imports = [ 
    # Include hardware scan.
    ./hardware-configuration.nix
];

# Bootloader
boot.loader.systemd-boot.enable = true;
boot.loader.efi.canTouchEfiVariables = true;

# Kernel
boot.kernelPackages = pkgs.linuxPackages_6_6;
boot.kernelModules = [ "amdgpu" "nct6775" "hid-tmff2" ];
boot.initrd.availableKernelModules = [ "xhci_pci" "usb_storage" ];

# Platform specific
nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

# CPU configuration
powerManagement.cpuFreqGovernor = lib.mkDefault "ondemand";
hardware.cpu.amd.updateMicrocode = true;

# Graphics and sound
sound.enable = true;
hardware = {
    pulseaudio.enable = true;
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
        interface = "enp11s0";
    };
    nameservers = [ "208.67.222.222" "208.67.220.220" ];
    wireless.enable = false;
    interfaces = {
        enp11s0 = {
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

        # Desktop and gui
        i3wsr
        i3status

        # System utilities
        polkit_gnome
        pciutils
        psutils
        dconf
        lm_sensors
        nerdfonts
        pavucontrol
        xorg.xrandr

        # Editors
        git
        vscodium

        # Browsers
        firefox

        # Gaming
        # steam
        # steamPackages.steam
        # steamPackages.steam-runtime
        # steamPackages.steamcmd
        # steam-tui
        protonup-ng
        protontricks
        oversteer
        linuxKernel.packages.linux_6_6.xone
        linuxKernel.packages.linux_6_6.hid-tmff2

        # Streaming
        spotify-tui
        youtube-tui
        mpv
        cli-visualizer

        # Image manipulation
        gimp-with-plugins

        # Music production
        ardour

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
          --output DisplayPort-0 --mode 1920x1080 --rate 60 --left-of HDMI-A-0 \
          --output HDMI-A-0 --primary --mode 2560x1080 --rate 75
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
        i3 = {
            enable = true;
        };
    };
};

system.stateVersion = "23.11";

}