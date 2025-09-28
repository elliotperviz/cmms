# Tutorial

In this tutorial, we focus on using Molecular Dynamics (MD) to measure observable properties at equilibrium.

We will demonstrate how to use the Large-scale Atomic/Molecular Massively Parallel Simulator (**LAMMPS**) software to calculate
- a) the diffusion coefficient, and
- b) the pair correlation function

of Argon gas at density  1.374 g cm<sup>-3</sup> in equilibrium at 94.4 K.

In this investigation we aim to replicate the results of the paper *Correlations in the Motion of Atoms in Liquid Argon* by A. Rahman, published in 1964. <br>
[DOI: https://doi.org/10.1103/PhysRev.136.A405]

For further resources, we recommend that you check out the LAMMPS manual. It is a complete and well-written resource that you should use to check the proper usage of commands, and how to setup up different types of simulations, and also to find relevant references. It should also be the first port of call if you want to setup your own LAMMPS simulations in the future. See the following link: <br>
[https://docs.lammps.org]

## Outline
1. [1-init](1-init/) Initialisation & potential minimisation - no time, no kinetic energy, no Newton's equations
2. [2-heat](2-heat/) Heating - initialise velocities at 10K, heat to 500K
3. [3-cool](3-cool/) Cooling - cool system to 94.4K
4. [4-equ](4-equ/) Equilibration - prepare system for measurement at 94.4K
5. [5-prod](5-prod/) Production - calculate diffusion coefficient (D) and pair correlation function

## Simulation procedure
### 0. Initialisation - initialise randomised positions and velocities

**Objectives**


--- OPTIONAL ---<br>
- Initialise Ag gas at 1.374 g cm^{-3} at 10K and equilibrate<br>
[hint: plot total energy as a function of time, fit straight line]<br>

### 1. Initialisation & potential minimisation

Here, we employ the conjugate gradient algorithm to minimise the potential. 

Change into [1-init](1-init/):
```bash
cd 1-init/
```

View the contents of the directory and inspect the input file:
```bash
ls
vim mini.in
```
Inside vim, use PAGEUP and PAGEDOWN keys to navigate.

Note the line containing the keyword "minimize". Check the syntax of this command:
https://docs.lammps.org/minimize.html

Do we specify minimisation based on the *energy* or the *forces*? The point of this step is to minimise the potential, why would a stopping criterion based on the forces be useful?

Type ":q" (without the "") to return to the terminal.

Now, run LAMMPS:
```bash
lmp -in mini.in
```

Inspect the *standard output* (the lines printed to the terminal after running the above command). What information is printed?

Inspect the output files written by LAMMPS, e.g.:
```bash
perviell@postel 1-init$ ls
log.lammps  mini_final.data  mini.in  mini.lammpstrj
```

- log.lammps - a copy saved to file (with some more detail) of the standard output
- mini_final.data - final positions and velocities of each atom
- mini.lammpstrj - the lammps "trajectory" file, positions and velocities as a function potential minimisation step

Note that, in "mini.lammpstrj", during a minimisation we have positions and velocities as as function of potential minimisation step, during integration of Newton's equation's of motion this file gives positions and velocities as a function of **time**.

**Objectives**
- Check optimised system is physically reasonable with VMD <br>
  [hint: load output trajectory file into VMD]
- Ensure maximum forces are less than chosen tolerance (verification of force field) <br>
	[hint: check standard out or log.lammps for information about the forces]
           
### 2. Heating - initialise velocities at 10K, heat to 500K
	Objectives:
	I)   Check integration scheme and choice of timestep are appropriate
	     [hint: integrate Newton's equations in NVE and plot total energy as a
	     function of time, fit straight line]
	II)  Apply Berendsen thermostat (note: part of NVE ensemble) and heat to 500K 
	     during NVE integration. Plot T vs t, and check T reaches 500K.
	--- OPTIONAL ---
	III) Apply Berendsen barostat during NVE integration
	IV)  Integrate Newton's equations and heat to 5000K in NVT ensemble
	     [hint: you must first disable NVE integration]

### 3. Cooling - cool system to 94.4 K
	Objectives:
	I)   Check T reaches 94.4 K
	     [hint: Plot T vs t]
	--- OPTIONAL ---
	II)  Integration Newton's equations and cool to 94.4K in NVT ensemble
	
### 4. Equilibration - prepare system for measurement at 94.4 K
	Objectives:
	I)   Check system is in equilibrium
	     [hint: Plot T vs t, fit straight line]
	--- OPTIONAL ---
	II)  Calculate moving average and standard deviation, plot average or stddev
	     as a function of time, should observe reduction in stddev as t increases
	     [hint: using moving_avg_stddev.c code (must be compiled first)]
	     
### 5. Production - calculate diffusion coefficient (D) and pair correlation function 
	Objectives:
	I)   Calculate D
	     [hint: plot mean square displacement vs time, D is proportional to
	     gradient. Recall definition of D from lecture notes]
	II)  Calculate pair correlation function [NOT WORKING]

### 6. Post-processing and analysis
Observe trajectories:
---> Use VMD

Extract data:
---> Use awk/sed and grep, or vim visual mode

Plotting/fitting:
---> Use gnuplot
	     [hint: Compile rdf.f90 and run on output...this script is not working right now]
		
