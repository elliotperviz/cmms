# Molecular Dynamics Tutorial

In this tutorial, we will demonstrate how to use the Large-scale Atomic/Molecular Massively Parallel Simulator (**LAMMPS**) to calculate
- a) the diffusion coefficient, and
- b) the pair correlation function

of Argon at 94.4 K and 1.374 g cm<sup>-3</sup>

The setup of this investigation is based on the paper *Correlations in the Motion of Atoms in Liquid Argon* by A. Rahman, published in 1964.
[DOI: https://doi.org/10.1103/PhysRev.136.A405]

Outline:
Step 1 - minimising the potential (no time, no Newton's equations)
Steps 2-5 - integrate Newton's equations (time, potential, kinetic energy...)

Observe trajectories:
---> Use VMD

Extract data:
---> Use awk/sed and grep, or vim visual mode

Plotting/fitting:
---> Use gnuplot

## Simulation procedure:
### 0) Initialisation - initialise randomised positions and velocities
	Objectives: [the output is pre-done as this step is long]
	--- OPTIONAL ---
	I)   Initialise Ag gas at 1.374 g cm^{-3} at 10K and equilibrate
	     [hint: plot total energy as a function of time, fit straight line]

### 1) Minimisation - minimise potential energy
	Objectives:
	I)   Check optimised system is physically reasonable with VMD
	     [hint: use output trajectory file ending .lammpstrj]
        II)  Ensure maximum forces are less than chosen tolerance (verification of force field part)
             [hint: check standard out or log.lammps]
           
### 2) Heating - initialise velocities at 10K, heat to 500K
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

### 3) Cooling - cool system to 94.4 K (our target temperature)
	Objectives:
	I)   Check T reaches 94.4 K
	     [hint: Plot T vs t]
	--- OPTIONAL ---
	II)  Integration Newton's equations and cool to 94.4K in NVT ensemble
	
### 4) Equilibration - prepare system for measurement at 94.4 K
	Objectives:
	I)   Check system is in equilibrium
	     [hint: Plot T vs t, fit straight line]
	--- OPTIONAL ---
	II)  Calculate moving average and standard deviation, plot average or stddev
	     as a function of time, should observe reduction in stddev as t increases
	     [hint: using moving_avg_stddev.c code (must be compiled first)]
	     
### 5) Production - calculate diffusion coefficient (D) and pair correlation function 
	Objectives:
	I)   Calculate D
	     [hint: plot mean square displacement vs time, D is proportional to
	     gradient. Recall definition of D from lecture notes]
	II)  Calculate pair correlation function [NOT WORKING]
	     [hint: Compile rdf.f90 and run on output...this script is not working right now]
		
