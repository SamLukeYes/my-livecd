{config, pkgs, ...}:

let 

  # archlinux-keyring = fetchTarball {
  #   url = "https://geo.mirror.pkgbuild.com/core/os/x86_64/archlinux-keyring-20220424-1-any.pkg.tar.zst";
  #   sha256 = "592f17fcf9e2cc92b3d963c52c52f3a04f2df88103992cf6503512248b298a8f";
  # };
  # error: tarball 'https://geo.mirror.pkgbuild.com/core/os/x86_64/archlinux-keyring-20220424-1-any.pkg.tar.zst' contains an unexpected number of top-level files
  
  ISO_KEYRINGS_PATH = "pacman.d/keyrings";

in

{
  imports = [../override.nix];

  environment = {
    etc = {
      "pacman.conf" = {
        source = ./pacman.conf;
        mode = "0644";
      };
      "pacman.d/mirrorlist" = {
        text = "Server = ${import ../mirror.nix}/archlinux/$repo/os/$arch\n";
        mode = "0644";
      };
      "pacman.d/init.sh" = {
        source = ./init.sh;
        mode = "0755";
      };
      "${ISO_KEYRINGS_PATH}/archlinux-revoked" = {
        source = ./keyrings/archlinux-revoked;
        mode = "0444";
      };
      "${ISO_KEYRINGS_PATH}/archlinux-trusted" = {
        source = ./keyrings/archlinux-trusted;
        mode = "0444";
      };
      "${ISO_KEYRINGS_PATH}/archlinux.gpg" = {
        source = ./keyrings/archlinux.gpg;
        mode = "0444";
      };
    };

    systemPackages = with pkgs;
      [
        # arch-install-scripts
        gnupg
        # local.gnupg
        local.arch-install-scripts
        local.pacman
      ];
  };

  systemd.services.pacman-init = {
      wantedBy = [ "multi-user.target" ];
      description = "Initializing Pacman";
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = "/etc/pacman.d/init.sh";
      };
  };
}