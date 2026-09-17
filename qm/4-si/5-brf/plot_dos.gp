# Gnuplot script to plot DOS

set terminal wxt size 900,600 font "Times-Roman,16" enhanced

set xrange [-5:5]
set xtics (-4, -2, 0, 2, 4)
set xlabel "E - E_{F} (eV)"

set yrange [0:80]
set ytics (0, 20, 40, 60, 80)
set ylabel "g(E)"

set tics scale 0.75
set border lw 1.5
set grid ytics lc rgb "#cccccc" lw 1 lt 0

set key top left

# Optional: vertical dashed line at E = 0
set arrow from 0, graph 0 to 0, graph 1 nohead lc rgb "black" dt 2 lw 1

# Define style for reuse
plot "DOS_TOTAL_SHIFTED" using 1:2 with lines linecolor "red" linewidth 3 linetype 1 title "Total DOS"

pause -1

