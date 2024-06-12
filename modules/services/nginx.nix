{ config, options, lib, pkgs, ... }:

with builtins;
with lib;
with lib.my;
let cfg = config.modules.services.nginx;
in {
  options.modules.services.nginx = {
    enable = mkBoolOpt false;
  };

  config = mkMerge [
    (mkIf cfg.enable {
      networking.firewall.allowedTCPPorts = [ 80 443 ];

      user.extraGroups = [ "nginx" ];

      services.nginx = {
        enable = true;

        # Use recommended settings
        recommendedGzipSettings = true;
        recommendedOptimisation = true;
        recommendedProxySettings = true;
        recommendedTlsSettings = true;

        # Reduce the permitted size of client requests, to reduce the likelihood
        # of buffer overflow attacks. This can be tweaked on a per-vhost basis,
        # as needed.
        clientMaxBodySize = "256k";  # default 10m
        # Significantly speed up regex matchers
        appendConfig = ''pcre_jit on;'';
        commonHttpConfig = ''
          client_body_buffer_size  4k;       # default: 8k
          large_client_header_buffers 2 4k;  # default: 4 8k

          map $sent_http_content_type $expires {
              default                    off;
              text/html                  10m;
              text/css                   max;
              application/javascript     max;
              application/pdf            max;
              ~image/                    max;
          }
        '';
      };
    })

  ];
}
