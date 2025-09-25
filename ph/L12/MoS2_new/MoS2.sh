# Post-processing phonon band structure
phonopy --abinit --tolerance=1e-4 -c lat.in -p band.conf

# Post-processing phonon animation, visualisation with v_sim
phonopy --abinit --tolerance=1e-4 -c lat.in -p anime_GM.conf

