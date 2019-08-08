# qsetup
This repo contains my personal .dotfiles and shell scripts made to quickly get my machine up and running after a fresh install. Currently, the setup script:
- sets up dotfiles like .vimrc and .gitconfig;
- installs utilities that don't come natively with macOS, e.g. `wget` and `git-lfs`; and
- automates installations of a bunch of graphical apps via `brew cask` and `mas-cli`, e.g. iTerm and Xcode

## How to Run
```
bash setup.sh [-s|--showcase]

-s, --showcase
    Simulates running the whole setup process, without actually carrying out the operations
    of each helper script. Directory to store log files is still created, although the log
    files themselves are not.
```

## References
- https://github.com/MarioCatuogno/Clean-macOS
- https://github.com/mathiasbynens/dotfiles
- https://gist.github.com/cowboy/3118588
