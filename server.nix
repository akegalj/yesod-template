{ config, pkgs, ... }:
{
  users.groups.yesod-htmx-template = {};
  users.users.yesodHtmxTemplate = {
    isSystemUser = true;
    group = "yesodHtmxTemplate";
  };

  # Use nginx or keter in production
  systemd.services."yesod-htmx-template" = {
    description = "Yesod htmx template";
    script = let app = import (./.); in "${app}/bin/yesod-htmx-template";
    wantedBy = ["multi-user.target" "ngingx.service" ];
    serviceConfig = {
      User = "yesodHtmxTemplate";
      Group = "yesodHtmxTemplate";
      # AmbientCapabilities = "CAP_NET_BIND_SERVICE";
      Restart = "always";
      RestartSec = "10s";
    };
    after = [
      "network.target"
      "local-fs.target"
      "postgresql.service"
    ];
  };

  networking.firewall.allowedTCPPorts = [ 3000 ];
}
