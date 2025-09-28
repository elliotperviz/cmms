# Tutorial

In this tutorial, we focus on using Molecular Dynamics (MD) to measure observable properties at equilibrium.

We will demonstrate how to use the Large-scale Atomic/Molecular Massively Parallel Simulator (**LAMMPS**) software to calculate
- a) the diffusion coefficient, and
- b) the pair correlation function

of Argon gas at density  1.374 g cm<sup>-3</sup> in equilibrium at 94.4 K.

In this investigation we aim to replicate the results of the paper *Correlations in the Motion of Atoms in Liquid Argon* by A. Rahman, published in 1964. <br>
[DOI: https://doi.org/10.1103/PhysRev.136.A405]

If a first time user, it is recommended that you have the LAMMPS manual open on a separate page during this tutorial. It is a complete and well-written resource that you should use to check description and correct syntax of commands. It is good to get into this habit, as even for experienced users it is impossible to remember the meaning of every command and their associated syntax. See the following link: <br>
[https://docs.lammps.org]
If you enter the name of a command into the search bar, you will usually be able to find a dedicated help page.

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

Check the section labelled "initial conf" and related keywords against the LAMMPS manual. What system have we setup?

Aside from initialising the atomic positions, we also want to minimise the potential. For this purpose, we employ the conjugate gradient algorithm. Note the section "minimization", and in particular the keywords "min_style" and "minimize". Check the syntax of these commands in the LAMMPS manual.

Do we specify minimisation based on the *energy* or the *forces*? Although the goal is to reduce the potential energy, why might a stopping criterion based on forces be more physically meaningful?

<details>
<summary>Click here for the answer</summary>
The forces are obtained from the gradient of the potential energy and vanish at a stationary point. A force-based stopping criterion ensures that the system is in mechanical equilibrium. By contrast, an energy-based criterion only checks for small changes in energy and provides no information about the local shape of the energy surface.
</details>

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
Open with vim and check their contents:
```bash
vim <filename>
```
- log.lammps - a copy saved to file (with some more detail) of the standard output
- mini_final.data - final positions and velocities of each atom
- mini.lammpstrj - the lammps "trajectory" file, positions and velocities as a function potential minimisation step

Note that, in "mini.lammpstrj", during a minimisation we have positions and velocities as a function of potential minimisation step, during integration of Newton's equation's of motion this file gives positions and velocities as a function of **time**.

**Questions**
- Are the initialized positions physically reasonable, based on the system we wanted to setup? <br>
  [hint: Check by visualizing the minimisation with the output trajectory file e.g. with VMD]
- Was the stopping criterion on the minimisation correctly achieved? <br>
  [hint: check the standard output or log.lammps for information about the energy or forces]
           
### 2. Heating - initialise velocities at 10K, heat to 500K

Copy the final configuration (**init_final.data**) into [2-heat](2-heat/) and change directory.

e.g. from [1-init](1-init/) to [2-heat](2-heat/):
```bash
cp init_final.data ../2-heat/
cd ../2-heat/
```

If you inspect the contents of the directory, it should contain:
```bash
perviell@postel 2-heat$ ls
heat.in  init_final.data
```

Use vim to inspect the new input file
```bash
vim heat.in
```
(remember, :q to quit)

What are the differences between this input and the input from the last step (initialisation)? In particular, see sections related to "initialize velocities" and "MD run":

```bash
# initialize velocities
velocity        all create 10.0 111 mom yes rot yes
########################

### MD run #############
timestep        10.0

fix             integ all nve # integrate equation of motion

fix             thermos all temp/berendsen 10.0 500.0 1000.0 # Berendsen thermostat

#fix            baros all press/berendsen iso 1.0 1.0 10000.0 # Berendsen barostat

#fix            integ all nvt temp 10.0 500.0 1000.0 # integrate equation of motion + Nose-Hoover thermostat

run             10000
########################
```

In this input, we initialize the velocities at 10K, then tell LAMMPS to perform molecular dynamics in the NVE ensemble. We also impose a Berendsen thermostat to heat the system from 10K to 500K.

Is it correct to impose a thermostat in the NVE ensemble? Check the description of this thermostat in the LAMMPS manual.

**Objectives**

- **Check the choice of timestep is appropriate** <br>
  Remove the Berendsen thermostat, by "commenting" the line in `heat.in`.
  ```bash
  #fix             thermos all temp/berendsen 10.0 500.0 1000.0 # Berendsen thermostat
  ```
  When opening the file in vim, if you hit "i" (without the ""), you enter insert mode, and can edit the file. Press "esc" to exit edit mode, and type ":w" to save changes (and :q to quit).<br>
  Alternatively, you may edit the file via a graphical text editor, but in principle all actions can be performed within the terminal, which you will find much more convenient to your work flow once you get used to the terminal.<br>
  Now, run LAMMPS (only NVE for system at 10K):
  ```bash
  lmp -in heat.in
  ```
  Check the standard output, did the simulation finish correctly?

  You should see an "ERROR" message, related to lost atoms. This means that the timestep is too large to properly capture the dynamics. We should therefore reduce the size of the timestep by editing `heat.in` and setting
  ```bash
  ### MD run #############
  timestep        1.0
  ```

  And run LAMMPS again:
  ```bash
  lmp -in heat.in
  ```

	Objectives:
	I)   Check integration scheme and choice of timestep are appropriate
	     [hint: integrate Newton's equations in NVE and plot total energy as a
	     function of time, fit straight line]
	II)  Apply Berendsen thermostat (note: part of NVE ensemble) and heat to 500K 
	     during NVE integration. Plot T vs t, and check T reaches 500K.
	--- OPTIONAL ---
	III) Apply Berendsen barostat during NVE integration
	IV)  Integrate Newton's equations and heat to 500K in NVT ensemble
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
		
