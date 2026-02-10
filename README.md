
# My dotfiles 
This dotfiles uses stow to create symlinks. 
```sh
git clone  git@github.com:petr-nazarov/dotfiles.git
```
## Use:
```bash
just sync # syncs the dotfiles
just unsync # unsync dotfiles

```
## Tec stack:
- mise to install required dependencies
- just to run simple commands
- stow to symlinks
## Structure:
- '_common' - the content of this folder will be linked to your home repo. Platform independent configs are stored here.
- '_linux' - the content of this folder will be linked to your home repo. Only configs specific to linux os will be stored here
- '_macos' - the content of this folder will be linked to your home repo. Only configs specific to MacOS os will be stored here
## Gotchas
- Dont forget to install tmux plugins In tmux click `ctrl+a I`







