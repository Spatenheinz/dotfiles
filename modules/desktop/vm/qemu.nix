{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.vm.qemu;
in {
  options.modules.desktop.vm.qemu = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    virtualisation.libvirtd.enable = true;
    programs.dconf.enable = true;
    environment.systemPackages = with pkgs; [
      qemu
      virt-manager
      virtiofsd
    ];
    user.extraGroups = [ "libvirtd" ];
  };
}
