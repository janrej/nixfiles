{ lib, config, pkgs, modulesPath, ... }:

{
imports = [ 
    (modulesPath + "/installer/scan/not-detected.nix")
];

# Local root filesytems
fileSystems = {
    "/boot" = {
        device = "/dev/disk/by-uuid/723A-D6B2";
        fsType = "vfat";
    };

    "/" = { 
        device = "/dev/disk/by-uuid/f79b4afe-c97b-44dd-9969-9846d6290a8b";
        fsType = "ext4";
    };
# Additional local filesystems
    "/home" = {
        device = "/dev/disk/by-uuid/5d0e549e-dd17-47c8-9cf8-4b052e7c71b2";
        fsType = "ext4";
    };

    # "/steamlib" = {
    #     device = "/dev/disk/by-uuid/4ae29c47-7572-43c5-a203-22ca26461190";
    #     fsType = "ext4";
    # };
};

swapDevices = [
    {
    device = "/dev/disk/by-uuid/dadb65fa-ee40-4001-8338-7feb6c19a91b";
    }
];

}