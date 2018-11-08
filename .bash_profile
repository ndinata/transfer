
# find the git branch you are currently in
parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

# customise terminal color schemes
export PS1="\u@\h \[\033[00m\]\w\[\033[33m\]\$(parse_git_branch)\[\033[00m\] $ "
export CLICOLOR=1
export LSCOLORS=Exfxcxdxbxegedabagacad

if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi
