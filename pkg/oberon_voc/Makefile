.PHONY = all clear

OC = voc

all: main.mod cosines.mod
	@${OC} -s cout.mod vector.mod cosines.mod main.mod -m

clean:
	@rm -f main Cout CosineS Vector *.h *.c *.o *.sym
