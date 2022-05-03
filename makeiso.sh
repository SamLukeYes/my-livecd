#!/usr/bin/env bash

###############################################################################
# Edit the following lines according to your environment

# If you encounter segfault when starting this build script,
# uncomment the following line for a quick workaround.
# export GC_DONT_GC=1

# Change the following value to the path to the NixOS channel
# that you want to build the live image from.
CHANNEL=~/.nix-defexpr/channels/nixos-unstable

###############################################################################

NIX_PATH=nixos=$CHANNEL:$NIX_PATH

nix-build '<nixos/nixos>' -A config.system.build.isoImage -I nixos-config=iso.nix $@