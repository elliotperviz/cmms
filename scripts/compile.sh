#!/bin/bash

gcc movavg.c -o movavg -lm
gfortran -o ave ave.f90
gfortran -o rdf rdf.f90
chmod +x rdf_pp.sh

# Find script path
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Lines to add
LINE1="export PATH=\$PATH:$SCRIPT_DIR"
LINE2="export PATH=\$PATH:$SCRIPT_DIR/lammps-python-tools"
LINE3="export LAMMPS_PYTHON_TOOLS=$SCRIPT_DIR/pizza"

# Function to add a line to ~/.bashrc only if it doesn't already exist
add_to_bashrc() {
    local line="$1"
    local file="$HOME/.bashrc"
    # Check if line already exists (literal match)
    if ! grep -Fxq "$line" "$file"; then
        echo "$line" >> "$file"
        echo "Added: $line"
    else
        echo "Already present: $line"
    fi
}

# Apply function to all lines
add_to_bashrc "$LINE1"
add_to_bashrc "$LINE2"
add_to_bashrc "$LINE3"

exit 0
