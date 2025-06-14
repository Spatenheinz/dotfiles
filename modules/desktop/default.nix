{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop;
in {

  options.modules.desktop = {
    enable = mkBoolOpt true;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      nitrogen
      xclip
      xdotool
      xorg.xwininfo
      gtk4
      gtk3
      dunst
      xpra
      # scripts
      xorg.xkill
      killall
      brightnessctl # not really necessary but maybe easier than using xbacklight
      bc
    ];

    fonts = {
      fontDir.enable = true;
      enableGhostscriptFonts = true;
      packages = with pkgs; [
        ubuntu_font_family
        dejavu_fonts
        symbola
        iosevka
        font-awesome
        font-awesome_5
        material-icons
        texlivePackages.miama
        (nerdfonts.override { fonts = [ "FiraCode" "Hack" ]; })
      ];
    };


    ## Apps/Services
    services = {
      # picom.enable = true;
      # redshift.enable = true;
      displayManager.sddm.enable = true;
      displayManager.sddm.wayland.enable = true;
      xserver = {
        enable = true;
        # desktopManager.xfce.enable = true;

        xkb = {
          layout = "us,dk";
          options = "grp:rwin_switch,grp:rctrl_switch,caps:escape";
          model = "pc105";
        };
      };

       libinput = {
         enable = true;
          touchpad = {
            naturalScrolling = true;
            # tapping = true;
          };
       };
    };

    services.picom = {
      backend = "glx";
      vSync = true;
      opacityRules = [
        # "100:class_g = 'Firefox'"
        # "100:class_g = 'Vivaldi-stable'"
        "100:class_g = 'VirtualBox Machine'"
        # Art/image programs where we need fidelity
        "100:class_g = 'Gimp'"
        "100:class_g = 'Inkscape'"
        "100:class_g = 'aseprite'"
        "100:class_g = 'krita'"
        "100:class_g = 'nitrogen'"
        "100:class_g = 'mpv'"
        "80:class_g = 'Rofi'"
        "100:class_g = 'Peek'"
        "99:_NET_WM_STATE@:32a = '_NET_WM_STATE_FULLSCREEN'"
      ];
      shadowExclude = [
        # Put shadows on notifications, the scratch popup and rofi only
        "! name~='(rofi|scratch|Dunst)$'"
      ];
      settings = {
        blur-background-exclude = [
          "window_type = 'dock'"
          "window_type = 'desktop'"
          "class_g = 'Rofi'"
          "_GTK_FRAME_EXTENTS@:c"
        ];

        # Unredirect all windows if a full-screen opaque window is detected, to
        # maximize performance for full-screen windows. Known to cause
        # flickering when redirecting/unredirecting windows.
        unredir-if-possible = true;

        # GLX backend: Avoid using stencil buffer, useful if you don't have a
        # stencil buffer. Might cause incorrect opacity when rendering
        # transparent content (but never practically happened) and may not work
        # with blur-background. My tests show a 15% performance boost.
        # Recommended.
        glx-no-stencil = true;

        # Use X Sync fence to sync clients' draw calls, to make sure all draw
        # calls are finished before picom starts drawing. Needed on
        # nvidia-drivers with GLX backend for some users.
        xrender-sync-fence = true;
      };
    };

    # Try really hard to get QT to respect my GTK theme.
    env.GTK_DATA_PREFIX = [ "${config.system.path}" ];
    env.QT_QPA_PLATFORMTHEME = "gnome";
    env.QT_STYLE_OVERRIDE = "kvantum";

    services.xserver.displayManager.sessionCommands = ''
      # GTK2_RC_FILES must be available to the display manager.
      export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc"
    '';

    # Clean up leftovers, as much as we can
    system.userActivationScripts.cleanupHome = ''
      pushd "${config.user.home}"
      rm -rf .compose-cache .nv .pki .dbus .fehbg
      [ -s .xsession-errors ] || rm -f .xsession-errors*
      popd
    '';

    services.autorandr = {
      enable = true;
    };

    systemd.user.services."dunst" = {
      enable = true;
      description = "Notification daemon";
      wantedBy = [ "default.target" ];
      serviceConfig.Restart = "always";
      serviceConfig.RestartSec = 2;
      serviceConfig.ExecStart = "${pkgs.dunst}/bin/dunst";
    };


  };
}
