
{ config, pkgs, systemSettings, ... }:
{
  programs.chromium = {
      enable = true;
      #package = pkgs.brave;
      extensions = [
        "nngceckbapebfimnlniiiahkandclblb" # Bitwarden
        "mclkkofklkfljcocdinagocijmpgbhab" # Google input tools 
        "edibdbjcniadpccecjdfdjjppcpchdlm" # I dont care about cookies
        "oldceeleldhonbafppcapldpdifcinji" # Grammar
        "aapbdbdomjkkjkaonfhkkikfgjllcleb" # Google translate
        "gebbhagfogifgggkldgodflihgfeippi" # Youtube return dislikes
        "cjpalhdlnbpafiamejdnhcphjbkeiagm" # Ublock origin
        "logpjaacgmcbpdkdchjiaagddngobkck" # Shortcuts
        "kjjgifdfplpegljdfnpmbjmkngdilmkd" # Link highlights
      ];
      extraOpts = {
        #  
        "BrowserSignin" = 0;
        "SyncDisabled" = true;
        "PasswordManagerEnabled" = false;
        "SpellcheckEnabled" = true;
        "RestoreOnStartup" = 1; # Open last session
        "HomepageLocation" = "https://www.google.com";
        "HomepageIsNewTabPage" = true;
        "InsecureFormsWarningsEnabled" = true;
        "PromptForDownloadLocation" = true;
        "BookmarkBarEnabled" = false;
        "EditBookmarksEnabled" = false;

       };
    };
  users.users.${systemSettings.shared.username}.packages = with pkgs; [
    chromium
  ];
}
