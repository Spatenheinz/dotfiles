{ config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.services.discord;
in {
  options.modules.services.discord = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      discord
    ];
  };
}
