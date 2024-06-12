{ config, lib, pkgs, inputs, ... }:

with lib;
with lib.my;
let cfg = config.modules.editors.emacs;
    configDir = config.dotfiles.configDir;
    forgeUrl = "https://github.com";
    repoUrl = "${forgeUrl}/doomemacs/doomemacs";
in {
  options.modules.editors.emacs = {
    enable = mkBoolOpt false;
    doom = {
      enable = mkBoolOpt false;
    };
  };

  config = mkIf cfg.enable {
    services.emacs = {
      enable = true;
      package = pkgs.emacs29-gtk3;
    };

    nixpkgs.overlays = [ inputs.emacs-overlay.overlay ];

    user.packages = with pkgs; [
      binutils
      ## Doom dependencies
      git
      (ripgrep.override {withPCRE2 = true;})
      gnutls              # for TLS connectivity

      ## Optional dependencies
      fd                  # faster projectile indexing
      imagemagick         # for image-dired
      (mkIf (config.programs.gnupg.agent.enable)
        pinentry_emacs)   # in-emacs gnupg prompts
      zstd                # for undo-fu-session/undo-tree compression

      ## Module dependencies
      (aspellWithDicts (ds: with ds; [ en en-computers en-science ]))
      editorconfig-core-c # per-project style config
      sqlite
      texlive.combined.scheme-full
    ];

    env.PATH = [ "$XDG_CONFIG_HOME/emacs/bin" ];

    modules.shell.zsh.rcFiles = [ "${configDir}/emacs/aliases.zsh" ];

    fonts.packages = [ pkgs.emacs-all-the-icons-fonts ];

    # TODO
    system.userActivationScripts = mkIf cfg.doom.enable {
      installDoomEmacs = ''
        cat ${config.system.build.setEnvironment} > ${configDir}/doom/set-environment
        if [ ! -d "$XDG_CONFIG_HOME/emacs" ]; then
           git clone --depth=1 --single-branch "${repoUrl}" "$XDG_CONFIG_HOME/emacs"
        fi
        ln -sf "${configDir}/doom" "$XDG_CONFIG_HOME/doom"
      '';
    };
  };
}
