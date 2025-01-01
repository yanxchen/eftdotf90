# Fortran Compiler
FC = gfortran

FFLAGS = -Wall -g -fcheck=all -O2 -std=f2008

# Library name
LIB = libeftdot.a

OBJS = eftdot.o

all: $(LIB)

test_s: test_single
	python ./test_single.py

test_d: test_double
	python3 ./test_double.py

# static library
$(LIB): eftdot.o
	ar rcs $@ $^

eftdot.o: eftdot.f90
	$(FC) $(FFLAGS) -c $<

test_single: test_single.f90 eftdot.mod libeftdot.a
	$(FC) $(FFLAGS) $< -L. -leftdot -o $@

test_double: test_double.f90 eftdot.mod libeftdot.a
	$(FC) $(FFLAGS) $< -L. -leftdot -o $@

clean:
	rm -f *.o *.mod $(LIB) test_single test_double *.dat *.pdf

.PHONY: all clean