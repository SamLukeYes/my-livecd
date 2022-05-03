{config, pkgs, ...}:

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