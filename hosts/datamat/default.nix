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
      nushell.enable = true;
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
    };
  };


  ## Local config
  programs.ssh.startAgent = true;
  services.openssh.startWhenNeeded = true;

  #networking.wireless.enable = true;
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Copenhagen";
}
