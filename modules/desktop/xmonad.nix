{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.xmonad;
    configDir = config.dotfiles.configDir;
in {
  options.modules.desktop.xmonad = {
    enable = mkBoolOpt false;
  };

  # TODO: move nethogs somewhere appropriate
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      lightdm
      libnotify
      eww
      stack
      haskellPackages.xmobar

      nethogs
      libinput
      # scripts
      xorg.xprop
      pamixer
      gawk
      ripgrep
      networkmanager
      brightnessctl
      bc
      playerctl
    ];

    services = {
      displayManager = {
        defaultSession = "none+xmonad";
      };

      xserver = {
        enable = true;
        windowManager.xmonad = {
	        enable = true;
	        enableContribAndExtras = true;
	      };
      };
    };

    systemd.user.services."dunst" = {
      enable = true;
      description = "";
      wantedBy = [ "default.target" ];
      serviceConfig.Restart = "always";
      serviceConfig.RestartSec = 2;
      serviceConfig.ExecStart = "${pkgs.dunst}/bin/dunst";
    };

    # link recursively so other modules can link files in their folders
    home.configFile = {
      "xmonad/build" = {
        source = "${configDir}/xmonad/build";
        recursive = true;
      };
      "xmonad/xmonad-bin" = {
        source = "${configDir}/xmonad/xmonad-x86_64-linux";
        recursive = true;
        executable = true;
      };
    };
  };
}
