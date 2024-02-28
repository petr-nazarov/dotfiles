
{ config, pkgs, ... }:
{
  
  
  programs.firefox = {
      enable = true;
      policies = {
        "BlockAboutProfiles" = false;
        "Homepage" = {
            "URL" = "https://google.com/en";
            "StartPage" = "previous-session";
          };
        "OfferToSaveLogins" = false;
        "DisplayBookmarksToolbar" = "never";
        "ExtensionSettings" = {
           "{446900e4-71c2-419f-a6a7-df9c091e268b}" =  {
             "installation_mode" = "force_installed";
             "install_url" =  "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
             "default_area" = "navbar";
           };
           "uBlock0@raymondhill.net" =  {
             "installation_mode" = "force_installed";
             "install_url" =  "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
             "default_area" = "navbar";
           };
           "languagetool-webextension@languagetool.org" =  {
             "installation_mode" = "force_installed";
             "install_url" =  "https://addons.mozilla.org/firefox/downloads/latest/languagetool/latest.xpi";
             "default_area" = "navbar";
           };
           "{036a55b4-5e72-4d05-a06c-cba2dfcc134a}" =  {
             "installation_mode" = "force_installed";
             "install_url" =  "https://addons.mozilla.org/firefox/downloads/latest/traduzir-paginas-web/latest.xpi";
             "default_area" = "navbar";
           };
           "{762f9885-5a13-4abd-9c77-433dcd38b8fd}" =  {
             "installation_mode" = "force_installed";
             "install_url" =  "https://addons.mozilla.org/firefox/downloads/latest/return-youtube-dislikes/latest.xpi";
             "default_area" = "menupanel";
           };
           "{7b1bf0b6-a1b9-42b0-b75d-252036438bdc}" =  {
             "installation_mode" = "force_installed";
             "install_url" =  "https://addons.mozilla.org/firefox/downloads/latest/youtube-high-definition/latest.xpi";
             "default_area" = "menupanel";
           };
           "idcac-pub@guus.ninja" =  {
             "installation_mode" = "force_installed";
             "install_url" =  "https://addons.mozilla.org/firefox/downloads/latest/istilldontcareaboutcookies/latest.xpi";
             "default_area" = "menupanel";
           };
           "Shortkeys@Shortkeys.com" =  {
             "installation_mode" = "force_installed";
             "install_url" =  "https://addons.mozilla.org/firefox/downloads/latest/shortkeys/latest.xpi";
             "default_area" = "menupanel";
           };
           "@testpilot-containers" =  {
             "installation_mode" = "force_installed";
             "install_url" =  "https://addons.mozilla.org/firefox/downloads/latest/multi-account-containers/latest.xpi";
             "default_area" = "menupanel";
           };
        };
      };
      profiles = {
          personal = {
              id = 0;
              search = {
                default = "Google";
                privateDefault = "Google";
              };
              containers = {
                personal = {
                  id = 1;
                  color="blue";
                  icon="chill";
                };
                work = {
                  id = 2;
                  color="red";
                  icon="briefcase";
                };

              };
          };
        };
    };
}
