{ lib
, stdenv
, fetchzip
, gettext
, pkg-config
, which
, vala
, gtk3
, json-glib
, libgee
, vte
, xapps
, bash
}:

stdenv.mkDerivation rec {
  pname = "timeshift";
  version = "21.09.1";

  src = fetchzip {
    url = "${import ../reverse-proxy.nix}https://github.com/teejee2008/timeshift/archive/v${version}.tar.gz";
    sha256 = "sha256-x7KbKA7/ZzazhmnIx4r2Ml5wGj916DpVopGJpgdvpfw=";
  };

  patches = [
    ./timeshift-launcher.patch
  ];

  postPatch = ''
    find ./src -mindepth 1 -name "*.vala" -type f -exec sed -i 's/"\/sbin\/blkid"/"blkid"/g' {} \;
    substituteInPlace ./src/makefile \
        --replace "SHELL=/bin/bash" "SHELL=${bash}" \
        --replace "prefix=/usr" "prefix=$out" \
        --replace "sysconfdir=/etc" "sysconfdir=$out/etc"
    substituteInPlace ./src/Utility/IconManager.vala \
        --replace "/usr/share" "$out/share"
    substituteInPlace ./src/Core/Main.vala \
        --replace "/etc/timeshift/default.json" "$out/etc/timeshift/default.json" \
        --replace "file_copy(app_conf_path_default, app_conf_path);" "if (!dir_exists(\"/etc/timeshift\")){dir_create(\"/etc/timeshift\");};file_copy(app_conf_path_default, app_conf_path);"
  '';

  nativeBuildInputs = [
    gettext
    vala
    pkg-config
    which
  ];

  buildInputs = [
    gtk3
    json-glib
    libgee
    vte
    xapps
  ];

  doCheck = true;

  meta = with lib; {
    description = "A system restore tool for Linux";
    longDescription = ''
      TimeShift creates filesystem snapshots using rsync+hardlinks or BTRFS snapshots.
      Snapshots can be restored using TimeShift installed on the system or from Live CD or USB.
      The main purpose of this package is to
      restore the TimeShift images of distros other than NixOS.
      NixOS comes with sophisticated ways to rollback and switch generations,
      and its own way to manage bootloaders and system cron jobs.
      To use this package to restore broken distros,
      this package can be installed on a working NixOS on USB stick or another partition,
      or on the target system or other distros through Nix package manager.
    '';
    homepage = "https://github.com/teejee2008/timeshift";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ShamrockLee ];
  };
}
