#!/bin/bash
source /opt/miniconda3/etc/profile.d/conda.sh
conda activate phonopy

# Extract forces
phonopy --abinit --tolerance1e-8 --fz superc/ab.abo {001..004}/ab.abo

# Post-process band structure
phonopy --abinit --tolerance=1e-8 -c prim.in -p band.conf

#or
#$ phonopy --abinit -c prim.in -p -s band.conf
#$ phonopy-bandplot --gnuplot band.yaml > band.gp
#and
#$ gnuplot> plot "band.gp" u 1:2 w l

# Post-process animation and visualise with vsim
phonopy --abinit --tolerance=1e-8 -c prim.in -p anime_GM.conf
v_sim anime.ascii

exit 0

