# EFT Dot Fortran

## Files:
- eftdot.f90: EFT dot source file
- test*.f90: example to call dot2
- test*.py, test*.gp: borrowed from libeft, for automatic testing

## Usage:
```bash
# compile lib and mod
$ make
# run testing and plot for single
$ make test_s
# run testing and plot for double
$ make test_d
```