{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.gaming.emulators;
in {
  # TODO: see if we can get psx to work
  options.modules.desktop.gaming.emulators = {
    ds.enable   = mkBoolOpt false;  # Nintendo DS
    gb.enable   = mkBoolOpt false;  # GameBoy + GameBoy Color
    gba.enable  = mkBoolOpt false;  # GameBoy Advance
    snes.enable = mkBoolOpt false;  # Super Nintendo
  };

  config = {
    user.packages = with pkgs; [
      (mkIf cfg.ds.enable desmume)
      (mkIf (cfg.gba.enable ||
             cfg.gb.enable  ||
             cfg.snes.enable)
        higan)
    ];
  };
}
