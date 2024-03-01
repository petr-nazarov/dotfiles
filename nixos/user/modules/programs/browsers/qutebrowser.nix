
{ config, pkgs, ... }:
let
  configContent = ''
config.load_autoconfig(False)

config.bind('<Ctrl-Shift-r>', ':session-load -f _autosave')
config.bind('xt', ':config-cycle tabs.show always switching')
c.url.default_page = "https://google.com/search"
c.url.searchengines = {
    'DEFAULT':  'https://google.com/search?hl=en&q={}',
    'aw'     : 'https://wiki.archlinux.org/index.php?search={}&title=Special%3ASearch&wprov=acrw1',
    'nw'     : 'https://nixos.wiki/index.php?search={}&go=Go',
    'yt'     : 'https://www.youtube.com/results?search_query={}',
    'gd'     : 'https://drive.google.com/drive/search?q={}',
}
c.fonts.default_size = '14pt'
c.url.start_pages = ["https://google.com"]



config.set('content.cookies.accept', 'no-3rdparty', 'chrome-devtools://*')
config.set('content.cookies.accept', 'no-3rdparty', 'devtools://*')

config.set('content.headers.user_agent', 'Mozilla/5.0 ({os_info}; rv:90.0) Gecko/20100101 Firefox/90.0', 'https://accounts.google.com/*')
config.set('content.headers.user_agent', 'Mozilla/5.0 ({os_info}) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99 Safari/537.36', 'https://*.slack.com/*')

config.set('content.images', True, 'chrome-devtools://*')
config.set('content.images', True, 'devtools://*')

config.set('content.javascript.enabled', True, 'chrome-devtools://*')
config.set('content.javascript.enabled', True, 'devtools://*')
config.set('content.javascript.enabled', True, 'chrome://*/*')
config.set('content.javascript.enabled', True, 'qute://*/*')

c.tabs.favicons.scale = 2.0
c.tabs.show_switching_delay = 2000
c.tabs.show = "switching"
c.tabs.last_close = 'close'
c.tabs.position = 'left'
c.tabs.width = '5%'
c.window.transparent = True
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
