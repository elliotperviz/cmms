#!/bin/bash

# -----------------------------------------------
# Script: rdf_pp.sh
# Purpose: Convert LAMMPS RDF output into gnuplot-friendly format
#          - Inserts blank lines between timestep blocks
#          - Converts timestep lines to comments
# Usage: ./rdf_pp.sh input_file output_file
# -----------------------------------------------

# Check arguments
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 input_file"
    exit 1
fi

INPUT_FILE="$1"

# Check if input file exists
if [ ! -f "$INPUT_FILE" ]; then
    echo "Error: Input file '$INPUT_FILE' not found."
    exit 1
fi

if [ "$INPUT_FILE" = "rdf.dat" ] ; then
	echo "Input file cannot be named 'rdf.dat'"
fi

# Process the RDF file
awk '
BEGIN {
    print "# Preprocessed RDF file for gnuplot"
}

{
    # Detect timestep line: exactly 2 fields, both numeric
    if (NF == 2 && $1 ~ /^[0-9]+$/ && $2 ~ /^[0-9]+$/) {
        print ""                   # insert blank line to separate blocks
	print ""		   # insert second blank line
        print "# Timestep " $1     # comment the timestep
    } else {
        print                      # print RDF data line as-is
    }
}
' "$INPUT_FILE" > rdf.dat

echo "Preprocessing complete. Output written to 'rdf.dat'."

exit 0
