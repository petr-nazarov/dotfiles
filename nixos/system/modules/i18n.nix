{ config, pkgs, systemSettings, ... }:

{
  # Set your time zone.
  time.timeZone =  systemSettings.shared.timezone;

  # enable automatic timezone updates. 
  services.automatic-timezoned.enable = true;

  # select internationalisation properties.
  i18n.defaultLocale = systemSettings.shared.locale;

  i18n.extraLocaleSettings = {
    language = systemSettings.shared.locale;
    lc_all = systemSettings.shared.locale;
    lc_address = systemSettings.shared.locale;
    lc_identification = systemSettings.shared.locale;
    lc_measurement = systemSettings.shared.locale;
    lc_monetary = systemSettings.shared.locale;
    lc_name = systemSettings.shared.locale;
    lc_numeric = systemSettings.shared.locale;
    lc_paper = systemSettings.shared.locale;
    lc_telephone = systemSettings.shared.locale;
    lc_time = systemSettings.shared.locale;
  };
}
