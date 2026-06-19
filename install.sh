## This is for a headless setup, likely in a container.

## For desktop envs please follow the jsutfile

rm -f $HOME/.zshrc
stow --no-folding  -t "$HOME" _headless



