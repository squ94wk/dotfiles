autoload -Uz compinit
for dump in ~/.zcompdump(N.mh+24); do
    compinit
done
compinit -C

fpath=("${ZSH}/autocomplete" $fpath)

for file in "${ZSH}"/autocomplete/*.zsh; do
    source "${file}"
done

