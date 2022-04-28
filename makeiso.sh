#!/usr/bin/env bash

###############################################################################
# Edit the following lines according to your environment
# export GC_DONT_GC=1
CHANNEL=~/.nix-defexpr/channels/nixos-21.11
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