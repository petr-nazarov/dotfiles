
{ config, pkgs, ... }:

{
systemd.timers."sync-vault" = {
  wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "1m";
      OnUnitActiveSec = "1m";
      Unit = "sync-vault.service";
    };
};

systemd.services."sync-vault" = {
  path = [ pkgs.git pkgs.openssh ];
  script = ''
    /home/nazarov/Projects/Personal/Vault/run.sh
  '';
  serviceConfig = {
    Type = "oneshot";
    User = "nazarov";
  };
};

}
