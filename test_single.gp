set terminal pdfcairo
set output "test_single.pdf"

set style line 1 lw 1.5 pt 1 ps 0.75 lc rgb '#fdbf6f'
set style line 2 lw 1.5 pt 2 ps 0.75 lc rgb '#a6cee3'
set style line 3 lw 1.5 pt 2 ps 0.75 lc rgb '#1f78b4'

set title "Results quality vs conditioning (single precision)"

set logscale xy
set key bottom right
set xlabel "Dot product condition number"
set ylabel "Relative error"
set format x "10^{%T}"
set format y "10^{%T}"

plot "test_s.dat" using 1:2 w p ls 1 title "Exact", \
     ""         using 1:3 w p ls 2 title "F90, std", \
     ""         using 1:4 w p ls 3 title "F90, dot2"