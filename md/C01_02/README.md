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
Inside `vim`, use PAGEUP and PAGEDOWN keys to navigate.

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
Open with `vim` and check their contents:
```bash
vim <filename>
```
- log.lammps - a copy saved to file (with some more detail) of the standard output
- mini_final.data - final positions and velocities of each atom
- mini.lammpstrj - the lammps "trajectory" file, positions and velocities as a function potential minimisation step

Note that, in `mini.lammpstrj`, during a minimisation we have positions and velocities as a function of potential minimisation step, during integration of Newton's equation's of motion this file gives positions and velocities as a function of **time**.

**Questions**
- Are the initialized positions physically reasonable, based on the system we wanted to setup? <br>
  [hint: Check by visualizing the minimisation with the output trajectory file e.g. with VMD]
- Was the stopping criterion on the minimisation correctly achieved? <br>
  [hint: check the standard output or log.lammps for information about the energy or forces]
           
### 2. Heating - initialise velocities at 10K, heat to 500K

Copy the final configuration (`init_final.data`) into [2-heat](2-heat/) and change directory.

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

Use `vim` to inspect the new input file
```bash
vim heat.in
```
(remember, :q to quit)

What are the differences between this input and the input from the last step? In particular, see sections related to "initialize velocities" and "MD run":

```bash
# initialize velocities
velocity        all create 10.0 111 mom yes rot yes
########################

### MD run #############
timestep        10.0

fix             integ all nve # integrate equation of motion

fix             thermos all temp/berendsen 10.0 500.0 100.0 # Berendsen thermostat

#fix            baros all press/berendsen iso 1.0 1.0 100.0 # Berendsen barostat

#fix            integ all nvt temp 10.0 500.0 1000.0 # integrate equation of motion + Nose-Hoover thermostat

run             25000
########################
```

In this input, we initialize the velocities at 10K, then tell LAMMPS to perform molecular dynamics in the NVE ensemble. We also impose a Berendsen thermostat to heat the system from 10K to 500K.

Is it correct to impose a thermostat in the NVE ensemble? Check the description of this thermostat in the LAMMPS manual.

**Objectives**

- **Check the choice of timestep is appropriate**
  
  Remove the Berendsen thermostat, by "commenting" i.e. adding a hashtag to the beginning of the appropriate line in `heat.in`.
  ```bash
  #fix             thermos all temp/berendsen 10.0 500.0 100.0 # Berendsen thermostat
  ```
  When opening the file in `vim`, if you type "i" (without the ""), you enter insert mode, and can edit the file. Press "esc" to exit edit mode, and type ":w" to save changes (and :q to quit).<br>
  Alternatively, you may edit the file via a graphical text editor, but in principle all actions can be performed within the terminal, which you will find much more convenient to your work flow with some practice.<br>
  Now, run LAMMPS (only NVE for velocities initialised at 10K):
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

  Follow the output in the terminal. You should see the thermodynamic variables printed at each timestep. We customise the thermodynamic output in the "output definition" section of the input file (check this!). In particular, we chose the different output columns, which correspond to (from left to right): 
  Time, Total energy, Potential energy, Kinetic energy, Temperature, Pressure
  
  Once the simulation is finished, view the output files:
  ```bash
  perviell@postel 2-heat$ ls
  heat_final.data  heat.in  init_final.data  log.lammps  melt.lammpstrj
  ```

  Inspect the various outputs (e.g. with `vim`) - pay careful attention to the parts of the `log.lammps` where the thermodynamic outputs are printed at each timestep of the numerical integration. You may also wish to visualize the dynamical trajectory using `vmd`.

  We want to verify that the timestep is appropriate to model the dynamics in the NVE ensemble, in particular we want the total energy to be approximately constant (within reasonable tolerance).

  **Let's check this explicitly**. You may have noticed when inspecting the output file that the output is sandwiched between two specific lines, which we can search using `grep`
  ```bash
  perviell@postel 2-heat$ grep -n "Time" log.lammps
  92:Time TotEng PotEng KinEng Temp Press
  perviell@postel 2-heat$ grep -n "Loop time" log.lammps
  25094:Loop time of 110.537 on 1 procs for 25000 steps with 864 atoms
  ```

  `grep -n "match" $file` returns the line number of the matching string in the file we search (if it exists).

  Now, we extract and write this output to a new file using `sed` (note, the line numbers that you extract may not be exactly the same, replace the numbers with those extracted from your output):
  ```bash
  sed -n '92,25093p' log.lammps > benchmark.dat
  sed -i '1s/^/#/' benchmark.dat
  ```
  We keep line 92, since it is useful to have the header reminding us what the different columns correspond to, but ignore 10094. The second `sed` command prepends a '#' key, to turn the first line into a comment.

  Note: another useful tool to know, aside from `sed`, for extracting output data is `awk`. It has slightly different syntax, but can serve the same purpose (and has much more uses aside from this):

  ```bash
  awk 'NR>=92 && NR<25093' log.lammps > benchmark.dat
  awk -i inplace 'NR==1{$0="#" $0} {print $0}' benchmark.dat
  ```

  When extracting data, using the tool/syntax you feel most comfortable working in.

  Now, let's plot the data using gnuplot.
  ```bash
  gnuplot
  gnuplot> plot "benchmark.dat" using 1:2 with lines
  ```
  This command plots the 1st (time) and 2nd (total energy) columns of heat.dat in the x and y axes respectively. You may also wish to check the variation of other thermodynamic variables as a function of time, by plotting 1:NUM (where NUM is the number of any of the other columns).

  Using the right mouse, you can highlight regions on the plot to zoom in. Pressing "a" on your keyboard reverts to the default zoom.

  You should see a fluctuating but roughly constant total energy. But, exactly how "constant" is it?

  In the `gnuplot` terminal, we can use linear regression to find the best fit of a straight line to the data:
  ```bash
  gnuplot> f(x) = m*x + c
  gnuplot> m = 1
  gnuplot> c = 1
  gnuplot> fit f(x) "benchmark.dat" using 1:2 via m,c
  ```
  Note, the initial definition of m and c are the starting guesses, gnuplot then finds the optimum values of m and c via linear regression. The output should look something like this:
  ```bash
  iter      chisq       delta/lim  lambda   m             c
   0 9.1918668422e+15   0.00e+00  4.08e+03    1.000000e+00   1.000000e+00
   1 2.3216295309e+15  -2.96e+05  4.08e+02    1.445174e+02   1.455822e+02
   2 2.2535036459e+15  -3.02e+03  4.08e+01    1.423883e+02   1.438797e+04
   3 3.6047408817e+14  -5.25e+05  4.08e+00    5.694850e+01   5.840153e+05
   4 1.5803295319e+10  -2.28e+09  4.08e-01    3.770677e-01   9.611771e+05
   5 1.1887682202e+02  -1.33e+13  4.08e-02    2.531404e-05   9.636908e+05
   6 4.8677390870e+01  -1.44e+05  4.08e-03    1.829237e-07   9.636910e+05
   * 4.8677390870e+01   4.21e-07  4.08e-02    1.829022e-07   9.636910e+05
   * 4.8677390870e+01   4.27e-07  4.08e-01    1.829022e-07   9.636910e+05
   * 4.8677390871e+01   5.97e-07  4.08e+00    1.829022e-07   9.636910e+05
   * 4.8677390870e+01   3.03e-07  4.08e+01    1.829024e-07   9.636910e+05
   7 4.8677390869e+01  -2.16e-06  4.08e+00    1.829103e-07   9.636910e+05
  iter      chisq       delta/lim  lambda   m             c

  After 7 iterations the fit converged.
  final sum of squares of residuals : 48.6774
  rel. change during last iteration : -2.15851e-11

  degrees of freedom    (FIT_NDF)                        : 9999
  rms of residuals      (FIT_STDFIT) = sqrt(WSSR/ndf)    : 0.0697727
  variance of residuals (reduced chisquare) = WSSR/ndf   : 0.00486823

  Final set of parameters            Asymptotic Standard Error
  =======================            ==========================
  m               = 1.8291e-07       +/- 2.417e-07    (132.1%)
  c               = 963691           +/- 0.001395     (1.448e-07%)

  correlation matrix of the fit parameters:
                m      c
  m               1.000
  c              -0.866  1.000
  ```
  A copy is written to a file called `fit.log`. Note the "final set of parameters" in the output. The gradient is on the order of 1.8e-07 (the exact value may differ for you). This tells us that the drift of the total energy over the trajectory is small. For this tutorial, it is more than enough. We can also overlay the straight line on top of the data in the gnuplot plot:

  ```bash
  gnuplot> plot "benchmark.dat" using 1:2 with lines, f(x)
  ```

- **Reapply the Berendsen thermostat (still within the NVE ensemble) and heat to 500K.**

  Modify heat.in (e.g. with vim) to uncomment the Berendsen thermostat.

  Run lammps again:
  ```bash
  lmp -in heat.in
  ```

  If we follow the 5th column, we should see the temperature steadily approach 500K.

  Visualize the trajectory with `vmd`.

  Using the same approach in the benchmark step, extract the thermodynamic output at each timestep from `log.lammps` using `sed` or `awk`. Write to a file (e.g. `heat.dat`) and plot using `gnuplot`. Note: Be careful to use the correct line numbers when extracting the data.

  Try fitting another straight line in `gnuplot`, what is the gradient this time?
  
**Optional Objectives**

- **Integrate Newton's equations and apply a Nose-Hoover thermostat to heat to 500K in the NVT ensemble.**

  the "MD run" section in `heat.in` should looks as follows:
  ```bash
  ### MD run #############
  timestep        1.0

  #fix            integ all nve # integrate equation of motion

  #fix            thermos all temp/berendsen 10.0 500.0 100.0 # Berendsen thermostat

  #fix            baros all press/berendsen iso 1.0 1.0 100.0 # Berendsen barostat

  fix             integ all nvt temp 10.0 500.0 100.0 # integrate equation of motion + Nose-Hoover thermostat

  run             25000
  ########################
  ```
  Extract the thermodynamic output from `log.lammps` using your preferred approach (`sed`/`awk`). You may want to visualize the trajectory in `vmd`, or plot the variation of thermodynamic variables as a function of time in `gnuplot`.
  
**Questions**

- Is the heating behaviour in NVT the same as in NVE? (compare the gradients in `gnuplot`) 
- Is there a difference in computational time to perform the numerical integration in the NVT ensemble vs NVE?

### 3. Cooling - cool system to 94.4 K

Copy the final configuration (`heat_final.data`) into [3-cool](3-cool/) and change directory.

```bash
cp heat_final.data ../3-cool/
cd ../3-cool/
```

If you inspect the contents of the directory, it should contain:
```bash
perviell@postel 3-cool$ ls
cool.in  heat_final.data
```

Use `vim` to inspect the input file
```bash
vim cool.in
```
(remember, :q to quit)

What are the differences between this input and the input from the last step? Here, since velocities are already defined in `heat_final.data`, we should not redefine them. Further, see the "MD run" section: we aim to cool the system from 500K to 94.4K with a Berendsen thermostat, the target temperature at which we want to make equilibrium measurements.

Run LAMMPS:
```bash
lmp -in cool.in
```

Follow the standard output (or check `log.lammps` afterwards) to check that there are no errors during the simulation. Check that the system reaches ~94.4K.

**Objectives**

- Visualize the `cool.lammpstrj` trajectory in `vmd`
- Extract the thermodynamic output at each timestep using `sed` or `awk`, write to file e.g. `cool.dat`
- Plot the temperature as a function of time in  `gnuplot`
- Fit a straight line to temperature vs time in `gnuplot`

**Optional Objectives**

- Replace the NVE ensemble and Berendsen thermostat with an NVT ensemble and thermostat.
	
### 4. Equilibration - prepare system for measurement at 94.4 K

Copy the final configuration (`cool_final.data`) into [4-equ](4-equ/) and change directory.

```bash
cp cool_final.data ../4-equ/
cd ../4-equ/
```

If you inspect the contents of the directory, it should contain:
```bash
perviell@postel 4-cool$ ls
equ.in  cool_final.data
```

Use `vim` to inspect the input file
```bash
vim equ.in
```
(remember, :q to quit)

What are the differences between this input and the input from the last step?

```bash
perviell@postel 4-equ$ grep -n "Time" log.lammps
82:Time TotEng PotEng KinEng Temp Press
50115:Time TotEng PotEng KinEng Temp Press
perviell@postel 4-equ$ grep -n "Loop" log.lammps
50084:Loop time of 43.3201 on 1 procs for 50000 steps with 864 atoms
100117:Loop time of 42.4362 on 1 procs for 50000 steps with 864 atoms

perviell@postel 4-equ$ sed -n '82,50083p' log.lammps > equ.dat
perviell@postel 4-equ$ sed -n '50115,100116p' log.lammps > equ2.dat
perviell@postel 4-equ$ sed -i '1s/^/#/' equ.dat
perviell@postel 4-equ$ sed -i '1s/^/#/' equ2.dat


perviell@postel 4-equ$ movavg equ.dat equ_avg.dat 10000 1 5
perviell@postel 4-equ$ movavg equ2.dat equ2_avg.dat 10000 1 5
```


[check drift on second stage with gnuplot]

	Objectives:
	I)   Check system is in equilibrium
	     [hint: Plot T vs t, fit straight line]
	--- OPTIONAL ---
	II)  Calculate moving average and standard deviation, plot average or stddev
	     as a function of time, should observe reduction in stddev as t increases
	     [hint: using moving_avg_stddev.c code (must be compiled first)]
	     
### 5. Production - calculate diffusion coefficient (D) and pair correlation function

[copy final configuration to 5-prod and run production to extract MSD, gnuplot fit to extract diffusion coefficient]

what about RDF/pair correlation function?

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
		
