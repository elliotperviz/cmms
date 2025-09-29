#!/bin/bash

gcc movavg.c -o movavg -lm
gfortran -o ave ave.f90
gfortran -o rdf rdf.f90
chmod +x rdf_pp.sh

echo 'export PATH=$PATH:'"$(pwd)" >> ~/.bashrc

exit 0
