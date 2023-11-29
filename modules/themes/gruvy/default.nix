{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.theme;
    colType = cfg.colors.types;
in {
  config = mkIf (cfg.active == "gruvy") (mkMerge [
    # Desktop-agnostic configuration
    {
      modules = {
        theme = {
          wallpaper = mkDefault ./config/wallpaper.png;
          gtk = {
            theme = "Gruvbox-Dark-B";
            iconTheme = "GruvboxPlus";
            cursorTheme = "Paper";
          };
          fonts = {
            sans.name = "Iosevka Sans";
            mono.name = "Iosevka";
          };
          colors = {
            black         = "#282828";
            red           = "#cc241d";
            green         = "#98971a";
            yellow        = "#d79921";
            blue          = "#458588";
            magenta       = "#b16286";
            cyan          = "#689d6a";
            silver        = "#a89984";
            grey          = "#928374";
            brightred     = "#fb4934";
            brightgreen   = "#b8bb26";
            brightyellow  = "#fabd2f";
            brightblue    = "#83a598";
            brightmagenta = "#d3869b";
            brightcyan    = "#8ec07c";
            white         = "#ebdbb2";
            orange        = "#d65d0e";
            brightorange  = "#fe8019";

            types.border  = "#3c3836";
          };
        };

        shell.zsh.rcFiles  = [ ./config/zsh/prompt.zsh ];
        shell.tmux.rcFiles = [ ./config/tmux.conf ];
        desktop.browsers = {
          firefox.userChrome = concatMapStringsSep "\n" readFile [
            ./config/firefox/userChrome.css
          ];
          qutebrowser.userStyles = concatMapStringsSep "\n" readFile
            (map toCSSFile [
              ./config/qutebrowser/userstyles/monospace-textareas.scss
              ./config/qutebrowser/userstyles/stackoverflow.scss
              ./config/qutebrowser/userstyles/xkcd.scss
            ]);
        };
      };
    }

    # Desktop (X11) theming
    (mkIf config.services.xserver.enable {
      user.packages = with pkgs; [
        gruvbox-gtk-theme
        my.gruvbox-plus
        unstable.dracula-theme
        paper-icon-theme
        themechanger
      ];

      # Compositor
      # services.picom = {
      #   fade = true;
      #   fadeDelta = 1;
      #   fadeSteps = [ 0.01 0.012 ];
      #   shadow = true;
      #   shadowOffsets = [ (-10) (-10) ];
      #   shadowOpacity = 0.22;
      #   settings = {
      #     shadow-radius = 12;
      #     blur-kern = "7x7box";
      #     blur-strength = 320;
      #   };
      # };

      # Login screen theme
      services.xserver.displayManager.lightdm.greeters.mini.extraConfig = ''
        text-color = "${cfg.colors.magenta}"
        password-background-color = "${colType.bg}"
        window-color = "${colType.border}"
        border-color = "${colType.border}"
      '';

      # Other dotfiles
      home.configFile = with config.modules; mkMerge [
        {
          # Sourced from sessionCommands in modules/themes/default.nix
          "xtheme/90-theme".source = ./config/Xresources;
        }
        (mkIf desktop.xmonad.enable {
          "xmonad/00-theme".text = ''
             black          ${cfg.colors.black}
             red            ${cfg.colors.red}
             green          ${cfg.colors.green}
             yellow         ${cfg.colors.yellow}
             blue           ${cfg.colors.blue}
             magenta        ${cfg.colors.magenta}
             cyan           ${cfg.colors.cyan}
             silver         ${cfg.colors.silver}
             grey           ${cfg.colors.grey}
             brightred      ${cfg.colors.brightred}
             brightgreen    ${cfg.colors.brightgreen}
             brightyellow   ${cfg.colors.brightyellow}
             brightblue     ${cfg.colors.brightblue}
             brightmagenta  ${cfg.colors.brightmagenta}
             brightcyan     ${cfg.colors.brightcyan}
             white          ${cfg.colors.white}
             orange         ${cfg.colors.orange}
          '';
        })
        (mkIf desktop.apps.rofi.enable {
         "rofi/current.rasi".text = ''
             * {
                 bg-col:  ${colType.bg};
                 bg-col-light: ${colType.warning};
                 border-col: ${colType.border};
                 selected-col: ${colType.error};
                 randomcolor: ${cfg.colors.cyan};
                 fg-col: ${colType.fg};
                 fg-col2: ${colType.fg};
                 subtext: ${cfg.colors.silver};
                 width: 900;
             }
           '';
        })
        (mkIf desktop.media.graphics.vector.enable {
          "inkscape/templates/default.svg".source = ./config/inkscape/default-template.svg;
        })
        (mkIf desktop.browsers.qutebrowser.enable {
          "qutebrowser/extra/theme.py".source = ./config/qutebrowser/theme.py;
        })
      ];
    })
  ]);
}
