# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ config, pkgs, ... }:

let 

  # archlinux-keyring = fetchTarball {
  #   url = "https://geo.mirror.pkgbuild.com/core/os/x86_64/archlinux-keyring-20220424-1-any.pkg.tar.zst";
  #   sha256 = "592f17fcf9e2cc92b3d963c52c52f3a04f2df88103992cf6503512248b298a8f";
  # };
  # error: tarball 'https://geo.mirror.pkgbuild.com/core/os/x86_64/archlinux-keyring-20220424-1-any.pkg.tar.zst' contains an unexpected number of top-level files
  TARGET_KEYRINGS = ./pacman/keyrings;
  ISO_KEYRINGS_PATH = "pacman.d/keyrings";

in

{

  imports = [
    <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-graphical-gnome.nix>

    # Provide an initial copy of the NixOS channel so that the user
    # doesn't need to run "nix-channel --update" first.
    <nixpkgs/nixos/modules/installer/cd-dvd/channel.nix>
  ];



  # boot.kernelPackages = pkgs.linuxPackages_latest;

  fonts.fonts = with pkgs; [
    
    noto-fonts-cjk

  ];

  #i18n.defaultLocale = "zh_CN.UTF-8";
  i18n.inputMethod = {
    enabled = "ibus";
    ibus.engines = with pkgs.ibus-engines; [ libpinyin ];
  };

  # nixpkgs.config = {

  #   # allowUnfree = true;

  #   packageOverrides = pkgs: {

  #     pacman = pkgs.pacman.overrideAttrs (old: {
  #         configureFlags = old.configureFlags ++ [ "--datarootdir=${placeholder "out"}/etc" ];
  #         installFlags = old.installFlags ++ [
  #           "localstatedir=${placeholder "out"}/var"
  #           # "datarootdir=${placeholder "out"}/etc"
  #         ];
  #     });

  #   };
  # };
  
  # security.doas.enable = true;

  services = {
    gnome = {
      core-utilities.enable = false;
      tracker-miners.enable = false;
      tracker.enable = false;
    };
    # xserver.excludePackages = [ pkgs.xterm ];
  };

  users.defaultUserShell = pkgs.xonsh;

  environment = {

    shells = [ pkgs.xonsh ];

    systemPackages = with pkgs; [

      arch-install-scripts
      gnome.file-roller
      gnome.gnome-system-monitor
      gnome.gnome-terminal
      gnome.nautilus
      gnupg
      inxi
      pacman
      timeshift

    ];

    etc = {
      "pacman.conf" = {
        source = ./pacman/pacman.conf;
        mode = "0644";
      };
      "pacman.d/mirrorlist" = {
        source = ./pacman/mirrorlist;
        mode = "0644";
      };
      "${ISO_KEYRINGS_PATH}/archlinux-revoked" = {
        source = "${TARGET_KEYRINGS}/archlinux-revoked";
        mode = "0444";
      };
      "${ISO_KEYRINGS_PATH}/archlinux-trusted" = {
        source = "${TARGET_KEYRINGS}/archlinux-trusted";
        mode = "0444";
      };
      "${ISO_KEYRINGS_PATH}/archlinux.gpg" = {
        source = "${TARGET_KEYRINGS}/archlinux.gpg";
        mode = "0444";
      };
    };

  };

  isoImage.squashfsCompression = "zstd -Xcompression-level 6";

}

