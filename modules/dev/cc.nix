{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let devCfg = config.modules.dev;
    cfg = devCfg.cc;
in {
  options.modules.dev.cc = {
    enable = mkBoolOpt false;
  };

  config = mkMerge [
    (mkIf cfg.enable {
      user.packages = with pkgs; [
        clang
        gcc
        bear
        gdb
        cmake
        llvmPackages.libcxx
      ];
    })
  ];
}
