#!/bin/sh

export PATH=/run/current-system/sw/bin:$PATH

mkdir -p /var/lib/pacman
pacman-key --init
pacman-key --populate archlinux