init:
  pre-commit install

[linux]
sync: link-monitors
  stow  -t "$HOME" _common
  stow -t "$HOME" _linux

[linux]
link-monitors:
  #!/usr/bin/env sh
  case "$(hostname)" in
    home-desktop) cfg="monitors.desktop.conf" ;;
    *)            cfg="monitors.laptop.conf" ;;
  esac
  ln -sf "$HOME/.config/hypr/$cfg" "$HOME/.config/hypr/monitors.conf"
  echo "monitors.conf -> $cfg"
[macos]
sync:
  stow  -t "$HOME" _common
  stow -t "$HOME" _mac


[linux]
unsync:
  stow  -D -t "$HOME" _common
  stow  -D -t "$HOME" _linux

[macos]
unsync:
  stow  -D -t "$HOME" _common
  stow -D -t "$HOME" _mac


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

