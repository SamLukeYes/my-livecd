{config, pkgs, ...}:

{
  nixpkgs.config = {

    # allowUnfree = true;

    packageOverrides = pkgs: {
      local = import ./default.nix;
    };
    
  };
}