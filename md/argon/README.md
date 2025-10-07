# Tutorial

In this tutorial, we focus on using Molecular Dynamics (MD) to measure observable properties at equilibrium.

We will demonstrate how to use the Large-scale Atomic/Molecular Massively Parallel Simulator (**LAMMPS**) software to calculate
- a) the diffusion coefficient, and
- b) the radial distribution function

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

Aside from initialising the atomic positions, we also want to minimise the potential. For this purpose, we employ the conjugate gradient algorithm. Note the section 'minimization', and in particular the keywords 'min_style' and 'minimize'. Check the syntax of these commands in the LAMMPS manual.

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
vim $filename
```
[Note: $filename is a placeholder, write the name of the file you want to open!]
- "log.lammps" - a copy saved to file (with some more detail) of the standard output
- "mini_final.data" - final positions and velocities of each atom
- "mini.lammpstrj" - the lammps trajectory file, positions and velocities as a function potential minimisation step

Note that, in "mini.lammpstrj", during a minimisation we have positions and velocities as a function of potential minimisation step, during integration of Newton's equation's of motion this file gives positions and velocities as a function of **time**.

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

What are the differences between this input and the initialisation/minimisation input? In particular, see sections related to 'initialize velocities' and 'MD run':

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
  
  Remove the Berendsen thermostat, by 'commenting' i.e. adding a hashtag to the beginning of the appropriate line in "heat.in".
  ```bash
  #fix             thermos all temp/berendsen 10.0 500.0 100.0 # Berendsen thermostat
  ```
  And increase the size of the timestep from 10.0 to 100.0.
  ```bash
  ### MD run #############
  timestep        100.0
  ```
  To edit the file in the terminal, one option is `vim`: if you type "i" (without the ""), you enter insert mode, and can edit the file. Press "esc" to exit edit mode, and type ":w" to save changes (and :q to quit).<br>
  Alternatively, you may edit the file via a graphical text editor, but in principle all actions can be performed within the terminal, which you will find much more convenient to your work flow with some practice.<br>
  Now, run LAMMPS (only NVE for velocities initialised at 10K):
  ```bash
  lmp -in heat.in
  ```
  Check the standard output, did the simulation finish correctly?

  You should see an 'ERROR' message, related to lost atoms. This means that the timestep is too large to properly capture the dynamics. We should therefore reduce the timestep back to its previous setting by editing "heat.in" (e.g. with `vim`) and setting
  ```bash
  ### MD run #############
  timestep        10.0
  ```

  Then run LAMMPS again:
  ```bash
  lmp -in heat.in
  ```

  Follow the output in the terminal, and check to see that the simulation completes properly withour errors. You should see the thermodynamic variables printed at each timestep. We customise the thermodynamic output in the "output definition" section of the input file (check this!). In particular, we chose the different output columns, which correspond to (from left to right): 
  Time, Total energy, Potential energy, Kinetic energy, Temperature, Pressure
  
  Once the simulation is finished, view the output files:
  ```bash
  perviell@postel 2-heat$ ls
  heat_final.data  heat.in  init_final.data  log.lammps  melt.lammpstrj
  ```

  Inspect the various outputs (e.g. with `vim`) - pay careful attention to the parts of "log.lammps" where the thermodynamic outputs are printed at each timestep of the numerical integration. You may also wish to visualize the dynamical trajectory using `vmd`.

  We want to verify that the timestep is appropriate to model the dynamics in the NVE ensemble, in particular we want the total energy to be approximately constant (within reasonable tolerance).

  **Let's check this explicitly**. You may have noticed when inspecting the output file that the output is sandwiched between two specific lines, which we can search using `grep`.
  ```
  ```bash
  perviell@postel 2-heat$ grep -n "Time" log.lammps
  92:Time TotEng PotEng KinEng Temp Press 
  perviell@postel 2-heat$ grep -n "Loop" log.lammps
  10094:Loop time of 9.38265 on 1 procs for 10000 steps with 864 atoms
  ```

  `grep -n "STRING" $file` returns the line number of the matching string in the file we search (if it exists).

  Now, we extract and write this output to a new file using `sed` (note, the line numbers that you extract may not be exactly the same, replace the numbers with those extracted from your output):
  ```bash
  sed -n '92,10093p' log.lammps > benchmark.dat
  sed -i '1s/^/#/' benchmark.dat
  ```
  We keep line 92, since it is useful to have the header reminding us what the different columns correspond to, but ignore 10094 as this is the line *after* the last timestep. The second `sed` command prepends a '#' key, to turn the first line into a comment.

  Note: another useful tool to know, aside from `sed`, for extracting output data is `awk`. It has slightly different syntax, but can serve the same purpose (and has much more uses aside from this):

  ```bash
  awk 'NR>=92 && NR<=10093' log.lammps > benchmark.dat
  awk -i inplace 'NR==1{$0="#" $0} {print $0}' benchmark.dat
  ```

  When extracting data, use the tool/syntax you feel most comfortable working in.

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

- **Reapply the Berendsen thermostat (still within the NVE ensemble) and heat to 500K**

  Modify heat.in (e.g. with `vim`) to uncomment the Berendsen thermostat.

  Run lammps again:
  ```bash
  lmp -in heat.in
  ```

  If we follow the 5th column, we should see the temperature steadily approach 500K.

  Visualize the trajectory with `vmd`.

  Using the same approach in the benchmark step, extract the thermodynamic output at each timestep from `log.lammps` using `sed` or `awk`. Write to a file (e.g. "heat.dat") and plot using `gnuplot`. Note: Be careful to use the correct line numbers when extracting the data.

  Try fitting another straight line in `gnuplot`, what is the gradient this time?
  
**Optional Objectives**

- **Integrate Newton's equations and apply a Nose-Hoover thermostat to heat to 500K in the NVT ensemble.**

  the 'MD run' section in "heat.in" should looks as follows:
  ```bash
  ### MD run #############
  timestep        10.0

  #fix            integ all nve # integrate equation of motion

  #fix            thermos all temp/berendsen 10.0 500.0 100.0 # Berendsen thermostat

  #fix            baros all press/berendsen iso 1.0 1.0 100.0 # Berendsen barostat

  fix             integ all nvt temp 10.0 500.0 100.0 # integrate equation of motion + Nose-Hoover thermostat

  run             10000
  ########################
  ```
  Extract the thermodynamic output from "log.lammps" using your preferred approach (`sed`/`awk`). You may want to visualize the trajectory in `vmd`, or plot the variation of thermodynamic variables as a function of time in `gnuplot`.
  
**Questions**

- Is the heating behaviour in NVT the same as in NVE? (compare the gradients in `gnuplot`)
- Is there a difference in computational time to perform the numerical integration in the NVT ensemble vs NVE?
- Plot the total energy of the system in NVT, is it constant? What should the conserved quantity be?
  Hint, Modify the 'output definition' section in `heat.in`:
  ```bash
  ### output definition ##
  thermo          1 # every many steps output is printed
  thermo_style    custom time etotal pe ke temp press ecouple econserve # print thermodynamic variables
  ```
  We have introduced two additional keywords 'ecouple' and 'econserve' to `thermo_style`, check the meaning of these keywords in the LAMMPS manual to understand why they are important!
- Replace the Berendsen thermostat with a Berendesen *barostat*. Extract the thermodynamic output with `grep` and `sed`/`awk`, plot the different properties with respect to time. What happens to the pressure? What about the other thermodynamic properties?
  Hint, The 'MD run' section should look something like this (e.g. modify with `vim`):
  ```bash
  ### MD run #############
  timestep        10.0
  
  fix             integ all nve # integrate equation of motion
  
  #fix            thermos all temp/berendsen 10.0 500.0 100.0 # Berendsen thermostat
  
  fix             baros all press/berendsen iso 1.0 1.0 100.0 # Berendsen barostat
 
  #fix            integ all nvt temp 10.0 500.0 100.0 # integrate equation of motion + Nose-Hoover thermostat
 
  run             10000
  ########################
  ```

### 3. Cooling - cool system to 94.4 K

Copy the final configuration ("heat_final.data") into [3-cool](3-cool/) and change directory.

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

What are the differences between this input and the input from the last step? Here, since velocities are already defined in "heat_final.data", we should not redefine them. Further, see the 'MD run' section: we aim to cool the system from 500K to 94.4K with a Berendsen thermostat, the target temperature at which we want to make equilibrium measurements.

Run LAMMPS:
```bash
lmp -in cool.in
```

Follow the standard output (or check "log.lammps" afterwards) to check that there are no errors during the simulation, and to ensure that the system reached 94.4K.

**Objectives**

- Visualize the trajectory ("cool.lammpstrj") in `vmd`
- Extract the thermodynamic output at each timestep using `grep` and `sed`/`awk`, write to file e.g. `cool.dat`
- Plot the temperature as a function of time in  `gnuplot`
- Fit a straight line to temperature vs time in `gnuplot`

**Optional Objectives**

- Replace the NVE ensemble and Berendsen thermostat with an NVT ensemble and thermostat, visualize/plot the trajectory
- 
	
### 4. Equilibration - prepare system for measurement at 94.4 K

Copy the final configuration ("cool_final.data") into [4-equ](4-equ/) and change directory.

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

What are the differences between this input and the input from the last step? In particular, see the "MD run" section:
```bash
### MD run #############
timestep	10.0

fix			integ all nve # integrate equation of motion
fix 		thermos all temp/berendsen 94.4 94.4 1000.0 # Berendsen thermostat

run 		50000

unfix		thermos

run		50000
########################
```
We specify two different integrations in the same input file:<br>
a) First, we integrate for 50,000 steps in the NVE ensemble while applying a Berendsen thermostat.<br>
b) Then, we remove the Berendsen thermostat and perform a **pure NVE** run for another 50,000 steps.<br>

Why? 
<details>
<summary>Click for the answer</summary>
During the previous (cooling) step, the system arrives at 94.4K only in the last few steps of the trajectory. If we immediately perform a pure NVE simulation, residual momentum can cause large fluctuations in the temperature, and the system may settle at a temperature we do not want. 

By using a Berendsen thermostat first, we gently hold the system at 94.4K, reducing fluctuations and preparing a smoother starting point. Once the system is closer to equilibrium, we remove the thermostat and allow it to evolve under pure NVE, maintaining the target temperature more reliably.
</details>

We also use a relatively weak coupling bewteen the Berendsen thermostat and system as compared to the previous heating/cooling steps.

Why?
<details>
<summary>Click for the answer</summary>
Strong coupling between the thermostat and the system can create artificial correlations; when the thermostat is removed, these can manifest as sudden temperature fluctuations.

A weaker coulping avoids overconstraining the system, allowing it to relax more naturally. In more rigorous protocols, one would gruadually reduce the thermostat coupling before fully removing it, optimally preparing the system for an NVE run at the target temperature.
</details>

Now run LAMMPS:
```bash
lmp -in equ.in
```
And follow the thermodynamic output per timestep as it is printed to standard output (i.e. in the terminal window).

Once the simulation is finished, check that the output files have been generated correctly (e.g. open with `vim`):
```bash
perviell@postel 4-equ$ ls
cool_final.data  equ.in  equ.lammpstrj  equ_final.data  log.lammps
```

Now, we want to check that the system is equilibrated at the correct temperature. 

**Objectives**

- Extract the thermodynamic data for the pure NVE run to a file e.g. "equ.dat". <br>
  Using `grep` and `sed`/`awk`, extract the start and end points of the two MD runs. Note that, `grep` will return all matches of a string, so you can use a single `grep` command to search for the start or end lines of both MD runs at the same time. 

- Using `gnuplot`, plot the temperature as a function of time, and fit a straight line. <br>
  If the gradient is small, then the drift in temperature is negligible over the duration of the simulation.

  Note: a small drift in temperature is not sufficient on its own to prove that we are at equilbrium. We are also concerned with the **magnitude of fluctuations** around the average temperature.

- Calculate the moving average and standard deviation of the temperature during the pure NVE run<br>
  To do this by hand is not practical, so we have prepared a script called `movavg`.

  When downloading the tutorial files, you should have already ran the install script for the [scripts](../../scripts/) folder, as outlined on the [homepage](../../). If not, you should do this now.

  The syntax to use `movavg` is as follows:
  ```bash
  perviell@postel 4-equ$ movavg
  Usage: movavg <input_file> <output_file> <dt> <step_window> <step_col_id> <col_to_avg_id>
  ```

  For example, if we extracted the thermodynamic data from the pure NVE run to "equ.dat":
  ```bash
  perviell@postel 4-equ$ movavg equ.dat equ_avg.dat 10 1000 1 5
  Detected a header line. Reading the next line.
  INFO: Moving average and standard deviation written to 'equ_avg.dat'
  INFO: Moving average computed over a time window of 10000.00000 (step_window = 1000, dt = 10.00000)
  ```
  where we specify "equ.dat" as the input file, "equ_avg.dat" as the output file, `timestep=10` (we read this value from "equ.in"), `step_window=1000` (one possible choice), and specify `step_col_id=1` and `col_to_avg_id=5` which corresponds to the column IDs of the timestep and temperature respectively in the thermodynamic output.

  Note, the total time window of the moving average is equal to `step_window * dt`.

  We should find that the standard deviation of the fluctations is < 2% of the moving average over the duration of the trajectory. It may be that the moving average is not exactly 94.K, however for the precision that we are aiming for in this tutorial, temperature fluctuations of +/- 1K are okay.
	     
### 5. Production - calculate diffusion coefficient (D) and pair correlation function

Copy the final configuration ("equ_final.data") into [5-prod](5-prod/) and change directory.

```bash
cp equ_final.data ../5-prod/
cd ../5-prod/
```

If you inspect the contents of the directory, it should contain:
```bash
perviell@postel 5-prod$ ls
equ_final.data prod.in  rdf.gp
```
(Note: "rdf.gp" is a gnuplot template we will use later to plot the radial distribution function - you can open it with `vim` to see what is happening.)

Use `vim` to inspect the input file
```bash
vim prod.in
```
(remember, :q to quit)

What are the differences between this input and the last equilibration step? In particular, see the 'compute' and 'MD run' sections:

```bash
### compute ############
compute		msd all msd com yes
compute		rdf all rdf 1000
########################
```

We have defined two LAMMPS 'computes': one for the mean square displacement (MSD), which we need to derive the diffusion coefficient; and another for the radial distribution function (RDF) (with a bin size of 1000).

```bash
### MD run #############
timestep	10.0

fix		integ all nve # integrate equation of motion
#fix 		thermos all temp/berendsen 94.4 94.4 100.0 # Berendsen thermostat

#fix		integ all nvt temp 94.4 94.4 100.0 # integrate equation of motion + Nose-Hoover thermostat

fix		rdf_ave all ave/time 5 200 1000 c_rdf[*] file tmp.rdf mode vector ave one

run 		100000
########################
```

We run 100,000 timesteps in a pure NVE ensemble, and introduce a new 'fix' to calculate the average RDF every 1000 timesteps. The syntax `5 200 1000` means that the RDF is collected every 5 timesteps, 200 times (5*200 = 1000), in a 1000 timestep long window. Thus, the average is calculated from 200 samples every 1000 timesteps.

Now run LAMMPS:
```bash
lmp -in equ.in
```
And follow the thermodynamic output per timestep as it is printed to standard output (i.e. in the terminal window). As compared to the previous example, we now have an additional column which prints the MSD.

Check that the following output files exist after the simulation completes:
```bash
perviell@postel 5-prod$ ls
equ_final.data  log.lammps  prod.in  prod.lammpstrj  prod_final.data  rdf.gp  tmp.rdf
```

**Objectives**

- Visualize the LAMMPS trajectory file "prod.lammpstrj" with `vmd`.

- Check that the system stays in equilibrium<br>
  Use e.g. `grep` and `sed`/`awk` to extract and format the thermodynamic output from "log.lammps", then `gnuplot` to plot and fit a straight line, and/or `movavg` to calculate the moving average and standard deviation.

- Calculate the diffusion coefficient (D)<br>
  Using `gnuplot`, plot the MSD vs time. If everything went well, there should be a roughly linear relation between MSD and time. Use the fit functionality in `gnuplot` to fit a straight line to the data. The gradient of the slope is proportional to the diffusion coefficient. Note, **the gradient is not the final value** - you must utilise the Einstein relation for the diffusion coefficient to derive the final value of D (we discuss this equation in the lectures).

- Plot the RDF as a function of time
  If everything ran correctly, LAMMPS will have written "tmp.rdf". This contains the timeseries evolution of the RDF. This data requires pre-processing - we provide the script `rdf_pp.sh` for this purpose - before plotting with `gnuplot` using the template "rdf.gp". <br>
  When downloading the tutorial files, you should have already ran the install script for the [scripts](../../scripts/) folder, as outlined on the [homepage](../../). If not, you should do this now.
  ```bash
  rdf_pp.sh tmp.rdf
  gnuplot rdf.gp
  ```

**Optional Objectives**

- Calculate the average value of the RDF over the equilibrium trajectory (this corresponds to the ensemble average RDF distribution)<br>
  [Hint: check the syntax of `fix ave/time` in the LAMMPS documentation.]

**Questions**
- How similar is our value of the diffusion coefficient (D) to the one calculated by Rahman in the reference paper?
- What might we do to improve the setup, in order to obtain a more accurate estimate of D?
