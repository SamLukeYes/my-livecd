{config, pkgs, callPackage, ...}:

pkgs.arch-install-scripts.overrideAttrs (oldAttrs: rec {
  postFixup = ''
    substituteInPlace $out/bin/arch-chroot \
      --replace "--fork --pid chroot" "--fork --pid env PATH=$PATH:/usr/bin chroot"
    substituteInPlace $out/bin/pacstrap --replace \
      "--fork --pid pacman" "--fork --pid env PATH=$PATH:/usr/bin ${callPackage ./default.nix {}}/bin/pacman"
  '';
})