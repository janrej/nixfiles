{ config, pkgs, ... }:

{ 

environment.systemPackages = with pkgs; [
    
    # Image manipulation
    gimp-with-plugins

    # Music production
    ardour

    # Video editing
    libsForQt5.kdenlive

];

}