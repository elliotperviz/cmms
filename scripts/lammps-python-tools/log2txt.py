#!/usr/bin/python3

# Script:  log2txt.py
# Purpose: extract thermo info from LAMMPS log file
#          create a text file of numbers in columns, suitable for plotting
# Syntax:  log2txt.py [options] log.lammps data.txt X Y ...
#          log.lammps = LAMMPS log file
#          data.txt = text file to create
#          X Y ... = columns to include (optional), X,Y are thermo keywords
#                    if no columns listed, all columns are included
# Author:  Steve Plimpton (Sandia), sjplimp at gmail.com

from __future__ import print_function

import sys
import os
import argparse

path = os.environ["LAMMPS_PYTHON_TOOLS"]
sys.path.insert(1, path)
from log import log

# set up arg parser
parser = argparse.ArgumentParser()

parser.add_argument(
    '-n',
    action='store_true',
    help='save column names as the header of the file'
)

parser.add_argument(
    '-b',
    '--blocks',
    help='thermo blocks to output, e.g. 2 or 2,3; default = all blocks'
)

parser.add_argument(
    'lammpslog',
    help='name of the lammps log file'
)

parser.add_argument(
    'outname',
    help='name of the file to be written'
)

parser.add_argument(
    'cols',
    nargs='*',
    help='any number of column names, optional'
)

args = parser.parse_args()

logfile = args.lammpslog
datafile = args.outname
columns = args.cols
writenames = args.n

# Parse block selection
blocks = None

if args.blocks is not None:
    try:
        blocks = [int(x) for x in args.blocks.split(",")]

        if len(blocks) == 0:
            raise ValueError

        if any(x < 1 for x in blocks):
            raise ValueError

        if len(set(blocks)) != len(blocks):
            raise ValueError

    except ValueError:
        parser.error(
            "-b/--blocks must contain positive block numbers, "
            "e.g. -b 2 or -b 2,3"
        )

lg = log(logfile, blocks=blocks)

print("selected %d log entries" % lg.nlen)

if columns == []:
    lg.write(datafile, writenames)
else:
    lg.write(datafile, writenames, *columns)
