# datamat - Lenovo T15

{ ... }:
{
  imports = [
    ../home.nix
    ./hardware-configuration.nix
  ];

  ## Modules
  modules = {
    desktop = {
      hyprland.enable = true;
      xmonad.enable = true;
      apps = {
        rofi.enable = true;
      };
      browsers = {
        default = "firefox";
        firefox.enable = true;
        # qutebrowser.enable = true;
      };
      gaming = {
        steam.enable = true;
        emulators.gba.enable = true;
      };
      media = {
        documents= {
          enable = true;
          ebook.enable = true;
        };
        graphics.enable = true;
        spotify.enable = true;
      };
      term = {
        default = "kitty";
        kitty.enable = true;
      };
      vm = {
        qemu.enable = true;
        vagrant.enable = true;
        # virtualbox.enable = true;
      };
    };
  dev = {
      rust.enable = true;
      python.enable = true;
      cc.enable = true;
      shell.enable = true;
      nodejs.enable = true;
      haskell.enable = true;
    };
    editors = {
      default = "nvim";
      emacs = {
        enable = true;
        doom.enable = true;
      };
      vim.enable = true;
    };
    shell = {
      # adl.enable = true;
      # vaultwarden.enable = true;
      direnv.enable = true;
      git.enable    = true;
      # gnupg.enable  = true;
      tmux.enable   = true;
      zsh.enable    = true;
    };
    services = {
      # discourse.enable = true;
      discord.enable = true;
      ssh.enable = true;
      docker.enable = true;
    };
    theme.active = "gruvy";
    hardware = {
      audio.enable = true;
      bluetooth.enable = true;
      battery.enable = true;
      power.enable = true;
    };
  };


  ## Local config
  programs.ssh.startAgent = true;
  services.openssh.startWhenNeeded = true;

  #networking.wireless.enable = true;
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Copenhagen";

  # TMP
  services.udev.extraRules = ''
    # CMSIS-DAP for microbit

    ACTION!="add|change", GOTO="microbit_rules_end"

    SUBSYSTEM=="usb", ATTR{idVendor}=="0d28", ATTR{idProduct}=="0204", TAG+="uaccess"

    LABEL="microbit_rules_end"
   '';
}
