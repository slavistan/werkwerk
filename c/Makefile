.PHONY=

all: main.c
	gcc -o main main.c

run: all
	./main

.PHONY: watch
watch:
	echo main.c | entr -c make run
