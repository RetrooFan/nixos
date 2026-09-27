{ pkgs, ... }: {
  environment.interactiveShellInit = ''
# ------------------------------------------------
# ------------------------------------------------

HISTSIZE=10000
HISTFILESIZE=20000
HISTCONTROL=ignoreboth

stty -ixon

# ------------------------------------------------

SESSION_ID=`hexdump -vn4 -e'4/1 "%02x"' /dev/urandom`
echo "# ----- | `date` | START | $SESSION_ID" >> $HISTFILE

PS1_USER=`whoami`
case "$PS1_USER" in
  "root")
    PS1_COLOR='\[\033[01;31m\]';;
  "kristof")
    PS1_COLOR='\[\033[01;32m\]';;
  *)
    PS1_COLOR='\[\033[01;33m\]'
esac

PS1_FORMAT_END='\[\033[00m\]'
PS1_PROMPT_TEXT='\$\$\$\$\$'
PS1_SPACES=`printf "%*s" $(expr 10 - ''${#PS1_USER})`
PS1_1="$PS1_COLOR\u$PS1_FORMAT_END"
PS1_2="\[\033[01;36m\]\h$PS1_FORMAT_END"
PS1_3="$PS1_COLOR$SHLVL$PS1_FORMAT_END"
PS1_4="$$"
PS1_5="\[\033[01;34m\]\w$PS1_FORMAT_END"
PS1_6="------------------------------------------------------------------------------------------------------------------------------------------------------"
PS1_PROMPT="$PS1_COLOR$PS1_PROMPT_TEXT$PS1_FORMAT_END -> "

PS1_INIT=$PS1
empty_lines=0

prompt() {
  printf -v PS1_7 '%.0s\n' $(seq 0 "$empty_lines")
  empty_lines=0

  PS1="| `date` | $PS1_0$PS1_1$PS1_SPACES | $PS1_2 | $PS1_3 | $PS1_4 | $PS1_5 |\n$PS1_6$PS1_7$PS1_PROMPT"
}
PROMPT_COMMAND=prompt

after_exit() {
  sleep 0.1 && echo "# ----- | `date` | END   | $SESSION_ID" >> "$HISTFILE" &
}
trap after_exit EXIT

# ------------------------------------------------
# ------------------------------------------------
  '';
}
