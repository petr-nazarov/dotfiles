
{ config, pkgs, ... }:
{
  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 16;
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "default";
    };
    "org/gnome/mutter" = {
     edge-tiling = true;
     workspaces-only-on-primary = true;
    };

    "org/gnome/desktop/peripherals/touchpad" = {
      tap-to-click= true;
    };

    "org/gnome/desktop/wm/preferences" ={
        num-workspaces = 11;
        focus-mode = "sloppy";
    };

    "org/gnome/desktop/input-sources" = {
        xkb-options = [
        "altwin:swap_alt_win"
        "caps:escape"
        ];
      };


     "org/gnome/shell" = {
        disable-user-extensions = false;

        enabled-extensions = [
          "workspace-indicator@gnome-shell-extensions.gcampax.github.com"
          "clipboard-history@alexsaveau.dev"
          "instantworkspaceswitcher@amalantony.net"
          "workspace-switcher-manager@G-dH.github.com"
        ];
      };

    "org/gnome/mutter/keybindings" = {
        toggle-tiled-left = ["<Shift><Super>h"];
        toggle-tiled-right = ["<Shift><Super>l"];
      };
    "org/gnome/shell/keybindings" = {
        switch-to-application-1 = [];
        switch-to-application-2 = [];
        switch-to-application-3 = [];
        switch-to-application-4 = [];
        switch-to-application-5 = [];
        switch-to-application-6 = [];
        switch-to-application-7 = [];
        switch-to-application-8 = [];
        switch-to-application-9 = [];
        switch-to-application-10 = [];

        show-screenshot-ui = ["<Shift><Super>s"];

    };


    "org/gnome/desktop/wm/keybindings" = {
        switch-applications = [];
        switch-applications-backward = [];
        switch-group = [];
        switch-group-backward = [];
        switch-input-source = [];
        switch-input-source-backward = [];
        close = ["<Shift><Super>q"];
        minimize = [];
        switch-to-workspace-1 = ["<Super>1"];
        switch-to-workspace-2 = ["<Super>2"];
        switch-to-workspace-3 = ["<Super>3"];
        switch-to-workspace-4 = ["<Super>4"];
        switch-to-workspace-5 = ["<Super>5"];
        switch-to-workspace-6 = ["<Super>6"];
        switch-to-workspace-7 = ["<Super>7"];
        switch-to-workspace-8 = ["<Super>8"];
        switch-to-workspace-9 = ["<Super>9"];
        switch-to-workspace-10 = ["<Super>Tab"];
        switch-to-workspace-11 = ["<Super>grave"];
        move-to-workspace-1 = ["<Shift><Super>1"];
        move-to-workspace-2 = ["<Shift><Super>2"];
        move-to-workspace-3 = ["<Shift><Super>3"];
        move-to-workspace-4 = ["<Shift><Super>4"];
        move-to-workspace-5 = ["<Shift><Super>5"];
        move-to-workspace-6 = ["<Shift><Super>6"];
        move-to-workspace-7 = ["<Shift><Super>7"];
        move-to-workspace-8 = ["<Shift><Super>8"];
        move-to-workspace-9 = ["<Shift><Super>9"];
        move-to-workspace-10 = ["<Shift><Super>Tab"];
        move-to-workspace-11 = ["<Shift><Super>grave"];
        toggle-maximized = ["<Shift><Super>f"];
      };

    "org/gnome/settings-daemon/plugins/media-keys" = {
         custom-keybindings = [
           "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
           "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
           "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/"
           "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/"
           "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4/"
           "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom5/"
         ];
         search = ["<Super>space"];
         screensaver = [];
      };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      name = "Kitty";
      command = "kitty";
      binding = "<Super>Return";
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
      name = "Personal Cromium";
      command = "chromium --profile-directory='Profile 2'";
      binding = "<Super>w";
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2" = {
      name = "Work Cromium";
      command = "chromium --profile-directory='Profile 1'";
      binding = "<Shift><Super>w";
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3" = {
      name = "Bookmarks";
      command = "/home/nazarov/dotfiles/scripts/bookmarks-open";
      binding = "<Super>e";
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4" = {
      name = "Copy from Bookmarks";
      command = "/home/nazarov/dotfiles/scripts/bookmarks-copy";
      binding = "<Shift><Super>e";
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom5" = {
      name = "Cliphist";
      command = "/home/nazarov/dotfiles/scripts/clipboard-history";
      binding = "<Shift><Super>v";
    };

    "org/gnome/shell/extensions/workspace-switcher-manager" = {
        popup-visibility = 0;
      };

  };

  home.packages = with pkgs; [
    # ...
    gnome.gnome-tweaks
    gnomeExtensions.forge
    gnomeExtensions.workspace-switcher-manager
    gnome.gnome-terminal

    #gnomeExtensions.clipboard-history
  ];
  
}
