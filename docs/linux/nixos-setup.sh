

# After the build of nixos run:

mkdir -p ~/.apps
git clone https://github.com/mattmc3/antidote.git ~/apps/zsh-antidote
fnm install --lts
nm use default
npm i -g yarn eslint prettier typescript @johnnymorganz/stylua-bin tree-sitter neovim @biomejs/biome 

