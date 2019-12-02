in_ssh_session() {
  if [ -n "$SSH_CLIENT"  ] || [ -n "$SSH_TTY"  ]; then
    return 0
  else
    case $(ps -o comm= -p $PPID) in
      sshd|*/sshd) return 0;;
    esac
  fi
  return 1
}
