{ lib, runCommand, bash }:
let
  pname = "pacstrap-static";
in
runCommand pname {
  src = ./pacstrap-static.sh;
  meta = with lib; {
    homepage = "https://archlinux.org/pacman/";
    license = licenses.gpl2;
  };
  buildInputs = [bash];
} "install -Dm755 $src $out/bin/${pname}"