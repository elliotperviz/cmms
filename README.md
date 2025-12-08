# Computational Methods for Materials Science
Here you will find lecture and tutorial material for the course **Computational Methods for Materials Science**, taught at the Faculty of Electrical Engineering, Czech Technical University in Prague.

<!--"Some words of an introduction to the course here"-->

Written and maintained by<br>
- Assoc. Prof. Antonio Cammarata (cammaant@fel.cvut.cz)<br>
- MSc. Elliot Perviz (perviell@fel.cvut.cz)<br>

## Installation (software and tutorial material)

### 0. Let's get started
In the laboratory sessions, the machines are prepared to have all relevant software pre-installed. As such, the necessary preparation steps are minimal.

It is important to be aware that we use machines with a **Linux operating system** installed. Moreover, we will almost exclusively work inside the **Linux terminal**, both for installation and to carry out the various tutorials in the laboratory.

Why?
- The majority of the software that we use does *not* have a graphical interface.
- Whilst to the new user the terminal may seem daunting, working directly in such a command line interface (CLI) allows us to directly interface with the simulation codes to perform post-processing and analysis.
- Over the duration of the course, you will learn both how to use the simulation software, and the manipulation of input and output data through the guided tutorials that we have prepared.

The aim of this course is not to teach users how to use the Linux terminal. Nevertheless, we have prepared a brief [cheat sheet](linux_cheatsheet.md) for common commands that we will employ regularly, or that are helpful to know for learning Linux.

### 1. Download the tutorial files
First, clone this github repository to download the tutorial files. In the Linux terminal copy the following command in the location where you would like to download the files (note: the files download into a single folder, you don't need to make one yourself):
```bash
git clone https://github.com/elliotperviz/cmms.git
cd cmms/
```

You should see the following files/folders, e.g.
```bash
perviell@postel cmms$ ls
README.md  exam  linux_cheatsheet.md  md  ph  qm  scripts
```

### 2. Compile scripts for post-processing and analysis
The majority of the time, we will be directly using the terminal to process inputs/outputs manually. The aim is to avoid treating the files and the simulation sofware as a "black box", instead we try to *understand* the meaning of the things we write in the inputs and what is reported in the outputs.

However, in some cases additional post-processing or analysis is required that is not practical to do by hand. For this reason, we provide a few scripts that you should first compile. Enter (or copy) the following commands into your terminal (assuming you are inside the "cmms" folder):
```bash
cd scripts
chmod +x compile.sh
./compile.sh
source ~/.bashrc
```

To understand the purpose of the different scripts, more context is provided in the README file in the [scripts](scripts/) folder. Moreover, as we progress through the tutorials you will likely find some of these scripts in use, in such cases the proper syntax is explained.

### 3. Additional information

For your reference, we provide a list of the relevant simulation packages and links to their documentation:
- LAMMPS (Large-scale Atomic/Molecular Massively Parallel Simulator) - https://docs.lammps.org/Manual.html
- Abinit - https://docs.abinit.org/
- Phonopy - https://phonopy.github.io/phonopy/

As well as structure and trajectory visualisation tools that we utilise extensively:
- VMD - https://www.ks.uiuc.edu/Research/vmd/
- OVITO - https://www.ovito.org/docs/current/
- VESTA - https://jp-minerals.org/vesta/en/
- v_sim - https://l_sim.gitlab.io/v_sim/

Also, tools for post-processing simulation outputs:
- Pizza.py - https://lammps.github.io/pizza/doc/Manual.html

Then, to plot the data after post-processing we use:
- Gnuplot - http://www.gnuplot.info/
- xmgrace - https://plasma-gate.weizmann.ac.il/Grace/

Finally, other miscellaneous tools
- atomsk - https://atomsk.univ-lille.fr/tutorials.php

For installation on your home computer, please see the above links, where you can navigate to find invididual installation guides.

## Tutorial Outline

### Molecular Dynamics

Navigate to the [md](md/) folder for a discussion and introduction to the Molecular Dynamics (MD) technique, and follow the examples which demonstrate the calculation of equilibrium properties using the LAMMPS software package:
1) [Lattice constant of cubic diamond Silicon](md/silicon)
2) [Diffusion coefficient and radial distribution function of Argon gas](md/argon)

Separate to the calculation of equilibrium properties, we also provide a tutorial to introduce the Nudged Elastic Band (NEB) method:
- [Vacancy migration in cubic diamond Silicon](md/neb)

### Quantum Mechanics

1) [H<sub>2</sub> molecule: electronic properties](qm/1-h2)
2) [H atom: electronic orbitals](qm/2-h)
3) [H<sub>2</sub>O molecule: importance of geometry and the exchange correlation functional](qm/3-h2o)
4) [Diamond Si: geometry optimisation, band structure, convergence studies](qm/4-si)
5) [Carbon: TBC](5-c)

### Phonons

1) [Phonon band structure of the isolated H<sub>2</sub>O molecule](ph/1-h2o)
2) [Phonon band structure of crystalline bilayer MoS<sub>2</sub>](ph/2-mos2)
