style() {
  local text=$1
  shift

  local code r g b

  while [[ $# -gt 0 ]]; do
    case "$1" in
      color)
        code=$2
        r=$((16#${code:1:2}))
        g=$((16#${code:3:2}))
        b=$((16#${code:5:2}))
        text=$'%{\033[38;2;'${r}';'${g}';'${b}'m%}'${text}$'%{\033[39m%}'
        shift 2
        ;;
      bold)
        text=$'%{\033[1m%}'${text}$'%{\033[22m%}'
        shift
        ;;
      *)
        shift
        ;;
    esac
  done

  print -r -- "$text"
}
