init:
  pre-commit install
sync-headless:
  rm $HOME/.zshrc
  stow --no-folding -t "$HOME" _headless
unsync-headless:
  stow -D -t "$HOME" _headless
sync-claude:
  stow --no-folding -t "$HOME" _claude
unsync-claude:
  stow -D -t "$HOME" _claude

sync-common-gui:
  #!/usr/bin/env sh
  [ -z "${DISPLAY}${WAYLAND_DISPLAY}" ] && exit 0
  stow -t "$HOME" _common_gui
unsync-common-gui:
  stow -D -t "$HOME" _common_gui

[linux]
sync: sync-headless sync-claude sync-common-gui link-monitors
  stow -t "$HOME" _linux_gui
[macos]
sync: sync-headless sync-claude sync-common-gui
  stow -t "$HOME" _mac_gui


[linux]
unsync: unsync-headless unsync-claude unsync-common-gui 
  stow -D -t "$HOME" _linux_gui
[macos]
unsync: unsync-headless unsync-claude unsync-common-gui 
  stow -D -t "$HOME" _mac_gui

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

