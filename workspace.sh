#!/usr/bin/env zsh

set -e

case "$1" in
  beamer)
    [ "$2" = "--path" ] && outdir="$3" || outdir=$(mktemp -d)
    mkdir -p "$outdir"
    cp -r ${0:A:h}/beamer/* "$outdir"
    cd "$outdir"
    st zsh -c 'nvim slides.md; zsh -i' &
    st zsh -c 'make watch; zsh -i' &
    make all && (zathura slides.pdf &)
    ;;
esac

# TODO(feat): show dmenu with selections
# TODO(feat): Rename project to werkwerk
# TODO(feat): Install templates to $XDG_DATA_HOME/werkwerk
# TODO(feat): Use envvars for terminal and editor
