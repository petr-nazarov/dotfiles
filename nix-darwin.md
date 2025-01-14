# Install 
```bash
sh <(curl -L https://nixos.org/nix/install)
nix run nix-darwin -- switch --flake  ~/dotfiles/.config/nix-darwin
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
