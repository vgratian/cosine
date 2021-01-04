
# requires variables:
# myterm - UI framework (qt, tkcanvas, wxt, x11, xlib, xterm, png, svg, pdf)
# benchmark - name or number of benchmark
# file1 - file with cputime data
# file2 - file with walltime data
# file3 - file with maxrss data

set datafile columnheaders

set terminal myterm size 1280,720
set rmargin 5
set grid
stats file1 using 1 name 'x' nooutput
set xtics x_max/4
set format x '%.0s*10^%S'; set xtics add ('0' 0)

set multiplot layout 1,3 title "Cosine Similarity Benchmark ".benchmark font ",14" scale 1,1
set key noenhanced
set key inside left
set title "CPU time [s]"
plot for [col=2:*] file1 using 1:col w lp t columnheader

unset key
set title "Avg walltime per calc [s]"
plot for [col=2:*] file2 using 1:col w lp t columnheader

unset key
set format y '%.0s*10^%S'; set ytics add ('0' 0)
set title "Max RSS [kb]"
plot for [col=2:*] file3 using 1:col w lp t columnheader

