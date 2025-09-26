# Molecular Dynamics

## What is Molecular Dynamics?

[Reference to relevant chapter in lecture notes]

Molecular Dynamics (MD) is a computational simulation method that models the time evolution of the *state* of a system of particles (i.e. their positions and momenta) via Newton's Equations of motion. The time integration is implemented numerically, such that we solve to obtain the state of the system at discrete *timesteps* in our chosen time window. Suppose we specify the initial configuration (positions and momenta at time t=0) - at the end of the integration we have a deterministic *dynamical trajectory*, which tells us the variation of the system state as a function of time.

When we perform a MD simulation, generally we might be interested in the dynamical variation of a particular observable property of the system, or perhaps its average values over time. Measuring the dynamical variation is simple, in the sense that if we are able to derive the observable property based on the positions and momenta of the particles, we simply perform this calculation at each timestep of the numerical integration and extract the output. Calculating the time average is also easy, we take the average of the dynamical variation of the observable property in time. However, the interpretation of this time average depends on a some key factors:
- Whether we make the measurement in *equilibrium* or *non-equilibrium* conditions
- The choice of statistical ensemble (effectively, constraints which we impose on the system)
If we wish to measure equilibrium properties, we **must** ensure the system is suitably equilibrated over the duration of the measurement. In practice, this means that the variation of properties of the system that we constrain through the choice of the statistical ensemble should be constant

Now, in *classical* MD we solve a coupled set of differential equations (N equations for N particles), using interatomic forces derived from a pre-determined *force-field* (FF) at each timestep. This force field is an analytical function that tells us the force on any particle (via the gradient of the potential) in the system due to interactions with all others (in principle). It is very computationally difficult to treat the exact interatomic forces (in fact, this would require a different level of description including quantum mechanical degrees of freedom of the electrons), so in practice the FF is an *approximate* function. Accordingly, there is a tradeoff between computational load and the accuracy of the force field. 

# Tutorial

In this tutorial, we will demonstrate how to use the Large-scale Atomic/Molecular Massively Parallel Simulator (**LAMMPS**) software to calculate
- a) the diffusion coefficient, and
- b) the pair correlation function

of Argon at 94.4 K and 1.374 g cm<sup>-3</sup>.

The setup of this investigation is based on the paper *Correlations in the Motion of Atoms in Liquid Argon* by A. Rahman, published in 1964. <br>
[DOI: https://doi.org/10.1103/PhysRev.136.A405]

For further resources, for example if you want to setup your own LAMMPS simulation, we recommend you to check out the LAMMPS manual. It is a complete and well-written resource that you should use to check the proper usage of commands, and how to setup up different types of simulations, and also to find relevant references. See the following link: <br>
[https://docs.lammps.org]

## Outline
How to setup a LAMMPS simulation to measure equilibrium properties of a system...

Step 1 - minimising the potential (no time, no Newton's equations) <br>
Steps 2-5 - integrate Newton's equations, obtain dynamical trajectory (varying potential, kinetic energy etc. in time)

## Simulation procedure:
### 0) Initialisation - initialise randomised positions and velocities

**Note**: this initialisation step is pre-calculated, since the simulation time is long. You may use the output provided, or run the calculation yourself.

**Objectives**


--- OPTIONAL ---<br>
- Initialise Ag gas at 1.374 g cm^{-3} at 10K and equilibrate<br>
[hint: plot total energy as a function of time, fit straight line]<br>

### 1) Minimisation - minimise potential energy

**Objectives**

- I) Check optimised system is physically reasonable with VMD <br>
	[hint: use output trajectory file ending .lammpstrj] <br>
- II) Ensure maximum forces are less than chosen tolerance (verification of force field part) <br>
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

### 3) Cooling - cool system to 94.4 K
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

## Post-processing and analysis
Observe trajectories:
---> Use VMD

Extract data:
---> Use awk/sed and grep, or vim visual mode

Plotting/fitting:
---> Use gnuplot
	     [hint: Compile rdf.f90 and run on output...this script is not working right now]
		
