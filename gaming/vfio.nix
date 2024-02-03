{ lib, config, pkgs, ... }:

{ 

# Kernel and boot
boot.kernelParams = [ "amd_iommu=on" "iommu=pt" "kvm.ignore_msrs=1" "video=efifb:off" "vfio-pci.ids=1002:731f,1002:ab38,1022:1539,1022:15e3" ];
boot.kernelModules = [ "kvm_amd" "vfio_pci" "vfio" "vfio_iommu_type1" ];
boot.initrd.kernelModules = [ "vfio_pci" "vfio" "vfio_iommu_type1" ];
boot.extraModprobeConfig = ''
    softdep amdgpu pre: vfio-pci
    softdep snd_hda_intel pre: vfio-pci
'';

# GPU heads naming correction
services.xserver = {
    displayManager = {
        setupCommands = lib.mkForce ''
          ${pkgs.xorg.xrandr}/bin/xrandr \
            --output DisplayPort-0 --mode 2560x1080 --rate 75 \
            --output HDMI-A-0 --primary --mode 1920x1080 --rate 60 --left-of DisplayPort-0 \
            --output HDMI-A-1 --off \
            --output HDMI-A-2 --off
        '';
    };
};

}