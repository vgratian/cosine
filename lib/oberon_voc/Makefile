.PHONY = all clear

OC = voc

all: main.mod cosines.mod
	@${OC} -s vector.mod cosines.mod main.mod -m

clean:
	@rm -f main CosineS Vector *.h *.c *.o *.sym
