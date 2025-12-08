#!/bin/bash
source /opt/miniconda3/etc/profile.d/conda.sh
conda activate phonopy

phonopy --abinit -d disp.conf -c prim.in

# Variable definitions
list=`ls supercell-*.in | grep -oE '[0-9]{3}'`

# Prepare displaced supercell calculations
for i in $list ; do 
mkdir $i; mv supercell-$i.in $i/ ; cp ab_common $i/
cd $i; cat supercell-$i.in ab_common > ab.in ; rm supercell-$i.in ab_common; ln -s ../*.psp8 . ; cd ../
done

# Run abinit
for j in $list ; do cd $j; abinit ab.in | tee out ; cd ../ ; done

# Check calculations
grep -A 1 "Calculation completed" */out
grep "etot is converged" */out

# Extract forces
phonopy -f {001..006}/ab.abo

# Post-process band structure
phonopy --abinit -c prim.in -p band.conf

# Post-process animation and visualise with vsim
phonopy --abinit -c prim.in -p anime_GM.conf
v_sim anime.ascii

exit 0
