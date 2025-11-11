# Optimized grep flag detection
# Cache grep capabilities instead of testing each time
GREP_OPTIONS=""

# Modern grep supports these flags, so just use them directly
# This avoids slow flag detection at startup
GREP_OPTIONS+=" --color=auto"
GREP_OPTIONS+=" --exclude-dir={.bzr,CVS,.git,.hg,.svn}"
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
