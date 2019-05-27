# qsetup
This repo contains my personal .dotfiles and shell scripts made to quickly get my machine up and running after a fresh install. Currently, the setup script:
- sets up dotfiles like .vimrc and .gitconfig;
- installs utilities that don't come natively with macOS, e.g. `wget` and `git-lfs`; and
- automates installations of a bunch of graphical apps via `brew cask` and `mas-cli`, e.g. iTerm and Xcode

## To-do
- [ ] Install `fisher` and then `fish-pure` with it
- [ ] Maintain `sudo` over the duration of the scripts
- [ ] Redirect output to logfiles
- [ ] Add summary at the end of setup

## References
- https://github.com/MarioCatuogno/Clean-macOS
- https://github.com/mathiasbynens/dotfiles
