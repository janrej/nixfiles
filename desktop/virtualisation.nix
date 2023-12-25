{ config, pkgs, ... }:

{ 

#  User additions
users.users.jannik.extraGroups = [ "libvirtd" "qemu-libvirtd" ];

# Libvirt, QEMU, OVMF, Virt-manager
programs = {
    virt-manager.enable = true;
};
virtualisation = {
    appvm.enable = true; 
    appvm.user = "jannik";
    libvirtd = {
      enable = true;
      onBoot = "ignore";
      onShutdown = "shutdown";
      qemu = {
        package = pkgs.qemu_full;
        ovmf.package = [
          (pkgs.OVMFFull.override {
            secureBoot = true;
            csmSupport = false;
            httpSupport = true;
            tpmSupport = true;
          }).fd
        ];
        swtpm.enable = true;
        runAsRoot = false;
      };
      hooks = {
        daemon = {};
        qemu = {};
        libxl = {};
        lxc = {};
        network = {};
      };
    };
};

}