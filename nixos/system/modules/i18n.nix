{ config, pkgs, systemSettings, ... }:

{
  # Set your time zone.
  time.timeZone =  systemSettings.shared.timezone;

  # Enable automatic timezone updates. 
  services.automatic-timezoned.enable = true;

  # Select internationalisation properties.
  i18n.defaultLocale = systemSettings.shared.locale;

  i18n.extraLocaleSettings = {
    LANGUAGE = systemSettings.shared.locale;
    LC_ALL = systemSettings.shared.locale;
    LC_ADDRESS = systemSettings.shared.locale;
    LC_IDENTIFICATION = systemSettings.shared.locale;
    LC_MEASUREMENT = systemSettings.shared.locale;
    LC_MONETARY = systemSettings.shared.locale;
    LC_NAME = systemSettings.shared.locale;
    LC_NUMERIC = systemSettings.shared.locale;
    LC_PAPER = systemSettings.shared.locale;
    LC_TELEPHONE = systemSettings.shared.locale;
    LC_TIME = systemSettings.shared.locale;
  };
}
