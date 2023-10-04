{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.term.kitty;
    configDir = config.dotfiles.configDir;
in {
  options.modules.desktop.term.kitty = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    # xst-256color isn't supported over ssh, so revert to a known one
    # modules.shell.zsh.rcInit = ''
    #   [ "$TERM" = xterm- ] && export TERM=xterm-256color
    # '';

    user.packages = with pkgs; [
      kitty
    ];

    home.configFile = {
      "kitty/kitty.conf".source = "${configDir}/kitty/kitty.conf";
    };

  };
}
