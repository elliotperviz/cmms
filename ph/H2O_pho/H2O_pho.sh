#!/bin/bash

phonopy --abinit -d disp.conf -c ab.in

list="001 002 003 004 005 006"
# Modify ab_common to:
# -> add pseudos line;
# -> remove typat line;
# -> fix syntax error (prtwfk -> prtwf)
#
# Prepare files
for i in $list ; do mkdir $i; mv supercell-$i.in $i/ ; cp ab_common $i/ ; cd $i; cat supercell-$i.in ab_common > ab.in ; rm supercell-$i.in ab_common; ln -s ../*.psp8 . ; cd ../ ; done

# Run abinit
for j in $list ; do cd $j; abinit ab.in | tee out ; cd ../ ; done

# Check calculations
grep -A 1 "Calculation completed" */out
grep "etot is converged" */out

# Extract forces
phonopy -f {001..006}/ab.abo

# Post-process band structure
phonopy --abinit -c ab.in -p band.conf

# Post-process animation and visualise with vsim
phonopy --abinit -c ab.in -p anime_GM.conf
v_sim anime.ascii

exit 0
