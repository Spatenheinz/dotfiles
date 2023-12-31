{ options, config, lib, ... }:

with lib;
with lib.my;
let cfg = config.modules.services.ssh;
in {
  options.modules.services.ssh = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services.openssh = {
      enable = true;
    };

    # TODO
    user.openssh.authorizedKeys.keys =
      if config.user.name == "spatenheinz"
      then [ ]
      else [];
  };
}
