SRC=slides.md
PARAMS=--pdf-engine=xelatex -t beamer -o
OUT=slides.pdf

all: ${SRC}
	pandoc ${SRC} ${PARAMS} ${OUT}

watch:
	echo ${SRC} | entr -c pandoc ${SRC} ${PARAMS} ${OUT}

clean:
	rm -f ${OUT}

.PHONY: clean watch
