{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.services.docker;
    configDir = config.dotfiles.configDir;
in {
  options.modules.services.docker = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      docker
      docker-compose
      # TODO move
      xfce.thunar
    ];

    env.DOCKER_CONFIG = "$XDG_CONFIG_HOME/docker";
    env.MACHINE_STORAGE_PATH = "$XDG_DATA_HOME/docker/machine";

    user.extraGroups = [ "docker" ];

    modules.shell.zsh.rcFiles = [ "${configDir}/docker/aliases.zsh" ];


    networking.firewall.allowedTCPPorts = [
      3301 # signoz requirement
      4317 # allow jaeger gRPC
      4318 # allow jaeger HTTP
      8080
      50051
    ];

    virtualisation = {
      docker = {
        enable = true;
        autoPrune.enable = true;
        enableOnBoot = mkDefault false;
        logDriver = "json-file";
      };
    };
  };
}
