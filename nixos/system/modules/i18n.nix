{ config, pkgs, systemSettings, ... }:

{
  # Set your time zone.
  time.timezone =  systemsettings.shared.timezone;

  # enable automatic timezone updates. 
  services.automatic-timezoned.enable = true;

  # select internationalisation properties.
  i18n.defaultlocale = systemsettings.shared.locale;

  i18n.extralocalesettings = {
    language = systemsettings.shared.locale;
    lc_all = systemsettings.shared.locale;
    lc_address = systemsettings.shared.locale;
    lc_identification = systemsettings.shared.locale;
    lc_measurement = systemsettings.shared.locale;
    lc_monetary = systemsettings.shared.locale;
    lc_name = systemsettings.shared.locale;
    lc_numeric = systemsettings.shared.locale;
    lc_paper = systemsettings.shared.locale;
    lc_telephone = systemsettings.shared.locale;
    lc_time = systemsettings.shared.locale;
  };
}
