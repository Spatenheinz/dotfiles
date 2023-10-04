{ config, options, pkgs, lib, ... }:

with lib;
with lib.my;
let cfg = config.modules.shell.nushell;
    configDir = config.dotfiles.configDir;
in {
  options.modules.shell.nushell = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      nushell
      starship
    ];

    home.configFile = {
      "nushell/config.nu" = {
        source = "${configDir}/nushell/config.nu";
      };
      "nushell/env.nu" = {
        source = "${configDir}/nushell/env.nu";
      };
    };
  };
}
