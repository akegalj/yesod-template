{ config, pkgs, ... }:
let projectName = "website";
in
{
  users.groups."${projectName}" = {};
  users.users."${projectName}" = {
    isSystemUser = true;
    group = "${projectName}";
  };

  # Use nginx or keter in production
  systemd.services."${projectName}" = {
    description = "Yesod ${projectName} template";
    script = let app = import (./.); in "${app}/bin/${projectName}";
    wantedBy = ["multi-user.target" "ngingx.service" ];
    serviceConfig = {
      User = "${projectName}";
      Group = "${projectName}";
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
