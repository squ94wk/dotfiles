# taken from oh-my-zsh
# is x grep argument available?
grep-flag-available() {
    echo | grep $1 "" >/dev/null 2>&1
}

GREP_OPTIONS=""

# color grep results
if grep-flag-available --color=auto; then
    GREP_OPTIONS+=" --color=auto"
fi

# ignore VCS folders (if the necessary grep flags are available)
VCS_FOLDERS="{.bzr,CVS,.git,.hg,.svn}"

if grep-flag-available --exclude-dir=.cvs; then
    GREP_OPTIONS+=" --exclude-dir=$VCS_FOLDERS"
elif grep-flag-available --exclude=.cvs; then
    GREP_OPTIONS+=" --exclude=$VCS_FOLDERS"
fi

# clean up
unset VCS_FOLDERS
unfunction grep-flag-available
alias grep="grep $GREP_OPTIONS"

# du
DU_OPTIONS=""
DU_OPTIONS+=" -h"
alias du="du $DU_OPTIONS"

# ls
LS_OPTIONS="--color=always"
alias l="ls -lah $LS_OPTIONS"
alias ll="ls -lh $LS_OPTIONS"
alias la="ls -lAh $LS_OPTIONS"
