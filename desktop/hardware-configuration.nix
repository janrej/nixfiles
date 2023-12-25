{ lib, config, pkgs, modulesPath, ... }:

{
imports = [ 
    (modulesPath + "/installer/scan/not-detected.nix")
];

# Platform specific
nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

# Boot-time configuration
boot.initrd.availableKernelModules = [ "xhci_pci" "usb_storage" ];
boot.initrd.kernelModules = [  ];
boot.kernelModules = [  ];
boot.extraModulePackages = [  ];

# Local root filesytems
fileSystems = {
    "/boot" = {
        device = "/dev/disk/by-uuid/723A-D6B2";
        fsType = "vfat";
    };

    "/" = { 
        device = "/dev/disk/by-uuid/39012f5a-16d7-47b8-959c-f36de0f1fc2f";
        fsType = "ext4";
    };
# Additional local filesystems
    "/home" = {
        device = "/dev/disk/by-uuid/5d0e549e-dd17-47c8-9cf8-4b052e7c71b2";
        fsType = "ext4";
    };
};

swapDevices = [
    {
    device = "/dev/disk/by-uuid/dadb65fa-ee40-4001-8338-7feb6c19a91b";
    }
];

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

}