#!/bin/bash

gcc movavg.c -o movavg -lm
gfortran -o ave ave.f90
gfortran -o rdf rdf.f90
chmod +x rdf_pp.sh

# Find script path
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Add script path to PATH
echo 'export PATH=$PATH:'"$SCRIPT_DIR" >> ~/.bashrc

# Add lammps-tools folder to PATH and set LAMMPS_PYTHON_TOOLS
echo 'export PATH=$PATH:'"$SCRIPT_DIR/lammps-python-tools" >> ~/.bashrc
echo 'export LAMMPS_PYTHON_TOOLS='"$SCRIPT_DIR/lammps-python-tools/pizza" >> ~/.bashrc

exit 0
