
sudo chsh -s $(which zsh) 
chsh -s $(which zsh) 
cd ~/apps
curl -sS https://starship.rs/install.sh | sh

## Python
curl https://pyenv.run | bash
source ~/.zshrc
pyenv install 3.12.4
pyenv global 3.12.4
curl -sSL https://install.python-poetry.org | python 

## Ruby
# cd ~/apps
# git clone https://github.com/rbenv/rbenv.git ~/.rbenv
# git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
# ~/.rbenv/bin/rbenv install 3.4.2
# ~/.rbenv/bin/rbenv global 3.4.2


## node
curl -fsSL https://fnm.vercel.app/install | bash
source ~/.zshrc
fnm install --lts
fnm use lts/latest
npm i -g pnpm
pnpm setup
source ~/.zshrc
pnpm i -g  typescript @johnnymorganz/stylua-bin tree-sitter neovim @biomejs/biome

## Rust (Cargo)
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh



### Apps
cargo install --locked yazi-fm
cargo install fd-find
cargo install procs
cargo install sheldon
cargo install eza
cargo install bat
source ~/.zshrc

