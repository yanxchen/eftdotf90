import math
import numpy as np
from fractions import Fraction
import random
import subprocess
import sys
import matlab.engine

def dot(x, y, f=lambda x: x):
    """Dot product between x and y.

    If argument f is given, it is a function applied to each coefficient of each
    vector before it is used in computations.

    In particular, f = Fraction allows computing an accurate result using
    rational numbers.
    """
    acc = f(0)
    for i in range(len(x)):
        acc += f(x[i]) * f(y[i])
    return acc


def genDot(n, c):
    """Generate two vectors whose dot product is ill-conditioned
§
    Argu§§§§§§§§§ments:
      n -- vectors size
      c -- target condition number

    Results:
      x, y -- vectors of size n
      d    -- accurate dot product, rounded to nearest
      C    -- actual condition number of the dot product
    """

    # Initialization
    x = [0] * n
    y = [0] * n

    # First half of the vectors:
    #   random numbers within a large exponent range
    n2 = int(n / 2)
    b = math.log(c) / math.log(2)

    e = [random.random() * b/2 for i in range(n2)]
    e[0] = b/2 + 1           # Make sure exponents b/2
    e[n2-1] = 0              # and 0 actually occur
    for i in range(n2):
        x[i] = (2*random.random()-1) * 2**(e[i])
        y[i] = (2*random.random()-1) * 2**(e[i])

    # Second half of the vectors such that
    #   (*) log2( dot (x[1:i], y[1:i]) ) decreases from b/2 to 0
    e = np.linspace(b/2, 0, n-n2)
    for i in range(n-n2):
        # Random x[i]
        cx = (2*random.random()-1) * 2**(e[i])
        x[i+n2] = cx

        # y[i] chosen according to (*)
        cy = (2*random.random()-1) * 2**(e[i])
        y[i+n2] = (cy - float(dot(x, y, Fraction))) / cx

    # Random permutation of x and y
    perm = list(range(n))
    random.shuffle(perm)
    X = [0] * n
    Y = [0] * n
    for i in range(n):
        X[i] = x[perm[i]]
        Y[i] = y[perm[i]]

    # Dot product, rounded to nearest
    d = float(dot(X, Y, Fraction))

    # Actual condition number
    C = 2 * dot(X, Y, abs) / abs(d)

    return [X, Y, d, C]


# Helper functions for error calculation

def split(a):
    factor = 2**27 + 1
    c = factor * a
    x = c - (c - a)
    y = a - x
    return (x, y)


def twoProd(a, b):
    x = a*b
    a1, a2 = split(a)
    b1, b2 = split(b)
    y = a2*b2 - (((x-a1*b1) - a2*b1) - a1*b2)
    return (x, y)


def twoSum(a, b):
    x = a + b
    if abs(b) > abs(a):
        (a, b) = (b, a)
    z = x - a
    y = b - z
    return (x, y)


def dot1(x, y):
    acc = 0
    accErr = 0
    for i in range(len(x)):
        acc, e = twoSum(acc, x[i] * y[i])
        accErr += e
    return acc + accErr


def dot2(x, y):
    acc = 0
    accErr = 0
    for i in range(len(x)):
        p, e = twoProd(x[i], y[i])
        acc += p
        accErr += e
    return acc + accErr


def dot3(x, y):
    acc = 0
    accErr = 0
    for i in range(len(x)):
        p, ep = twoProd(x[i], y[i])
        acc, es = twoSum(acc, p)
        accErr += ep + es
    return acc + accErr


def err(res, ref):
    return min(1, max(1e-16, abs((res-ref))/abs(ref)))


def send(cmd, x, y):
    p = subprocess.Popen(cmd,
                         stdin=subprocess.PIPE,
                         stdout=subprocess.PIPE,
                         text=True)
    p.stdin.write(f"{len(x)}\n")
    for i in range(len(x)):
        p.stdin.write(f"{x[i]:.18e} {y[i]:.18e}\n")
    p.stdin.close()

    return float(p.stdout.read())


def output(f, x):
    out = f"{x:.5e} "
    print(out, end='')
    f.write(out)


def main():
    n = 100
    c1 = 1
    c2 = 1e35
    step = 2

    eng = matlab.engine.start_matlab()
    eng.addpath("/Users/ychen/Documents/neko_notes/dot2-working/fp64")

    try:
        n = int(sys.argv[1])
        c1 = float(sys.argv[2])
        c2 = float(sys.argv[3])
        step = float(sys.argv[4])
    except (IndexError, ValueError):
        pass

    with open("test_d.dat", "w") as f:
        c = c1
        while c < 1e33:
            # (x, y, d, C) = genDot(n, c)
            cond_num = float(c)
            x, y, d, C = eng.GenDot(n, cond_num, nargout=4)
            # convert
            x = np.array(x).flatten()
            y = np.array(y).flatten()
            d = float(d)
            C = float(C)
        
            output(f, C)

            r = dot(x, y)
            output(f, err(r, d))

            for version in ["std", "comp"]:
                r = send(["./test_double", "dot", version], x, y)
                dot_err = err(r, d)
                output(f, dot_err)

            print("\n", end='')
            f.write("\n")

            c *= step

    subprocess.call(["gnuplot", "test_double.gp"])


if __name__ == "__main__":
    main()