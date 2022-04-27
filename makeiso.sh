#!/usr/bin/env bash

# export GC_DONT_GC=1

CHANNEL=~/.nix-defexpr/channels/nixos
OVERLAY=$(mktemp -d)
NIXPKGS=$OVERLAY/nixpkgs
HERE=$(pwd)
KEYRINGS_PATH=$HERE/pacman/keyrings

mkdir -p $KEYRINGS_PATH
sudo mount --bind /usr/share/pacman/keyrings $KEYRINGS_PATH
# ln -sf /usr/share/pacman/keyrings $KEYRINGS_PATH

mkdir -p $OVERLAY/{upper,work,nixpkgs}
sudo mount -t overlay overlay -o lowerdir=$CHANNEL,upperdir=$OVERLAY/upper,workdir=$OVERLAY/work $NIXPKGS
sudo chown -R $USER $NIXPKGS
chmod -R +w $NIXPKGS
# ls -l $NIXPKGS

# https://github.com/NixOS/nixpkgs/pull/126481
TIMESHIFT_PATH=$NIXPKGS/pkgs/applications/backup/timeshift
mkdir -p $TIMESHIFT_PATH
patch --directory="$NIXPKGS" -p1 < patches/timeshift.patch
sed -i 's|sha256-fdCcajRKAaLGGKAhCvxsdfjtogXjJp2u0PV2P3R6yao=|sha256-x7KbKA7/ZzazhmnIx4r2Ml5wGj916DpVopGJpgdvpfw=|' \
    $TIMESHIFT_PATH/unwrapped.nix

# https://github.com/NixOS/nixpkgs/pull/161115
# patch --directory="$NIXPKGS" -p1 < patches/pacman.patch
# cp pacman/default.nix $NIXPKGS/pkgs/tools/package-management/pacman/default.nix

nix-build $NIXPKGS/nixos -A config.system.build.isoImage -I nixos-config=iso.nix $@

sudo umount -l $KEYRINGS_PATH
# rm $KEYRINGS_PATH
sudo umount -l $NIXPKGS
rm -rf $OVERLAY