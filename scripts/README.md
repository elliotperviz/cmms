# Scripts for post-processing simulation outputs

In these tutorials, we generally demonstrate how to directly interface with each simulation package to extract the relevant output data and prepare it for analysis or visualisation. This approach helps avoid treating the simulation tool as a *black box*. Relying solely on post-processing utilities can lead to several issues:
- If the post-processing tool fails to parse the output correctly, you may be unable to proceed.
- Important warnings or messages in the log files might be overlooked.
- You may not fully understand what the simulation software is actually doing - only what it outputs. To trust our results, we must be confident that the underlying physical processes (e.g. integration of Newton's equations of motion, or solution of the Schrödinger equation) make sense.

Nevertheless, there are situations where manually processing outputs is impractical - for example, when a workflow involves many repetitive steps or large datasets. In such cases, once you are confident that the simulation outputs are correct, it is reasonable to automate the anlaysis. For this reason, we provide a set of post-processing scripts to simplify common tasks.

## Custom scripts

These are scripts written by the us (the authors of the course) for tasks specific to these tutorials.

- `compile.sh` : Bash script that compiles the relevant utility scripts provided in this directory, and updates "~/.bashrc" to permanently modify `$PATH`.
- `movavg.c` : C program to calculate the moving average and standard deviation of timeseries data.
- `rdf_pp.sh` : Bash script to post-process LAMMPS radial distribution function (RDF) timeseries data into a format suitable for plotting with `gnuplot`

Legacy fortran scripts:
- `ave.f90`
- `rdf.f90`

For further details about each code, refer to the comments within the individual files.

## External scripts/tools

We also acknowledge the use of the following external tools:

[pizza.py](pizza.py) - this is a set of utility scripts, provided when compiling LAMMPS, to provide pre- and post-processing capability for LAMMPS (and other simulation softwares)

[lammps-python-tools](/lammps-python-tools) - this set of scripts is provides specific functionality for post-processing LAMMPS outputs, by leveraging pizza.py library. Similarly to pizza.py, it is provided when compiling the LAMMPS package. 

Depending on whether you (the user) are following these tutorials from within the laboratory, or from home on your own custom installation, you may or may not have access to these tools. To ensure consistency, we provide copies of them here. A

Author credits and additional information may be found by in the corresponding "README" files or within the scripts themselves.
