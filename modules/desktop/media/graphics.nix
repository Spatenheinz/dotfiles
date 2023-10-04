{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.media.graphics;
    configDir = config.dotfiles.configDir;
in {
  options.modules.desktop.media.graphics = {
    enable         = mkBoolOpt false;
    tools.enable   = mkBoolOpt true;
    raster.enable  = mkBoolOpt true;
    vector.enable  = mkBoolOpt true;
    sprites.enable = mkBoolOpt true;
    models.enable  = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs;
      (if cfg.tools.enable then [
        font-manager   # so many damned fonts...
        imagemagick    # for image manipulation from the shell
	      flameshot
      ] else []) ++

      # replaces illustrator & indesign
      (if cfg.vector.enable then [
        unstable.inkscape
      ] else []) ++

      # Replaces photoshop
      (if cfg.raster.enable then [
        gimp
      ] else []) ++

      # 3D modelling
      (if cfg.models.enable then [
        blender
      ] else []);
  };
}
