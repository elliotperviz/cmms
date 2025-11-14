# Abinit Tutorial 1 - H<sub>2</sub> molecule

In this tutorial we will use the **Abinit** simulation package, which employs the quantum equations of Density Functional Theory (DFT), to perform calculations on the H2 molecule...

- Change into the appropriate directory:
  ```bash
  cd h2-1
  ```

- Let's see what files we have:
  ```bash
  perviell@postel:h2-1$ ls
  POSCAR  ab.in  h.psp8
  ```
  [Note: You should not enter the part before $, it is there to show the result of running `ls` on my machine (which prints on the following line) as shown above.]

  Recall, the files we must always have to start a calculation in Abinit:
  - Abinit input file
  - Pseudopotential file(s)

  The "POSCAR" file is provided for visualisation purposes e.g. it may be opened with `vesta` or `ovito`.

## 1. Calculating the ground state energy

**Objectives**
 
- Inspect the Abinit input file with `vim`/`less`/`cat`, check that you understand the meaning of each keyword that we use.<br>
  If you don't recognise a keyword, remember to **consult the Abinit documentation**.

  In this example, we specify as an input the crystal structure of the (condensed) H2 molecule, and tell Abinit to calculate its ground state energy via an SCF (self-consistent field) procedure.

- Run Abinit
  ```bash
  abinit ab.in
  ```
  And follow the standard output (what is printed to the terminal) as the simulation is execucted.

  Once the simulation concludes, we should find the following files in your working directory (the location where we ran Abinit):
  ```bash
  perviell@postel:h2-1$ ls
  POSCAR  ab.abo  ab.in  abo_DDB  abo_DEN  abo_EBANDS.agr  abo_EIG  abo_EIG.nc  abo_GSR.nc  abo_OUT.nc  abo_WFK  h.psp8
  ```
  We will see that aside from the input files that we had previously, Abinit has created a number of output files.

- Check that the SCF calculation has converged

  Open the log file `ab.abo` and find the section which reports the progress of the SCF procedure. Did the ground state energy converge to the tolerance that we chose?

  This information can also be extracted succinctly via the following command:
  ```bash
  grep "ETOT" ab.abo
  ```

## 2. Ground state energy as a function of H2 interatomic distance

**Objectives**

- Change into the appropriate directory:
  ```bash
  cd ../h2-2
  ```

- And list the files in the directory:
  ```bash
  perviell@postel:h2-1$ ls
  ab.in  h.psp8
  ```

- Inspect the Abinit input file "ab.in" with `vim`/`less`/`cat`

  **Question** - What is different in this input file?

  An important comment to make is that we leverage so-called 'datasets' via the `ndtset` keyword. This is Abinit language to specify chains of simulations, similar to how we can chain simulations together when running molecular dynamics in LAMMPS. In this example, we make use of Abinit datasets to progressively separate the two H atoms, and we tell Abinit to calculate the ground state energy of each configuration.

- Run Abinit
  ```bash
  abinit ab.in
  ```
  And follow the standard output (what is printed to the terminal) as the simulation is execucted.

  Once the simulation concludes, we should find output files corresponding to each dataset in our working directory. Abinit uses the root **abo_DS{NUM}_** for each dataset (DS) e.g. DS1, DS5, DS20 and so on, followed by the string which identifies what data is contained in each file e.g. DEN, WFK, etc.

- Check that all 21 datasets reach convergence in the SCF procedure

  If we open the output file "ab.abo", we can scroll through and check that each dataset converges correctly. However, this is cumbersome and time-wasting. Instead, we will employ `awk`:
  ```bash
  awk '/ETOT/ {
    if ($2 == 1 && NR > 1) print "";
    print
  }' ab.abo
  ```
  to search for the 'ETOT' string in "ab.abo" and separate the output into blocks.

- Plot the ground state energy as a function of interatomic distance

  We search "ab.abo" for the keyword which defines the ground state energy at the end of each SCF procedure, and do some additional formatting before writing the final output to "etot.dat".
  ```bash
  grep -E "etotal[0-9]" ab.abo |  sed -n 's/etotal//p' | sed 's/^[[:space:]]*//' > etot.dat
  ```

  And plot using `gnuplot`.

**Questions**

- Calculate the ideal interatomic distance
  
  Starting positions: atom 1: -0.5 Bohr; atom 2: 0.5 Bohr (separated by 1 Bohr).<br>
  (We specify in the input file that atoms 1 and 2 sit at 0 in the y and z axes, so we only consider the x-axis.)

  Each step adds/subtracts: atom 1: -0.025 Bohr; atom 2: +0.025 Bohr.

  [Hint: Find the dataset ID at which we obtain the minimum energy and multiply by the separation we add at each step.]

- How can we improve our estimate?
  
  Note that the experimental bond length is ~ 1.401 Bohr.


## 3. Visualise the charge density for the H2 molecule at its ideal interatomic separation

**Objectives**

- Change into the appropriate directory:
  ```bash
  cd ../h2-3
  ```

- And list the files in the directory:
  ```bash
  perviell@postel:h2-1$ ls
  ab.in  h.psp8
  ```

- Inspect the Abinit input file "ab.in" with `vim`/`less`/`cat`

  **Question** - What is different in this input file?

- Run Abinit
  ```bash
  abinit ab.in
  ```
  And follow the standard output (what is printed to the terminal) as the simulation is execucted.
  
- Check that the SCF procedure is converged appropriately (Hint: use `grep`... or inspect the file e.g. with `vim`)

- Convert the density to a VESTA-compatible format using the Abinit post-processing tool `cut3d`

  Type
  ```bash
  cut3d
  ```

  And when prompted, enter the following information:
  ```bash
     What is the name of the 3D function (density, potential or wavef) file ?
  -> abo_DEN
     What is your choice ? Type:
  -> 9
  # Option 9 tells cut3d to create an output xsf file (cut3d gives you a list of options, you select 9)
     Enter the name of an output file:
  -> abo_DEN.xsf
  #the name is optional, but make sure you specify the file type (.xsf) correctly
     Do you want to shift the grid along the x,y or z axis (y/n)?
  -> n
     More analysis of the 3D file ? ( 0=no ; 1=default=yes ; 2= treat another file - restricted usage)
  -> 0
  ```

- Visualize the ground state charge density using `vesta`

  
  
  

