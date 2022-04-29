# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ config, pkgs, ... }:

{

  imports = [

    ./override.nix

    <nixos/nixos/modules/installer/cd-dvd/installation-cd-graphical-gnome.nix>

    # Provide an initial copy of the NixOS channel so that the user
    # doesn't need to run "nix-channel --update" first.
    <nixos/nixos/modules/installer/cd-dvd/channel.nix>

    # Get ready to install Arch Linux
    ./pacman/init.nix
  ];

  nix.binaryCaches = [ "${import ./mirror.nix}/nix-channels/store" ];

  # boot.kernelPackages = pkgs.linuxPackages_latest;

  fonts.fonts = with pkgs; [
    
    noto-fonts-cjk

  ];

  #i18n.defaultLocale = "zh_CN.UTF-8";
  i18n.inputMethod = {
    enabled = "ibus";
    ibus.engines = with pkgs.ibus-engines; [
      libpinyin table table-chinese
    ];
  };
  
  # security.doas.enable = true;

  services = {
    gnome = {
      core-utilities.enable = false;
      tracker-miners.enable = false;
      tracker.enable = false;
    };
    gvfs.enable = true;
    # xserver.excludePackages = [ pkgs.xterm ];
  };

  users.defaultUserShell = pkgs.fish;

  environment = {

    shells = [ pkgs.fish ];

    systemPackages = with pkgs; [

      baobab
      busybox   # lazy workaround for directly using timeshift-unwrapped
      cinnamon.nemo
      gnome.file-roller
      gnome.gnome-system-monitor
      gnome.gnome-terminal
      inxi
      local.timeshift

    ];

  };

  isoImage.squashfsCompression = "zstd -Xcompression-level 6";

}

