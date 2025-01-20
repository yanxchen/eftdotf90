! eftdot.f90
!
! Reference: 
! Ogita, T., Rump, S. M., & Oishi, S. I. (2005). Accurate sum and dot product. 
! SIAM Journal on Scientific Computing, 26(6), 1955-1988.
!
module eftdot
    implicit none

    !> Single precision real numbers, 6 digits, range 10⁻³⁷ to 10³⁷-1; 32 bits
    integer, parameter :: sp = selected_real_kind(6, 37)
    !> Double precision real numbers, 15 digits, range 10⁻³⁰⁷ to 10³⁰⁷-1; 64 bits
    integer, parameter :: dp = selected_real_kind(15, 307)
    !> Quadruple precision real numbers, 33 digits, range 10⁻⁴⁹³¹ to 10⁴⁹³¹-1; 128 bits
    integer, parameter :: qp = selected_real_kind(33, 4931)

    private
    public :: sp, dp, qp, twoSum_s, twoProd_s, dot2_s, twoSum_d, twoProd_d, dot2_d

contains
    !> For double precision
    !> twoSum for single precision
    subroutine twoSum_s(a, b, x, y)
        real(kind=sp), intent(in) :: a, b
        real(kind=sp), intent(out) :: x, y
        real(kind=sp) :: z

        z = 0.0_sp

        x = a + b
        z = x - a
        y = (a - (x - z)) + (b - z)
    end subroutine twoSum_s

    !> split for single precision
    subroutine split_s(a, x, y)
        real(kind=sp), intent(in) :: a
        real(kind=sp), intent(out) :: x, y
        real(kind=sp) :: factor, c

        factor = 4097.0
        c = 0.0_sp

        c = factor * a
        x = c - (c - a)
        y = a - x
    end subroutine split_s

    !> twoProd for single precision
    subroutine twoProd_s(a, b, x, y)
        real(kind=sp), intent(in) :: a, b
        real(kind=sp), intent(out) :: x, y
        real(kind=sp) :: a1, a2, b1, b2

        a1 = 0.0_sp
        a2 = 0.0_sp
        b1 = 0.0_sp
        b2 = 0.0_sp

        x = a * b
        call split_s(a, a1, a2)
        call split_s(b, b1, b2)
        y = a2 * b2 - (((x - a1 * b1) - a2 * b1) - a1 * b2)
    end subroutine twoProd_s

    !> Dot2 for single precision
    subroutine dot2_s(x, y, n, res)
        integer, intent(in) :: n
        real(kind=sp), intent(in) :: x(:), y(:)
        real(kind=sp), intent(out) :: res
        real(kind=sp) :: p, s, h, r, q, tmp
        integer :: i

        p = 0.0_sp
        s = 0.0_sp
        h = 0.0_sp
        r = 0.0_sp
        q = 0.0_sp
        res = 0.0_sp

        call twoProd_s(x(1), y(1), p, s)
        do i = 2, n
            call twoProd_s(x(i), y(i), h, r)
            tmp = p
            call twoSum_s(tmp, h, p, q)
            s = s + (q + r)
        end do
        res = p + s
    end subroutine dot2_s

    !> For double precision
    !> twoSum for double precision
    subroutine twoSum_d(a, b, x, y)
        real(kind=dp), intent(in) :: a, b
        real(kind=dp), intent(out) :: x, y
        real(kind=dp) :: z

        z = 0.0_dp

        x = a + b
        z = x - a
        y = (a - (x - z)) + (b - z)
    end subroutine twoSum_d

    !> split for double precision
    subroutine split_d(a, x, y)
        real(kind=dp), intent(in) :: a
        real(kind=dp), intent(out) :: x, y
        real(kind=dp) :: factor, c

        factor = 134217729.0
        c = 0.0_dp

        c = factor * a
        x = c - (c - a)
        y = a - x
    end subroutine split_d

    !> twoProd for double precision
    subroutine twoProd_d(a, b, x, y)
        real(kind=dp), intent(in) :: a, b
        real(kind=dp), intent(out) :: x, y
        real(kind=dp) :: a1, a2, b1, b2

        a1 = 0.0_dp
        a2 = 0.0_dp
        b1 = 0.0_dp
        b2 = 0.0_dp

        x = a * b
        call split_d(a, a1, a2)
        call split_d(b, b1, b2)
        y = a2 * b2 - (((x - a1 * b1) - a2 * b1) - a1 * b2)
    end subroutine twoProd_d

    !> Dot2 for double precision
    subroutine dot2_d(x, y, n, res)
        integer, intent(in) :: n
        real(kind=dp), intent(in) :: x(:), y(:)
        real(kind=dp), intent(out) :: res
        real(kind=dp) :: p, s, h, r, q, tmp
        integer :: i

        p = 0.0_dp
        s = 0.0_dp
        h = 0.0_dp
        r = 0.0_dp
        q = 0.0_dp
        res = 0.0_dp

        call twoProd_d(x(1), y(1), p, s)
        do i = 2, n
            call twoProd_d(x(i), y(i), h, r)
            tmp = p
            call twoSum_d(tmp, h, p, q)
            s = s + (q + r)
        end do
        res = p + s
    end subroutine dot2_d

end module eftdot
