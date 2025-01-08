program test_double
    implicit none
    character(len=32) :: arg
  
    call get_command_argument(1, arg)
    if (arg == "dot") then
       call get_command_argument(2, arg)
  
       if (arg == "std") then
          call readDot0()
       end if
  
       if (arg == "comp") then
          call readDot()
       end if
    end if
  
  contains
  
    subroutine readDot0 ()
      use eftdot, only : dp
      implicit none
      integer :: i, n
      real(kind=dp) :: d
      real(kind=dp), allocatable :: x(:), y(:)
  
      read(*,*) n
      allocate (x(N))
      allocate (y(N))
  
      do i = 1,n
         read(*,*) x(i),y(i)
      end do
  
      d = dot0(x, y, n)
      print *, d
    end subroutine readDot0
  
    subroutine readDot ()
      use eftdot
      implicit none
      integer :: i, n
      real(kind=dp) :: d
      real(kind=dp), allocatable :: x(:), y(:)
  
      read(*,*) n
      allocate (x(N))
      allocate (y(N))
  
      do i = 1,n
         read(*,*) x(i),y(i)
      end do
  
      call dot2_d(x, y, n, d)
      print *, d
    end subroutine readDot
  
    function dot0 (x, y, N) result(acc)
      use eftdot, only : dp
      implicit none
      integer :: N, i
      real(kind=dp) :: acc
      real(kind=dp), allocatable :: x(:), y(:)
  
      acc = 0
      do i = 1,n
         acc = acc + x(i) * y(i)
      end do
    end function dot0
end program test_double