#!/usr/bin/env zsh

# Tags output with a green INFO string.
logln() {
	printf "\033[32m[INFO]\033[0m $@\n"
}

build() {
	logln "Building PDF ... "
	latexmk
	logln " ... done!"
}

clean() {
	latexmk -C
	rm -r ./build
}

case "$1" in
	clean) clean ;;
	*) build ;;
esac
