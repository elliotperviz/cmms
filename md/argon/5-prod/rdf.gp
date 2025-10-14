# Set labels and output
set xlabel "r (Angstrom)"
set ylabel "g(r)"
set key left top

# Count blocks dynamically
N_blocks = system("grep -c '^# Timestep' rdf.dat")

# Infinite loop
while (1) {
    do for [i=0:N_blocks-1] {
        plot "rdf.dat" index i using 2:3 with lines lw 2 title sprintf("g(r), step %d", (i+1)*1000)
        pause 0.25  # pause between timesteps in seconds
    }
}

