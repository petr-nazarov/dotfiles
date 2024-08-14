
{ config, pkgs, systemSettings, ... }:

{
  virtualisation.docker.daemon.settings = {
       log-driver = "loki";
       log-opts = {
            loki-url = "http://localhost:3100/loki/api/v1/push";
            loki-batch-size = "400";
            loki-retries="2";
            loki-max-backoff="800ms";
            loki-timeout="1s";
       };
  };
}
