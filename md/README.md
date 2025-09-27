# Molecular Dynamics

The discussion here is separated into different sections, where we discuss:
- What is molecular dynamics, and some key practical considerations
- The core molecular dynamics loop
- A general workflow for equilibrium measurements

We demonstrate the use of molecular dynamics with an example, which may be found in the [example](/C01_02) folder.

## What is Molecular Dynamics?

<details>
<summary>Click here to expand</summary>
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

Once equilibration is reached, time averages of observable properties that we calculate on the equilibrium trajectory, over a sufficiently long time window, can be taken as equivalent to ensemble averages (*the ergodic hypothesis*). This phase is the "production" stage of an equilibrium MD calculation, where we extract ensemble average values of desired observables via the time average at equilibrium. It is important to remember that the choice of ensemble determines which equilibrium properties are directly accessible. For example, in the NVE ensemble the total energy is fixed and cannot be measured as a fluctuating thermodynamic variable, whereas the temperature is obtained from the kinetic energy. In the NVT ensemble, the temperature is fixed via a thermostat, while energy fluctuates, so one can measure heat capacity from energy fluctuations. Commenting on the choice of ensemble more generally, other ensembles can be realised using different constraints, such as barostats to fix pressure in the NPT ensemble. The practical implementation of an ensemble in MD is analagous to choosing an experimental setup: it dictates which observables can be extracted naturally, and which are constrained; thermostats and barostats act as control mechanisms to reproduce the desired macroscopic condition.

In contrast, in non-equilibrium MD we deliberately drive the system away from equilibrium, for example by applying an external field, imposing a temperature gradient, or shearing the simulation box. In this case, the system does not sample a stationary statistical ensemble, and time averages describe transient or steady-state responses rather than equilibrium properties. While this is an important and active area of research, in these tutorial demonstrations we restrict ourselves to equilibrium MD, and we point the interested reader to [**reference material**] for further reading.

Now, in fully *classical* MD we solve a coupled set of differential equations (N equations for N particles), using interatomic forces derived from a pre-determined classical *force-field* (FF). The FF is an analytical expression for the potential energy of the system, from which the forces follow by differentiation. In practice, the FF is always approximate: it is parameterised for a specific material or class of systems, and its functional form determines the physical fidelity of the model. It may be as simple as a two-body Lennard-Jones potential or as complex as a many-body reactive or machine-learning potential. Further, because evaluating interactions between all particle pairs scales as N<sup>2</sup>, efficient algorithms such as neighbour lists and cutoffs are essential to make simulations tractable. Together, these factors set the limits on achievable system size, simulation time, and accuracy with available computing power.

Another practical consideration in MD is the use of boundary conditions. To mimic bulk materials and avoid artefacts from surfaces, simulations almost always employ periodic boundary conditions, where the simulation cell is replicated in all directions. While this reduces finite-size effects, the system size is still limited by computational resources, and care must be taken when interpreting properties that depend sensitively on fluctuations or long-range interactions.

</details>

## The core loop

It is useful to summarise explicitly what is the core loop implemented in MD, which is central to all the dynamics which we investigate using this simulation technique.

0. Read initial parameters (timestep, number of timesteps, simulation box, boundary conditions)
1. Read initial positions and velocities
2. Compute forces on each atom via classical force field (FF)
3. Integrate Newton's equation of motion for the state (positions and momenta) at the next timestep in chosen statistical ensemble (e.g. NVE, NVT, NPT)
4. Compute and print thermodynamic averages of desired quantities (this can be done every timestep, or every few timesteps)
5. Repeat from step 2, until total number of timesteps completed

Reminder: to derive an observable property we must be able to express it as a function of the positions and momenta of atoms in the system.

## General workflow for equilibrium measurements

1. **Initialisation and potential energy minimisation**
  - Define simulation box, boundary conditions
  - Place atoms at their initial positions and minimise the potential energy
  - IMPORTANT: No time integration, no kinetic energy, no temperature!!!
  - We check if the starting positions are reasonable, and if the FF provides a sensible description of interatomic forces
  - Note that this is typically a *local* minimisation, so the quality of the starting configuration matters
2. **Preparation: realising target conditions**
  - Choose statistical ensemble (NVE, NVT, NPT etc.) and impose any required constraints
  - Assign initial velocities either explicitly or by sampling from the Maxwell-Boltzmann distribution at the desired initial temperature<br>
  - Thermalisation / barostatting ramp<br>
  If necessary (e.g. for NVT or NPT simulations), integrate Newton's Equations of motion to gradually bring the system to the target temperature and/or pressure by applying a thermostat and/or barostat.
  
**Note**: It is good practice *not* to immediately initialise the system directly at the final target conditions, as this may not correspond to a physically reasonable state. Even if the potential energy has been minimised, introduction of velocities adds extra degrees of freedom that can lead to significant energy fluctuations.
  
For example, if equilibrating at a given temperature in the NVT ensemble, we might heat the system from 0K to a temperature *above* the target, then cool down to the target temperature. Overshooting the temperature reduces dependence on the initial configuration by giving the system enough energy to escape local minima, while subsequent cooling allows the system to relax into a lower-energy state that is more representative of equilibrium. This procedure mimics experimental thermal cycling.

3. **Equilibrate at target conditions**
  - Integrate Newton's Equations of Motion at the target conditions, without imposing further ramps
  - Allow the system to stabilise; during this stage, fluctuatations of thermodynamic quantities should gradually reduce as the system approaches equilibrium
  - Equilibrium is reached once fluctuations are within a given desired tolerance
  - In practice: check for equilibration by monitoring time series variation of quantities such as temperature, pressure, total energy, or volume (in NPT)

4. **Production**
  - After equilibrium is achieved, continue the simulation under the same conditions to collect trajectory data
  - Compute time averages of observable quantities along the equilibrium trajectory
  - For sufficiently long simulations, time averages become equivalent to ensemble averages (ergodicity)
  - In practice: Ensure that the sampling frequency and total trajectory length are sufficient to obtain statistically meaningful, decorrelated data

5. **Post-processing and analysis**
  - Perform statistical analysis of the collected data (e.g. averages, fluctuations, autocorrelation functions)
  - Derive physical observables of interest such as structural (e.g. RDFs), thermodynamic (e.g. pressure, specific heat) or dynamic (e.g. diffusion coefficient) properties
