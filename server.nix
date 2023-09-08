{ config, pkgs, ... }:
let projectName = "website";
in
{
  users.groups."${projectName}" = {};
  users.users."${projectName}" = {
    isSystemUser = true;
    group = "${projectName}";
  };

  services.postgresql.enable = true;
  services.postgresql.package = pkgs.postgresql_15;
  # TODO: move db password out of git repo
  services.postgresql.initialScript = pkgs.writeText "psql-init" ''
    CREATE USER ${projectName} WITH SUPERUSER PASSWORD '${projectName}';
    CREATE DATABASE ${projectName} WITH OWNER ${projectName};
  '';

  # Use nginx or keter in production
  systemd.services."${projectName}" = let app = import (./.); in {
    description = "Yesod ${projectName} template";
    script = ''
      export YESOD_PGUSER=${projectName}
      export YESOD_STATIC_DIR=/srv/${projectName}/static
      export JOB_MARKETPLACE_SESSION=/srv/${projectName}/client_session_key.aes
      ${app}/bin/${projectName}
    '';
    wantedBy = ["multi-user.target" "ngingx.service" ];
    serviceConfig = {
      User = "${projectName}";
      Group = "${projectName}";
      # AmbientCapabilities = "CAP_NET_BIND_SERVICE";
      ExecStartPre = [
        "!/usr/bin/env mkdir -p /srv/${projectName}"
        "!/usr/bin/env cp -r ${app}/static /srv/${projectName}/"
        "!/usr/bin/env chown -R ${projectName}:${projectName} /srv/${projectName}"
        # TODO: remove runtime rewrite:
        #        * set addStaticContent _ _ _ = pure Nothing
        #        * generate files during build postInstall
        "!/usr/bin/env chmod u+w /srv/${projectName}/static/tmp"
      ];
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
