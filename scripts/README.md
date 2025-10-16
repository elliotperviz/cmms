# Scripts for post-processing simulation outputs

Generally, when we work with different simulation softwares in the tutorials we try to show you how to directly interface with the code to extract relevant output data, and prepare this data for analysis or visualisation. This is to avoid using the simulation tool as a "black box", in such case we might avoid the log files entirely and just use post-processing tools to generate the outputs we are interested in. Usage in this may create issues:
- if the post-processing tool has a problem parsing the output, then you are stuck
- important messages in the log file may be missed
- you don't understand what the simulation software is *actually* doing, only what it outputs. But, to be confident in our outputs, we must be sure that we understand what goes on in the middle (e.g. integrating Newton's equations of motion, or solving Schrodingers equation) is makes physical sense

Nevertheless, there are times when post-processing the outputs by hand is not practical (too many steps) or simply becomes tedious, if performing a repetitive task over and over again (and you are sure that the output is correct). Thus, we provide a number of post-processing scripts here to make your life easier. 

## Custom scripts

These are scripts written by the us (the authors of the course) for tasks specific to these tutorials.


You may find more information about each code by inspecting the comments in each file respectively.

## External scripts/tools

We acknowledge the use of the following external tools:

[pizza.py](pizza.py) - this is a set of utility scripts, provided when compiling LAMMPS, to provide pre- and post-processing capability for LAMMPS (and other simulation softwares)

[lammps-python-tools](/lammps-python-tools) - this set of scripts is provides specific functionality for post-processing LAMMPS outputs, by leveraging pizza.py library. Similarly to pizza.py, it is provided when compiling the LAMMPS package. 

Depending on whether you (the user) are following these tutorials from within the laboratory, or from home on your own custom installation, you may or may not have access to these files, so we provide a copy of them here. Relevant author credits may be found by inspecting the `README` file, or inspecting the scripts in each directory respectively.

