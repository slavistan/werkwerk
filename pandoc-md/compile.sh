#!/usr/bin/env zsh

TAIL=${0}

usage() {
  printf \
"Compiler script. Usage:

\t(1) Compile markdown.

\t\033[1m${TAIL} compile \033[1;3m[OPTIONS]...\033[0m

\t\t\033[1;3m-b | --codebraid\033[0m - use codebraid
\t\t\033[1;3m-v | --verbose\033[0m   - print additional information

\t\tShort options can be collated, e.g. \033[1;3m-bv\033[0m.


\t(2) Compile markdown. Recompile when files change.

\t\033[1m${TAIL} compile \033[1;3m[OPTIONS]...\033[0m

\t\t\033[1;3m-l | --list-watched\033[0m - show watchlist and exit
\t\t\033[1;3m-b | --codebraid\033[0m    - use codebraid
\t\t\033[1;3m-v | --verbose\033[0m      - print additional information

\t\tShort options can be collated, e.g. \033[1;3m-bv\033[0m.


\t(3) Clear cache and remove temporaries.

\t\033[1m${TAIL} clean\033[0m


\t(4) Show usage.

\t\033[1m${TAIL} help\033[0m
\t\033[1m${TAIL} --help\033[0m
\t\033[1m${TAIL} -h\033[0m
"
}

compile() {
  if [ $CODEBRAID = 1 ]; then
    pre="codebraid"
    post="--overwrite"
  fi
  if [ $VERBOSE = 0 ]; then
    export PYTHONWARNINGS=ignore
  fi
 $pre pandoc "$INFILE" --pdf-engine=xelatex -t beamer -o "$OUTFILE" $post 2>&1
}

cleanup() {
  # TODO(fix): Why does zsh's built-in kill abort after an unsuccessful kill attempt?
  #   It looks as if only the first kill command is executed if there is no spinner. Why?
  #   Also, this leads to an infinite trap-loop :( Built-ins are stupid.
  echo "cleanup ..." > /dev/pts/7
  echo "kill spinner" > /dev/pts/7
  kill "$SPIN_PID" > /dev/null 2>&1
  echo "kill watcher" > /dev/pts/7
  pkill -P $WATCH_PID > /dev/null 2>&1 # kill watcher kids
  kill "$WATCH_PID" > /dev/null 2>&1 # kill watcher (entr ..)
  echo "... done" > /dev/pts/7
}

togglespinner() {
  [ "$SPIN" = "1" ] && SPIN=0 || SPIN=1

  if [ "$SPIN" = "1" ]; then
    (
    chars='-/|\'
    while :; do
      for ii in $(seq 1 4); do
        printf -- "$chars" | cut -b "$ii" | tr -d '\n'
        sleep "0.1s"
        printf "\010"
      done
    done
    ) &
    SPIN_PID=$!
  else
    kill $SPIN_PID
    printf "\010"
  fi
}

parseargs() {
  for opt in "$@"; do
    [ "$opt" = "--codebraid" ] && opt=-b
    [ "$opt" = "--verbose" ] && opt=-v
    [ "$opt" = "--list-watched" ] && opt=-l
    printf -- "$opt" | grep -qE '^-.*c.*$' && CODEBRAID=1
    printf -- "$opt" | grep -qE '^-.*v.*$' && VERBOSE=1
    printf -- "$opt" | grep -qE '^-.*l.*$' && LISTWATCHED=1
  done 
}

disable kill # see above todo

[ ! "$INFILE" ] && INFILE="markdown.md"
[ ! "$OUTFILE" ] && OUTFILE="output.pdf"
[ ! "$WATCHLIST" ] && WATCHLIST="$INFILE\n${0:t}"
[ ! "$COUNTER" ] && COUNTER=0

# Flags
[ ! $VERBOSE ] && VERBOSE=0
[ ! $CODEBRAID ] && CODEBRAID=0
[ ! $LISTWATCHED ] && LISTWATCHED=0

trap 'cleanup; exit' 0 1 2 6 15

case "$1" in
  -h|--help|help)
    usage
    ;;
  clean)
    rm -rf "$OUTFILE" "_codebraid" "tex2pdf.-"*
    ;;
  compile)
    parseargs $@
    compile
    ;;
  setup)
    [ $(echo "Yes\nNo/Cancel" | dmenu -p "Compile w/ codebraid?") = "Yes" ] && flag="-c"
    st zsh -c 'nvim markdown.md; zsh -i' &
    echo | groff -T pdf > output.pdf
    zathura --fork output.pdf
    st zsh -c "./compile.sh $flag -w; zsh -i" &
    ;;
  watch)
    parseargs $@
    if [ $LISTWATCHED = 1 ]; then
      printf "$WATCHLIST\n"
      exit
    fi
    (echo "$INFILE\n$0" | COUNTER=$COUNTER CODEBRAID=$CODEBRAID VERBOSE=$VERBOSE entr -r ./compile.sh _compile) &
    WATCH_PID=$!
    echo "WATCHERPID = $WATCH_PID" > /dev/pts/7
    COUNTER=$(expr $COUNTER "+" 1)
    while :; do
      echo "waiting for keypress ..." > /dev/pts/7
      read -sk 1
      case $REPLY in
        q) exit;;
        v) # toggle verbosity
          cleanup # kill everything
          [ $VERBOSE = 1 ] && VERBOSE=0 || VERBOSE=1
          COUNTER=$COUNTER CODEBRAID=$CODEBRAID VERBOSE=$VERBOSE exec $0 watch
          ;;
        b)
          cleanup # kill everything
          [ $CODEBRAID = 1 ] && CODEBRAID=0 || CODEBRAID=1
          COUNTER=$COUNTER CODEBRAID=$CODEBRAID VERBOSE=$VERBOSE exec $0 watch
          ;;
        c) # cleanup cwd
          cleanup
          $0 clean
          COUNTER=$COUNTER CODEBRAID=$CODEBRAID VERBOSE=$VERBOSE exec $0 watch
          ;;
        " ")
          cleanup
          COUNTER=$COUNTER CODEBRAID=$CODEBRAID VERBOSE=$VERBOSE exec $0 watch
          echo "spaced" > /dev/pts/7
          ;;
      esac
      echo "key = $REPLY" > /dev/pts/7
    done
    echo "left loop" > /dev/pts/7
    ;;
  _compile)
    clear
    printf "\033[1mBuild #$COUNTER ["
    [ $VERBOSE = 1 ] && printf "✓" || printf "✘"
    printf " \033[4mv\033[0;1merbose, "
    [ $CODEBRAID = 1 ] && printf "✓" || printf "✘"
    printf " code\033[4mb\033[0;1mraid"
    printf "]. \033[0mHotkeys:\n"
    printf " q     - Quit\n"
    printf " c     - Clean working directory\n"
    printf " SPACE - Trigger compilation\n"
    printf "... "
    togglespinner
    if output=$(compile); then
      togglespinner
      printf "\033[1mSuccess \033[1;32m✓\033[0;1m File: '\033[3m$OUTFILE\033[0m'\n"
    else
      err=1
      togglespinner
      printf "\033[1mFailed \033[1;31m✘\033[0;1m "
    fi
    if [ "$output" ]; then
      printf "Produced the following ouput:\n\033[0m"
      printf "$output"
    fi
    printf "\033[0m"
    if [ "$err" ]; then exit 1; fi
    ;;
  --)
    shift
    exec $0 $@
    ;;
  *)
    for opt in "$@"; do
      [ "$opt" = "--watch" ] && opt=-w
      [ "$opt" = "--codebraid" ] && opt=-b
      [ "$opt" = "--verbose" ] && opt=-v
      printf -- "$opt" | grep -qE '^-.*c.*$' && CODEBRAID=1
      printf -- "$opt" | grep -qE '^-.*v.*$' && VERBOSE=1
      printf -- "$opt" | grep -qE '^-.*w.*$' && WATCH=1
    done
    if [ "$WATCH" ]; then
      CODEBRAID=$CODEBRAID VERBOSE=$VERBOSE exec $0 __watch
    else
      CODEBRAID=$CODEBRAID VERBOSE=$VERBOSE exec $0 _compile
    fi
    ;;
esac
