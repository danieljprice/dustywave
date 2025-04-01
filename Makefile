##-------------------------------------------------------------------##
##     Makefile for compiling the dustywave example program          ##
##     Daniel Price and Guillaume Laibe                              ##
##     daniel.price@monash.edu, guillaume.laibe@monash.edu           ##
##-------------------------------------------------------------------##

F90C =  gfortran
F90FLAGS =  -O3 -Wall

# define the implicit rule to make a .o file from a .f90 file
%.o : %.f90
	$(F90C) -c $(F90FLAGS) $< -o $@

SRC= cubicsolve.f90 dustywaves.f90 prompting.f90 example-dustywaves.f90
OBJ=$(SRC:.f90=.o)

dustywave: $(OBJ)
	$(F90C) $(F90FLAGS) -o $@ $(OBJ)
	@echo
	@echo "compiled successfully: run ./dustywave to generate solutions"
	@echo

clean:
	rm *.o *.mod dustywave

cleanall:
	rm *.o *.mod dustywave dustywave*.out
