
{ config, pkgs, ... }:
let
  configContent = ''
config.load_autoconfig(False)

config.bind('<Ctrl-Shift-r>', ':session-load -f _autosave')
config.bind('xt', ':config-cycle tabs.show always switching')
c.tabs.show = "switching"
c.tabs.show_switching_delay = 2000
c.tabs.position = "left"
c.url.searchengines = {
    'DEFAULT':  'https://google.com/search?hl=en&q={}',
    '!a':       'https://www.amazon.com/s?k={}',
}
c.url.start_pages = ["https://google.com"]
  '';
in {
  home.packages = [
    pkgs.qutebrowser
  ];
  home.file = {
     ".qutebrowser/personal/config/config.py".text = configContent;
     ".qutebrowser/work/config/config.py".text = configContent;
  };
}
