{ lib, config, pkgs, ... }:

{ 

imports = [ 
    # Include hardware scan.
    ./hardware-configuration.nix
    # Include VFIO configuration
    # ./vfio.nix
    # Include virtualisation configuration
    # ./virtualisation.nix
    # Include studio configuration
    # ./studio.nix
];

# Bootloader
boot.loader.systemd-boot.enable = true;
boot.loader.efi.canTouchEfiVariables = true;

# Kernel
boot.kernelPackages = pkgs.linuxPackages_6_6;
boot.kernelModules = [ "amdgpu" "nct6775" ];

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
environment = {
    systemPackages = with pkgs; [ 
        
        # Terminal
        kitty

        # Desktop and gui
        i3wsr
        i3status

        # System utilities
        polkit_gnome
        pciutils
        psutils
        dconf
        lm_sensors
        neofetch
        pavucontrol
        xorg.xrandr

        # Editors
        vscodium

        # Browsers
        ungoogled-chromium

        # Streaming
        spotify-tui
        youtube-tui
        mpv
        cli-visualizer

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
          --output DisplayPort-0 --off \
          --output DisplayPort-1 --off \
          --output DisplayPort-2 --off \
          --output HDMI-A-0 --mode 2560x1080 --rate 75 \
          --output DisplayPort-1-3 --off \
          --output HDMI-A-1-1 --primary --mode 1920x1080 --rate 60 --left-of HDMI-A-0 \
          --output HDMI-A-1-2 --off \
          --output HDMI-A-1-3 --off
        '';
        sddm = {
            enable = true;
            autoNumlock = true;
        };    
    };
    windowManager = {
        # awesome = {
        #     enable = true;
        # };
        qtile = {
            enable = true;
        };
        # i3 = {
        #     enable = true;
        # };
    };
};

system.stateVersion = "23.11";

}