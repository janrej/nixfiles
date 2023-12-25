{ config, pkgs, ... }:

{ 

environment.systemPackages = with pkgs; [
    
    # Music production
    ardour

    # Video editing
    libsForQt5.kdenlive

];

}