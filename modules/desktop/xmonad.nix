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
      dunst
      libnotify
      eww
      stack
      haskellPackages.xmobar

      nethogs
    ];

    services = {
      picom.enable = true;
      redshift.enable = true;
      xserver = {
        enable = true;
        displayManager = {
          defaultSession = "none+xmonad";
          lightdm.enable = true;
          lightdm.greeters.mini.enable = true;
        };
        windowManager.xmonad = {
	        enable = true;
	        enableContribAndExtras = true;
	      };

        # TODO: should be moved somewhere else
   	    libinput = {
	        enable = true;
	        touchpad = {
	          naturalScrolling = true;
	        };
	      };
        layout = "us,dk";
	      xkbOptions = "grp:rwin_switch, caps:escape";
	      xkbModel = "pc105";
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
