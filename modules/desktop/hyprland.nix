{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.hyprland;
    configDir = config.dotfiles.configDir;
in {
  options.modules.desktop.hyprland = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {

    programs.hyprland.enable = true;
    programs.hyprland.xwayland.enable = true;

    environment.sessionVariables = {
      WLR_NO_HARDWARE_CURSORS = "1";
      NIXOS_OZONE_WL = "1";
    };

    hardware.nvidia.modesetting.enable = true;
    hardware.opengl.enable = true;

    environment.systemPackages = with pkgs; [
      # wayland specific
      wofi
      swww

      # widgets
      eww
      socat


      kitty

      dunst
      libnotify
    ];

    xdg.portal.enable = true;
    xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  };
}
