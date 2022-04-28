{ lib, runCommand, fetchurl }:
let
  pname = "pacman-static";
in
runCommand pname {
  src = fetchurl {
    url = "${import ../reverse-proxy.nix}https://pkgbuild.com/~morganamilo/pacman-static/x86_64/bin/pacman-static";
    sha256 = "562b76c7223016e49ce0c7fe409ef0313f0409bd2f1ad9421195d6afa451e1f6";
  };
  meta = with lib; {
    description = "A simple library-based package manager (static binary)";
    homepage = "https://archlinux.org/pacman/";
    license = licenses.gpl2Plus;
  };
} "mkdir -p $out/bin && install -Dm755 $src $out/bin/${pname}"
