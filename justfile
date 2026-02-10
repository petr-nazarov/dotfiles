[linux]
sync:
  stow  -t "$HOME" _common
  stow -t "$HOME" _linux
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
    @just lint-lua
    @just lint-toml
    @just lint-json-yaml
    @just lint-generic

lint-lua:
    stylua --check .

lint-toml:
    taplo fmt --check

lint-json-yaml:
    prettier --check "**/*.{json,yml,yaml}"

lint-generic:
  ec # Automatically fix what can be fixed
format:
    stylua .
    taplo fmt
    shfmt -w .
    prettier --write "**/*.{json,yml,yaml}"
fix:
  just format
  git add .
  just lint
  git add .
