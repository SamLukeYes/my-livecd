{ lib
, stdenv
, callPackage
, fetchurl
, asciidoc
, bzip2
, coreutils
, curl
, gpgme
, installShellFiles
, libarchive
, meson
, ninja
, openssl
, perl
, pkg-config
, python3
, runtimeShell
, xz
, zlib
}:

let
  archlinux-keyring = callPackage ./keyring.nix {};
in
stdenv.mkDerivation rec {
  pname = "pacman";
  version = "6.0.1";

  src = fetchurl {
    url = "${import ../reverse-proxy.nix}https://sources.archlinux.org/other/${pname}/${pname}-${version}.tar.xz";
    hash = "sha256-DbYUVuVqpJ4mDokcCwJb4hAxnmKxVSHynT6TsA079zE=";
  };

  nativeBuildInputs = [
    asciidoc
    # coreutils
    installShellFiles
    meson
    ninja
    pkg-config
    python3
  ];

  buildInputs = [
    archlinux-keyring
    bzip2
    curl
    gpgme
    libarchive
    openssl
    perl
    xz
    zlib
  ];

  postPatch = ''
    substituteInPlace meson.build \
      --replace "install_dir : SYSCONFDIR" "install_dir : '${placeholder "out"}/etc'" \
      --replace "join_paths(LOCALSTATEDIR, 'lib/pacman/')," "'${placeholder "out"}/var/lib/pacman/'," \
      --replace "join_paths(LOCALSTATEDIR, 'cache/pacman/pkg/')," "'${placeholder "out"}/var/cache/pacman/pkg/',"
    substituteInPlace doc/meson.build \
      --replace "/bin/true" "${coreutils}/bin/true"
    substituteInPlace scripts/repo-add.sh.in \
      --replace bsdtar "${libarchive}/bin/bsdtar"
    substituteInPlace scripts/pacman-key.sh.in \
      --replace @pkgdatadir@/keyrings ${archlinux-keyring}/share/pacman/keyrings \
      --replace "--batch --check-trustdb" "--batch --check-trustdb --allow-weak-key-signatures"
  '';

  hardeningDisable = ["all"];

  mesonFlags = [
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    "-Dmakepkg-template-dir=${placeholder "out"}/share/makepkg-template"
    "-Dscriptlet-shell=${runtimeShell}"
  ];

  postInstall = ''
    installShellCompletion --bash scripts/pacman --zsh scripts/_pacman
  '';

  meta = with lib; {
    description = "A simple library-based package manager";
    homepage = "https://archlinux.org/pacman/";
    changelog = "https://gitlab.archlinux.org/pacman/pacman/-/raw/v${version}/NEWS";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mt-caret ];
  };
}