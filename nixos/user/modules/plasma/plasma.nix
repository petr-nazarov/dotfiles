
{ config, pkgs, ... }:
{

   imports = [
    <plasma-manager/modules>
    #./plasma_orig.nix
   ];
   programs.plasma = {
    enable = true;
    shortcuts = {
      "KDE Keyboard Layout Switcher"."Switch to Next Keyboard Layout" = [ ];
      "kwin"."Overview" = "Meta+Shift+O";
      # Polonium
      "kwin"."PoloniumFocusAbove" = "Meta+K";
      "kwin"."PoloniumFocusBelow" = "Meta+J";
      "kwin"."PoloniumFocusLeft" = "Meta+H";
      "kwin"."PoloniumFocusRight" = "Meta+L";
      "kwin"."PoloniumInsertAbove" = "Meta+Shift+K";
      "kwin"."PoloniumInsertBelow" = "Meta+Shift+J";
      "kwin"."PoloniumInsertLeft" = "Meta+Shift+H";
      "kwin"."PoloniumInsertRight" = "Meta+Shift+L";
      "kwin"."PoloniumOpenSettings" = "Meta+\\,none";
      "kwin"."PoloniumResizeAbove" = "Meta+Ctrl+K";
      "kwin"."PoloniumResizeBelow" = "Meta+Ctrl+J";
      "kwin"."PoloniumResizeLeft" = "Meta+Ctrl+H";
      "kwin"."PoloniumResizeRight" = "Meta+Ctrl+L";
      "kwin"."PoloniumRetileWindow" = "Meta+Shift+Space";

      # General 
      "kwin"."Window Close" = ["Alt+F4" "Meta+Shift+Q"];
      "kwin"."Window Maximize" = "Meta+Shift+F";
      "kwin"."view_zoom_in" = "Meta++";
      "kwin"."view_zoom_out" = "Meta+-";
      "org_kde_powerdevil"."powerProfile" = ["Meta+Shift+B" "Battery"];
      "plasmashell"."show-on-mouse-pos" = "Meta+Shift+V";
      "services/org.kde.spectacle.desktop"."RectangularRegionScreenShot" = "Meta+Shift+S";
      "services/plasma-manager-commands.desktop"."bookmarks-open" = "Meta+E";


      #Virtual desktops 
      "kwin"."Switch to Desktop 1" = "Meta+1";
      "kwin"."Switch to Desktop 2" = "Meta+2";
      "kwin"."Switch to Desktop 3" = "Meta+3";
      "kwin"."Switch to Desktop 4" = "Meta+4";
      "kwin"."Switch to Desktop 5" = "Meta+5";
      "kwin"."Switch to Desktop 6" = "Meta+6";
      "kwin"."Switch to Desktop 7" = "Meta+7";
      "kwin"."Switch to Desktop 8" = "Meta+8";
      "kwin"."Switch to Desktop 9" = "Meta+9";
      "kwin"."Switch to Desktop 10" = "Meta+Tab";
      "kwin"."Switch to Desktop 11" = "Meta+`";

      "kwin"."Window to Desktop 1" = "Meta+!";
      "kwin"."Window to Desktop 2" = "Meta+@";
      "kwin"."Window to Desktop 3" = "Meta+#";
      "kwin"."Window to Desktop 4" = "Meta+$";
      "kwin"."Window to Desktop 5" = "Meta+%";
      "kwin"."Window to Desktop 6" = "Meta+^";
      "kwin"."Window to Desktop 7" = "Meta+&";
      "kwin"."Window to Desktop 8" = "Meta+*";
      "kwin"."Window to Desktop 9" = "Meta+(";
      "kwin"."Window to Desktop 10" = ["Meta+Shift+Tab" "Meta+)"];
      "kwin"."Window to Desktop 11" = "Meta+~";

    };
    hotkeys = {
      commands = {
          "application-launcher" = {
            name = "application-launcher";
            key = "Meta+Space";
            command = "fuzzel";
          };
          "bookmarks-edit" = {
            name = "Bookmarks Edit";
            key = "Meta+B";
            command = "./dotfiles/scripts/bookmarks-edit";
          };
          "bookmarks-copy" = {
            name = "Bookmarks Copy";
            key = "Meta+Shift+E";
            command = "./dotfiles/scripts/bookmarks-copy";
          };
          "bookmarks-open" = {
            name = "Bookmarks Open";
            key = "Meta+E";
            command = "./dotfiles/scripts/bookmarks-open";
          };
          "chrome-personal" = {
            name = "Chrome Personal";
            key = "Meta+W";
            command ="chromium --profile-directory=\"Profile 2\"";
          };
          "chrome-work" = {
            name = "Chrome Work";
            key = "Meta+Shift+W";
            command = "chromium --profile-directory=\"Profile 1\"";
          };
      };
    };
    configFile = {
      "kcminputrc"."Keyboard"."NumLock" = 0;
      "kcminputrc"."Libinput/10182/480/GXTP7863:00 27C6:01E0 Touchpad"."ClickMethod" = 2;
      "kcminputrc"."Libinput/10182/480/GXTP7863:00 27C6:01E0 Touchpad"."NaturalScroll" = true;
      "kcminputrc"."Libinput/10182/480/GXTP7863:00 27C6:01E0 Touchpad"."ScrollFactor" = 0.75;

      "kdeglobals"."General"."AllowKDEAppsToRememberWindowPositions" = true;
      "klipperrc"."General"."MaxClipItems" = 1000;
      "kwinrc"."Desktops"."Number" = 11;
      "kwinrc"."Desktops"."Rows" = 1;
      "plasma-localerc"."Formats"."LANG" = "en_GB.UTF-8";
    };
   };
}
