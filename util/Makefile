.PHONY: all clean

CC = gcc

all: measure.c, randvect.c
	@${CC} measure.c -o measure
	@${CC} randvect.c -o randvect

clean:
	@rm -f measure randvect
