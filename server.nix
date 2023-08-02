{ config, pkgs, ... }:
{
  users.groups.jobMarketplace = {};
  users.users.jobMarketplace = {
    isSystemUser = true;
    group = "jobMarketplace";
  };

  # Use nginx or keter in production
  systemd.services."job-marketplace" = {
    description = "Job marketplace";
    script = let app = import (./.); in "${app}/bin/job-marketplace";
    wantedBy = ["multi-user.target" "ngingx.service" ];
    serviceConfig = {
      User = "jobMarketplace";
      Group = "jobMarketplace";
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
