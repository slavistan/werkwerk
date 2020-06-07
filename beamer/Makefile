SRC=slides.md
PARAMS=--pdf-engine=xelatex -t beamer
OUT=slides.pdf

all: ${SRC}
	pandoc ${SRC} ${PARAMS} -o ${OUT}

watch:
	echo ${SRC} | entr -c pandoc ${SRC} ${PARAMS} -o ${OUT}

clean:
	rm -f ${OUT}

.PHONY: clean watch
