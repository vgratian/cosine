# Usage:
# make				# build binary
# make clean		# remove binary

.PHONY: all clean

CC = gcc
LIBS = -lm

all: main.c
	@${CC} main.c -o main ${LIBS}

clean:
	@rm -f main

