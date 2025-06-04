{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.hardware.battery;
in {
  options.modules.hardware.battery = {
    enable = mkBoolOpt true;
  };

  config = mkIf cfg.enable {
    services.tlp.enable = true;
  };
}
