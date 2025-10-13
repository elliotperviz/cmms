# Tutorial 1

Introduction here

## Equilibrium lattice constant of diamond-Si at 300K

**Goal**

Set up and run a simple LAMMPS simulation to measure the equilibrium lattice constant at 300K.

**Outline**
1. [1-init](1-init/) Initialisation & potential minimisation - no time, no kinetic energy, no Newton's equations
2. [2-equ](2-equ/) Equilibrate the system at 300K and measure the equilibrium lattice constant.

## Simulation procedure

### 1. Initialisation & potential minimisation

- Change into [1-init](1-init/):
```bash
cd 1-init/
```

- View the contents of the directory:
```bash
perviell@postel 1-init$ ls
BPOSCAR init.in POSCAR Si.lmp
```

Our starting point is the **cubic diamond-Si primitive cell**. This is the minimum size unit, containing two atoms, that we can use to simulate bulk crystalline cubic diamond-Si via periodic boundary conditions (PBCs). The definition of the primitive cell system (lattice parameters, atomic positions) is given in the "POSCAR" file. 

 - Inspect "POSCAR" with `vim`/`less`/`cat`
 - Visualize the structure (open the file) in `vesta`.

A "POSCAR" file is one possible format in which we define the crystal structures as input to simulation codes. In particular, "POSCAR" files are used for the Vienna ab inito simulation package `vasp`. The primary purpose of this tool is to solve the Schrodinger equation, which is *not* the focus of this tutorial. However, the "POSCAR" file is convenient and portable, and is one of the most common formats in which you will see crystal structures defined in online databases (due to the widespread use of `vasp`).

It is important to be aware that, even if we are technically simulating the bulk system via periodic boundary conditions, explicitly considering only the primitive (or conventional) cell is not always enough to measure bulk equilibrium properties.

**Why?**
<details>
<summary>Click for the answer</summary>
Periodic boundaries remove surface effects by replicating the simulation cell infinitely in space.
This ensures that every atom has the correct crystalline environment at short range, and that forces at the boundary are continuous.

Thus, for purely static properties (e.g. cohesive energy, equilibrium lattice constant, elastic constants, phonon dispersion at Γ), a single conventional cell under PBCs can already represent the infinite crystal adequately.

But dynamic and collective phenomena depend on correlations and wavelengths that can extend beyond one unit cell — and PBCs alone cannot simulate wavelengths longer than the box length. Moreover, with only a handful of atoms, statistical fluctuations in extensive properties are large. Thus, we choose a larger system size, more representative of bulk. 

In practice, the "correct" system size that can be used to obtain measurements of bulk properties is obtained via a convergence study, where we increase the system size and check how ensemble average quantities change. Once these quantities are ~ constant within a reasonable tolerance, we say that the system is *converged*.

Summary: 

When a small system with PBCs is enough (negligible finite size error)
- Equilibrium lattice constant, cohesive energy, pressure–volume curve
- Elastic constants

When a small system with PBCs is **not** enough (non-negligible finite size error)
- Any property depending on phonon dispersion (e.g. Cv, α, κ)
- Any correlation function (e.g. to obtain transport properties such as diffusion, viscosity, conductivity)
</details>

Instead, we start from the *conventional* Si-diamond cell, containing 8 atoms. We have prepared two files, "BPOSCAR" and "Si.lmp". The former is the conventional cell in POSCAR (`vasp`) format, while the latter is defined in LAMMPS format.

- Inspect "BPOSCAR" with `vim`/`less`/`cat` and visualize with `vesta`
- Inspect "Si.lmp" with `vim`/`less`/`cat`

Whilst we will not directly use the `vasp` inputs in this tutorial, it is useful to check and compare the differences between the two files. What is important to remember is that although the syntax may change between softwares, ultimately we must be able to provide the core definitions of the crystal structure (lattice parameters and atomic positions).

Now, let's proceed to initialise the system and minimise the potential with LAMMPS.

- Inspect the LAMMPS input file.
  ```bash
  vim init.in
  ```
  Check the sections of the input file and make sure you understand the keywords and parameters. Consult the LAMMPS documentation (https://docs.lammps.org) if there is something you don't recognise.

We should highlight a few aspects of the system setup here.
1. We use a **Tersoff** 3-body potential (consult the LAMMPS documentation for the analytical definition). To use this potential, we provide an auxilliary file, "Si.tersoff", in the parent directory of this tutorial (in the same folder where this documentation is written). In this file we set the optimised parameters for 3-body interactions between Si atoms in the Tersoff formulation.
  - Open "Si.tersoff" with `vim`/`less`/`cat` and check the syntax
2. We relax both atomic positions and box lengths at the same time.
3. We finally perform a short NVE run to check the appropriate choice of timestep.

- Finally, let's run LAMMPS.
  ```bash
  lmp -in init.in
  ```
  Follow the minimisation and thermodynamic output. Once finished, check that in the current directory the following files are present:
  ```bash
  perviell@postel 1-init$ ls
  BPOSCAR  init.in  log.lammps  min.data  min.lammpstrj  POSCAR  Si.lmp
  ```
  where we now have output files "log.lammps", "min.data", and "min.lammpstrj". Recall (for example from the previous tutorial) the purpose of these different files, and check that the output has been produced correctly in each case.

**Objectives**
  - Is the Tersoff potential approporiate for modelling interactions between Si atoms? (Check: do we achieve the desired tolerance on the minimisation of the interatomic forces?)
  - Visualize the minimisation (trajectory file "min.lammpstrj") with `vmd`
  - Extract the NVE trajectory from "log.lammps" using `grep` and `sed`/`awk` and plot the total energy as a function of time and fit a line of best fit using linear regression using `gnuplot`. Is the choice of timestep appropriate?

### 2. Equilibration and measurement

- Copy "min.data" (the final configuration after minimisation) and change directory into [2-equ](2-equ/)
  ```bash
  cp min.data ../2-equ/
  cd ../2-equ/
  ```
  
- View the contents of the directory:
  ```bash
  perviell@postel 1-init$ ls
  equ.in min.data
  ```

In the first step, we minimised the potential and checked the validity of the timestep against the total energy in the NVE ensemble.

Now, lets equilibrate the system at 300K and measure the lattice constant. 

- Inspect the input file (e.g. with `vim`/`less`/`cat`)
  ```bash
  vim equ.in
  ```

  See in particular the following sections:
  ```bash
  ### initial conf #######
  read_data       min.data # read a data file
  ########################
  ```
  We load the final positions (and velocities, although these are fixed at 0) and box lengths from the potential minimisation in the first step, that is, we do not need to redefine the system.
  ```bash
  # initialize velocities
  velocity all create 300.0 12345 mom yes rot yes
  ########################
  ```
  We initialize the velocities at 300K with a random seed.
  ```bash
  ### MD run #############
  timestep        0.01
  
  thermo          100
  thermo_style    custom step temp press pe ke etotal lx ly lz
  
  #fix            integ all nve # integrate equation of motion
  fix             1 all npt temp 300.0 300.0 0.1 iso 0.0 0.0 1.0

  run             100000
  ########################
  ```
  We set the `timestep` at 0.01 ps, and integrate in the NPT ensemble by 'fixing' with `fix` (i.e. coupling) a Nose-Hoover thermostat and barostat to the simulation box, then `run` (integrate Newton's equation of motion) for 100,000 steps. Further, we tell LAMMPS to print thermodynamic data every 100 steps with `thermo`, where we specify the variables that should be printed via `thermo_style`; the result is a column-like output every `thermo` steps with corresponding labels as defined above.
  
  Remember, if there are any key words you don't understand, the first resource to check is always the **LAMMPS documentation**.

**Objectives**
- Run LAMMPS
  ```bash
  lmp -in equ.in
  ```
  and follow the thermodynamic output as it is printed in columns to the standard output (the terminal).

- Check that the simulation ran correctly:
  ```bash
  perviell@postel 2-equ$ ls
  equ.data  equ.in  equ.lammpstrj  log.lammps  min.data
  ```
  The directory should now contain the LAMMPS output files: "equ.data", "equ.lammpstrj", "log.lammps".

  Inspect each of these output files (e.g. with `vim`/`less`/`cat`), particularly "log.lammps", to see that the simulation ran as expected, and there are no errors/warnings. Aditionally, you can visualize the trajectory ("equ.lammpstrj") using `vmd`.

- Check that the system is properly equilibrated

  We initialise the velocities immediately at 300K via the Maxwell-Boltzmann distribution. Be aware that this is a quick and dirty way to start the simulation, as after assigning velocities to each atom the forces can be very large, and the starting point may be far from equilibrium. A much safer procedure is to heat the system properly from 0K (the starting point), unless we know already that the configuration we choose is stable at 300K. In our case we have cubic diamond-Si, so we are fairly sure this is stable at 300K...

  Neverthless, let's see whether the system is at equilibrium. We should extract the thermodynamic output from "log.lammps" using `grep` and `sed`/`awk`, and plot the different thermodynamic variables as a function of time using `gnuplot`.

  Are the thermodynamic variables of interest approximately constant? According to our setup, we should have T ~ 300 K and P ~ 0 Bar. Is this the case? In `gnuplot` use linear regression to fit a straight line to to temperature and pressure.

- If the system is in equlibrium, **measure the average value of the lattice constant**. Fit a straight line to the variation of the lattice constant over an equilibirum trajectory. The intersect of the straight line with the y-axis is our average value of the lattice constant.

** Questions **
- The fluctuation of the pressure over the equilibrium trajectory is large, why is this the case?
  -> Reveal answer...


# Notes about why the thermodynamic fluctuations are large

