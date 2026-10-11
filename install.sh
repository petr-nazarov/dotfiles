## This is for a headless setup, likely in a container.

## For desktop envs please follow the jsutfile

rm -f $HOME/.zshrc
stow --restow --no-folding -t "$HOME" _headless



