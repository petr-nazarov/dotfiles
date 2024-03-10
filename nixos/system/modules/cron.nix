
{ config, pkgs, ... }:

{
  services.cron = {
    enable = true;
    systemCronJobs = [
      "* * * * * /home/nazarov/Projects/Personal/Vault/run.sh"

    ];
  };

}
