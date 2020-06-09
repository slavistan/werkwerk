#!/usr/bin/env sh

usage() {
  printf \
"Compiler script. Usage:

\t(1) Compile markdown to beamer pdf.

\t\033[1m$0 \033[1;3m[OPTIONS]...\033[0m

\t\t\033[1;3m-w | --watch\033[0m     - recompile when source files change
\t\t\033[1;3m-c | --codebraid\033[0m - use codebraid
\t\t\033[1;3m-v | --verbose\033[0m   - print additional information


\t(2) Clear cache and remove temporaries.

\t\033[1m$0 clean\033[0m


\t(3) Show usage.

\t\033[1m$0 help\033[0m
\t\033[1m$0 --help\033[0m
\t\033[1m$0 -h\033[0m
"
}

compile() {
  if [ $CODEBRAID ]; then
    pre="codebraid"
    post="--overwrite"
  fi
  $pre pandoc "$INFILE" --pdf-engine=xelatex -t beamer -o "$OUTFILE" $post 2>&1
}

[ ! "$INFILE" ] && INFILE="slides.md"
[ ! "$OUTFILE" ] && OUTFILE="slides.pdf"
[ "$1" = "--codebraid" ] && CODEBRAID=1 && shift

case "$1" in
  -h|--help|help)
    usage
    ;;
  watch)
    echo "$INFILE\n$0" | CODEBRAID=$CODEBRAID entr -cr ./compile.sh
    ;;
  clean)
    rm -rf "$OUTFILE" "_codebraid"
    ;;
  *)
    timestamp="[$(date '+%H:%M:%S')]:"
    printf "\033[1m$timestamp Compiling"
    [ $CODEBRAID ] && printf " (w/ codebraid)"
    printf " ... "
    tstart=$(date '+%S')
    if output=$(compile); then
      printf "done in $(expr $(date '+%S') - $tstart)s! Output: '\033[3m$OUTFILE\033[0m'\n"
    else
      err=1
      printf "error after $(expr $(date '+%S') - $t)s!"
    fi
    [ "$output" ] && printf "$timestamp Produced the following output:\n\033[0m$output"
    printf "\033[0m\n"
    if [ "$err" ]; then exit 1; fi
    ;;
esac
