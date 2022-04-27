#!/usr/bin/env bash

# export GC_DONT_GC=1

CHANNEL=~/.nix-defexpr/channels/nixos-21.11
NIX_PATH=nixos=$CHANNEL
# OVERLAY=$(mktemp -d)
# NIXPKGS=$OVERLAY/nixpkgs
HERE=$(pwd)
PACMAN_KEYRING_PATH=/usr/share/pacman/keyrings
KEYRING_INSTALL_PATH=$HERE/pacman/keyrings

mkdir -p $KEYRING_INSTALL_PATH

# https://github.com/NixOS/nixpkgs/pull/126481
# TIMESHIFT_PATH=$NIXPKGS/pkgs/applications/backup/timeshift
# mkdir -p $TIMESHIFT_PATH
# patch --directory="$NIXPKGS" -p1 < patches/timeshift.patch
# sed -i 's|sha256-fdCcajRKAaLGGKAhCvxsdfjtogXjJp2u0PV2P3R6yao=|sha256-x7KbKA7/ZzazhmnIx4r2Ml5wGj916DpVopGJpgdvpfw=|' \
#     $TIMESHIFT_PATH/unwrapped.nix

# https://github.com/NixOS/nixpkgs/pull/161115
# patch --directory="$NIXPKGS" -p1 < patches/pacman.patch
# cp pacman/default.nix $NIXPKGS/pkgs/tools/package-management/pacman/default.nix

bwrap --dev-bind / / --ro-bind $PACMAN_KEYRING_PATH $KEYRING_INSTALL_PATH \
    nix-build '<nixos/nixos>' -A config.system.build.isoImage -I nixos-config=iso.nix $@