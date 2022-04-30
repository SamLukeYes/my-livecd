#!/usr/bin/env bash

###############################################################################
# Edit the following lines according to your environment

# If you encounter segfault when starting this build script,
# uncomment the following line for a quick workaround.
# export GC_DONT_GC=1

# Change the following value to the path to the NixOS channel
# that you want to build the live image from.
CHANNEL=~/.nix-defexpr/channels/nixos-21.11

# If you're using Arch Linux, or probably other Arch-based distros,
# the following value should work out of the box.
# Otherwise, you'll have to set it to the path to a directory
# that contains archlinux{.gpg,-revoked,-trusted}
# You can download the archlinux-keyring package, which contains these files,
# from https://geo.mirror.pkgbuild.com/core/os/x86_64/
PACMAN_KEYRING_PATH=/usr/share/pacman/keyrings

###############################################################################

NIX_PATH=nixos=$CHANNEL
# OVERLAY=$(mktemp -d)
# NIXPKGS=$OVERLAY/nixpkgs
HERE=$(pwd)
KEYRING_INSTALL_PATH=$HERE/pacman/keyrings

mkdir -p $KEYRING_INSTALL_PATH

bwrap --dev-bind / / --ro-bind $PACMAN_KEYRING_PATH $KEYRING_INSTALL_PATH \
    nix-build '<nixos/nixos>' -A config.system.build.isoImage -I nixos-config=iso.nix $@