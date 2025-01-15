# Install 
```bash
sh <(curl -L https://nixos.org/nix/install)
nix run nix-darwin -- switch --flake  ~/dotfiles/nix-darwin
```
# Rebuild
```
nix run nix-darwin -- switch --flake  ~/dotfiles/nix-darwin
```

# Yabai 
## disable sistem integrity protection
## run to edit yabai scripting adition 
```bash 
echo "$(whoami) ALL=(root) NOPASSWD: sha256:$(shasum -a 256 $(which yabai) | cut -d " " -f 1) $(which yabai) --load-sa" | sudo tee /private/etc/sudoers.d/yabai
sudo visudo /etc/sudoers
## Make sure to have:
Defaults	env_keep += "TERMINFO"
yabai --load-sa
```


# After initial install 
```bash
rbenv install 3.4.1
rbenv global 3.4.1
fnm install --lts
fnm use lts/latest
npm i -g yarn eslint prettier typescript @johnnymorganz/stylua-bin tree-sitter neovim
pyenv install 3.12.4
pyenv global 3.12.4
POETRY_VERSION=2.0.1 curl -sSL https://install.python-poetry.org | python 



```
