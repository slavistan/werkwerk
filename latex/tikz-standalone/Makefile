.PHONY: main.pdf all clean

all: main.pdf
	latexmk

incremental:
	find . -type f -not -path "./build" -not -path "./.*" | entr -s "make all"

clean:
	latexmk -CA
	rm -rf build
