{config, pkgs, callPackage, ...}:

pkgs.arch-install-scripts.overrideAttrs (oldAttrs: rec {
  postPatch = ''
    substituteInPlace ./arch-chroot.in \
      --replace "--fork --pid chroot" "--fork --pid env PATH=$PATH:/usr/bin chroot"
    substituteInPlace ./pacstrap.in --replace \
      "--fork --pid pacman" "--fork --pid env PATH=$PATH:/usr/bin ${callPackage ./static.nix {}}/bin/pacman-static"
  '';
})