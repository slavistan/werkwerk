#!/usr/bin/env sh

usage() {
 echo "TODO(feat): usage"
}

compile() {
  # TODO(fix):
  #   The build script is very suspicious. Explicitly using xelatex breaks
  #   some text in tikz drawings. Investigate.
  mkdir -p "$BUILDDIR"
  latexmk \
    -pdflatex="xelatex -interaction nonstopmode %O %S" \
    -dvi- -ps- \
    -auxdir="$BUILDDIR" \
    -outdir="$BUILDDIR" \
    -jobname="tikz" \
    "$TEXSRC"
}

TEXSRC="main.tex"
OUTFILENAME="tikz.pdf"
BUILDDIR=build
OUTFILEPATH="$BUILDDIR/$OUTFILENAME"

case "$1" in
  -h|--help|help)
    usage
    ;;
  clean)
    rm -r "$BUILDDIR"
    ;;
  compile)
    compile
    ;;
  watch)
    echo "$TEXSRC\n$0" | entr -rc $0 compile
    ;;
  workspace)
    # TODO(fix): Open nvim within a zsh session. Can't CTRL-z into the shell otherwise.
    st zsh -c 'nvim '"$TEXSRC"'; zsh -i' &
    mkdir -p "$BUILDDIR"
    echo | groff -T pdf > "$OUTFILEPATH"
    zathura --fork "$OUTFILEPATH"
    st zsh -c "$0 watch; zsh -i" &
    ;;
esac
