{ inputs, config, lib, pkgs, ... }:

with lib;
with lib.my;
{
  imports =
    # I use home-manager to deploy files to $HOME; little else
    [ inputs.home-manager.nixosModules.home-manager
    ]
    # All my personal modules
    ++ (mapModulesRec' (toString ./modules) import);

  # Common config for all nixos machines; and to ensure the flake operates
  # soundly
  environment.variables.DOTFILES = config.dotfiles.dir;
  environment.variables.DOTFILES_BIN = config.dotfiles.binDir;

  # Configure nix and nixpkgs
  environment.variables.NIXPKGS_ALLOW_UNFREE = "1";
  nix =
    let filteredInputs = filterAttrs (n: _: n != "self") inputs;
        nixPathInputs  = mapAttrsToList (n: v: "${n}=${v}") filteredInputs;
        registryInputs = mapAttrs (_: v: { flake = v; }) filteredInputs;
    in {
      package = pkgs.nixVersions.stable;
      extraOptions = "experimental-features = nix-command flakes";
      nixPath = nixPathInputs ++ [
        "nixpkgs-overlays=${config.dotfiles.dir}/overlays"
        "dotfiles=${config.dotfiles.dir}"
      ];
      registry = registryInputs // { dotfiles.flake = inputs.self; };
      settings = {
        substituters = [
          "https://nix-community.cachix.org"
        ];
        trusted-public-keys = [
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        ];
        auto-optimise-store = true;
      };
    };
  system.configurationRevision = with inputs; mkIf (self ? rev) self.rev;
  system.stateVersion = "24.05";

  fileSystems."/".device = mkDefault "/dev/disk/by-label/nixos";
  networking.useDHCP = mkDefault false;

  # Use the latest kernel
  boot = {
    kernelPackages = mkDefault pkgs.linuxKernel.packages.linux_6_6;
    loader = {
      efi.canTouchEfiVariables = mkDefault true;
      systemd-boot.configurationLimit = 10;
      systemd-boot.enable = mkDefault true;
    };
  };

  programs.command-not-found.enable = mkDefault true;

  # Just the bear necessities...
  environment.systemPackages = with pkgs; [
    bind
    cached-nix-shell
    git
    ripgrep
    fd
    eza
    bat
    entr
    fzf
    vim
    wget
    gnumake
    unzip
    zip
    just
    tldr
  # TODO
  inputs.openconnect-sso.packages.${config.nixpkgs.localSystem.system}.default
  ];
}
