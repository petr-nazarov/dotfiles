init:
  pre-commit install
sync-headless:
  rm $HOME/.zshrc
  stow -t "$HOME" _headless
unsync-headless:
  stow -D -t "$HOME" _headless
sync-common-gui:
  #!/usr/bin/env sh
  [ -z "${DISPLAY}${WAYLAND_DISPLAY}" ] && exit 0
  stow -t "$HOME" _common_gui
unsync-common-gui:
  stow -D -t "$HOME" _common_gui

[linux]
sync: sync-headless sync-common-gui link-monitors
  stow -t "$HOME" _linux_gui
[macos]
sync: sync-headless sync-common-gui
  stow -t "$HOME" _mac_gui


[linux]
unsync:
  stow  -D -t "$HOME" _common

[macos]
unsync:
  stow  -D -t "$HOME" _common

link-monitors:
  #!/usr/bin/env sh
  [ -z "${DISPLAY}${WAYLAND_DISPLAY}" ] && exit 0
  case "$(hostname)" in
    home-desktop) cfg="monitors.desktop.conf" ;;
    matebook)     cfg="monitors.laptop.conf" ;;
    *)            exit 0 ;;
  esac
  ln -sf "$HOME/.config/hypr/$cfg" "$HOME/.config/hypr/monitors.conf"
  echo "monitors.conf -> $cfg"

# Run all linters and formatters
lint:
    stylua --check .
    taplo lint --check
    ymllint .

lint-fix:
    stylua  .
    taplo lint
    yamllint .

format:
    stylua .
    taplo fmt
    shfmt -w .
fix:
  just lint-fix
  just format
# Run full automated ci workflow in dagger, usefull for testing ci
ci:
  dagger call lint --source .
  dagger call scan-secrets --source .

