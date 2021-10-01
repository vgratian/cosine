# Usage:
# make		 - build fortran program
# make clean - clean-up binaries

.PHONY: all modules clean

FC = gfortran

all: modules 
	@${FC} -o main args.o cosine.o vector.o main.o
	@rm -f *.o
	@rm -f *.mod

modules:
	@${FC} -c args.f95 vector.f95 cosine.f95 main.f95

clean:
	@rm -f *.o
	@rm -f *.mod
	@rm -f main
