with (import <nixos> {});
{
  # gnupg 2.2 is ported from NixOS 21.11, required by archlinux-keyring
  # gnupg = callPackage ./gnupg/22.nix {};

  # pacman is based on https://github.com/NixOS/nixpkgs/pull/161115
  pacman = callPackage ./pacman {};
  pacman-static = callPackage ./pacman/static.nix {};
  pacstrap-static = callPackage ./pacman/pacstrap-static.nix {};

  # timeshift is based on https://github.com/NixOS/nixpkgs/pull/126481
  # timeshift = callPackage ./timeshift { grubPackage = grub2_full; };
  timeshift = callPackage ./timeshift/unwrapped.nix { inherit (cinnamon) xapps; };
}