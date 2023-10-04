{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let devCfg = config.modules.dev;
    cfg = devCfg.haskell;
in {
  options.modules.dev.haskell = {
    enable = mkBoolOpt false;
    xdg.enable = mkBoolOpt devCfg.xdg.enable;
  };

  config = mkMerge [
    (mkIf cfg.enable {
      user.packages = with pkgs ; [
        ghc
        cabal2nix
        cabal-install
        haskellPackages.haskell-language-server
      ];
      environment.shellAliases = {
      };
    })

    (mkIf cfg.xdg.enable {
    })
  ];
}
