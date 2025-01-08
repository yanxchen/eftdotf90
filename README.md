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

## Non-installation usage:
Codes in `eftdot.f90` can be directly copied and used anywhere. An example to call dot2 for calculating dot product in single precision while emulating double precision:
```Fortran
    integer, parameter :: n = 3
    real(kind=sp) :: x(n), y(n), result
    
    x = [1.0_sp, 2.0_sp, 3.0_sp]
    y = [4.0_sp, 5.0_sp, 6.0_sp]
    
    ! Calculate dot product using dot2_s
    call dot2_s(x, y, n, result)
```
