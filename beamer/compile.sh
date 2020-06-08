#!/usr/bin/env sh

usage() {
  printf \
"Usage:
  $0 [--codebraid]
    One-shot compile. Optionally, enable compilation with codebraid.

  $0 [--codebraid] watch
    Recompile when source files change. Optionally, enable compilation with
    codebraid.

  $0 clean
    Remove output and temporary files.

  $0 help | -h | --help
    Show usage.
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
[ "$1" = "--codebraid" ] CODEBRAID=1 && shift

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
