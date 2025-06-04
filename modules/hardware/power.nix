{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.hardware.power;
  hibernateEnvironment = {
    HIBERNATE_SECONDS = "10";
    HIBERNATE_LOCK = "/var/run/autohibernate.lock";
  };
in {
  options.modules.hardware.power = {
    enable = mkBoolOpt true;
  };

  config = mkIf cfg.enable {
      services.logind.lidSwitch =  "suspend-then-hibernate";
      systemd.sleep.extraConfig = ''
          HibernateDelaySec=60min
      '';
      security.protectKernelImage = mkForce false;
      # TODO: fix this mess
      powerManagement.resumeCommands = ''
         eww reload
      '';
      services.cron.enable = true;
      services.cron.systemCronJobs = [
        "*/5 * * * *  root ${config.dotfiles.binDir}/system/pm-hibernate"
      ];
      # systemd.services."awake-after-suspend-for-a-time" = {
      #   description = "Sets up the suspend so that it'll wake for hibernation only if not on AC power";
      #   wantedBy = [ "suspend.target" ];
      #   before = [ "systemd-suspend.service" ];
      #   environment = hibernateEnvironment;
      #   script = ''
      #     if [ $(cat /sys/class/power_supply/AC/online) -eq 0 ]; then
      #       curtime=$(date +%s)
      #       echo "$curtime $1" >> /tmp/autohibernate.log
      #       echo "$curtime" > $HIBERNATE_LOCK
      #       ${pkgs.utillinux}/bin/rtcwake -m no -s $HIBERNATE_SECONDS
      #     else
      #       echo "System is on AC power, skipping wake-up scheduling for hibernation." >> /tmp/autohibernate.log
      #     fi
      #   '';
      #   serviceConfig.Type = "simple";
      # };

      # systemd.services."hibernate-after-recovery" = {
      #   description = "Hibernates after a suspend recovery due to timeout";
      #   wantedBy = [ "suspend.target" ];
      #   after = [ "systemd-suspend.service" ];
      #   environment = hibernateEnvironment;
      #   script = ''
      #     curtime=$(date +%s)
      #     sustime=$(cat $HIBERNATE_LOCK)
      #     rm $HIBERNATE_LOCK
      #     if [ $(($curtime - $sustime)) -ge $HIBERNATE_SECONDS ] ; then
      #       systemctl hibernate
      #     else
      #       ${pkgs.utillinux}/bin/rtcwake -m no -s 1
      #     fi
      #   '';
      #   serviceConfig.Type = "simple";
      # };

  };
}
