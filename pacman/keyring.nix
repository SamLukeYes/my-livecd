{ fetchzip, zstd }:
fetchzip {
  nativeBuildInputs = [ zstd ];
  url = "${import ../mirror.nix}/archlinux/core/os/x86_64/archlinux-keyring-20220424-1-any.pkg.tar.zst";
  sha256 = "sha256-4ime43aq8AU2i6SdI0+UB+Gc+yvG9aFdm2T7sscLsFA=";
}