# Molecular Dynamics

## What is Molecular Dynamics?

[Reference to relevant chapter in lecture notes]

Molecular Dynamics (MD) is a computational simulation method that we will employ to model materials at the resolution where matter is not continuous, but made of a discrete arrangement of atoms. In MD, we study the time evolution of a system of atoms via the dynamical variation of the system state (i.e. positions and momenta of the atoms) by integrating Newton's Equations of motion. The time integration is implemented numerically, such that we solve to obtain the state of the system at discrete *timesteps* in a chosen time window. In practice, the timestep must be small enough to resolve the fastest atomic vibrations (typically on the order of femtoseconds), which limits the total simulated timescales to nanosceconds or microseconds. The simulated system size is typically limited to nanometres, with the number of atoms ranging from thousands to millions. This is far smaller than most experimental samples, and long-wavelength or mesoscale phenomena are therefore not directly accessible in atomistic MD. Thus, we understand both the power and limitation of MD simulations: it provides a detailed atomistic description of materials behaviour, but it is a necessarily small and short-time view of materials behaviour.

Suppose we specify the initial state at time t=0 and integrate - at the end of the integration we will have a deterministic *dynamical trajectory*, which tells us the variation of the system state as a function of time. When we perform an MD simulation, we might be interested in the dynamical variation of a particular observable property of the system, or perhaps its average values over time. Measuring the dynamical variation is simple, in the sense that if we are able to derive the observable property based on the positions and momenta of the particles, we simply perform this calculation at each timestep of the numerical integration and extract the output. Calculating the time average is also easy, we take the average of the dynamical variation of the observable property in time. However, the interpretation of the time average depends on some key factors:
- Whether we want to measure *equilibrium* or *non-equilibrium* observable properties
- The choice of statistical ensemble (effectively, the constraints we impose on the system)

Lets focus first on the measurement of equilibrium properties - we cannot assume that just because we impose the constraints of a particular ensemble, e.g. the microcanonical (NVE) ensemble, that we can automatically extract the associated equilibrium properties of the system. When we setup an MD simulation we face two problems:
1. Choice of initial conditions<br>
Typically, we assign initial particle positions from a crystalline or random arrangement, and initial velocities from a guessed distribution (often Maxwell–Boltzmann at the target temperature). Such a state is not guaranteed to correspond to equilibrium. For example, if atoms start too close together, the system may undergo large potential energy relaxation, converting abruptly into kinetic energy, and the instantaneous kinetic/potential partition will not yet reflect equilibrium fluctuations.
2. Numerical integration and finite precision<br>
In the ideal case, Hamiltonian dynamics ensures that an isolated system conserves the total energy exactly, so in the microcanonical (NVE) ensemble the sum of kinetic and potential energies is constant. In practice, we integrate via a numerical scheme (e.g. velocity Verlet) which only approximates the true dynamics. This introduces small integration errors that can accumulate, leading to a slow drift in total energy. While good integrators keep this drift small, it means that in practice the “constant energy” of NVE is not perfectly realised.

So, if we wish to measure equilibrium properties, we **must** ensure that the system is first suitably equilibrated. This process is known as *equilibration*, wherein the system evolves from the particular initial configuration towards typical configurations of the chosen ensemble. Due to the finite numerical precision of the integration scheme that we mentioned above, we cannot expect to reach a "perfect" equilibrum, but it is sufficient that ensemble observables (e.g. temperature, pressure, total energy) fluctuate around stable mean values within acceptable tolerances.

Once equilibration is finished we can invoke the *ergodic hypothesis*: the time averages along a trajectory for a system in equilibrium, over a sufficiently long time window, can be taken as equivalent to ensemble averages. It is important to remember that the choice of ensemble determines which equilibrium properties are directly accessible. For example, in the NVE ensemble the total energy is fixed and cannot be measured as a fluctuating thermodynamic variable, whereas the temperature is obtained from the kinetic energy. In the NVT ensemble, the temperature is fixed via a thermostat, while energy fluctuates, so one can measure heat capacity from energy fluctuations. Commenting on the choice of ensemble more generally, other ensembles can be realised using different constraints, such as barostats to fix pressure in the NPT ensemble. The practical implementation of an ensemble in MD is analagous to choosing an experimental setup: it dictates which observables can be extracted naturally, and which are constrained; thermostats and barostats act as control mechanisms to reproduce the desired macroscopic condition.

In contrast, in non-equilibrium MD we deliberately drive the system away from equilibrium, for example by applying an external field, imposing a temperature gradient, or shearing the simulation box. In this case, the system does not sample a stationary statistical ensemble, and time averages describe transient or steady-state responses rather than equilibrium properties. While this is an important and active area of research, in these tutorial demonstrations we restrict ourselves to equilibrium MD, and we point the interested reader to [**reference material**] for further reading.

Now, in fully *classical* MD we solve a coupled set of differential equations (N equations for N particles), using interatomic forces derived from a pre-determined classical *force-field* (FF). The FF is an analytical expression for the potential energy of the system, from which the forces follow by differentiation. In practice, the FF is always approximate: it is parameterised for a specific material or class of systems, and its functional form determines the physical fidelity of the model. It may be as simple as a two-body Lennard-Jones potential or as complex as a many-body reactive or machine-learning potential. Further, because evaluating interactions between all particle pairs scales as N<sup>2</sup>, efficient algorithms such as neighbour lists and cutoffs are essential to make simulations tractable. Together, these factors set the limits on achievable system size, simulation time, and accuracy with available computing power.

Another practical consideration in MD is the use of boundary conditions. To mimic bulk materials and avoid artefacts from surfaces, simulations almost always employ periodic boundary conditions, where the simulation cell is replicated in all directions. While this reduces finite-size effects, the system size is still limited by computational resources, and care must be taken when interpreting properties that depend sensitively on fluctuations or long-range interactions.

In summary, we can outline a general workflow for performing MD simulations to measure equilibrium properties of a particular material described as a discrete arrangement of atoms:


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
		
