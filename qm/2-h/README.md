# Abinit Tutorial 2 - Electronic orbitals of the hydrogen atom

In this tutorial we will use the **Abinit** simulation package, which employs the quantum equations of Density Functional Theory (DFT), to calculate (and subsequently visualise with VESTA) the electronic orbitals of the hydrogen atom.

- Let's see what files we have:
  ```bash
  perviell@postel:2-h$ ls
  README.md ab.in cut3d_in.sh h.psp8
  ```
  [Note: You should not enter the part before $, it is there to show the result of running `ls` on my machine (which prints on the following line) as shown above.]

## 1. Calculate the ground state energy

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
  ab.abo  ab.in  abo_DDB  abo_DEN  abo_EBANDS.agr  abo_EIG  abo_EIG.nc  abo_GSR.nc  abo_OUT.nc  abo_WFK  h.psp8
  ```
  
- Check that the SCF calculation has converged

  Open the log file `ab.abo` and find the section which reports the progress of the SCF procedure. Did the ground state energy converge to to the tolerance that we chose?

  This information can also be extracted succinctly via the following command:
  ```bash
  grep "ETOT" ab.abo
  ```

## 2. Visualise the electronic orbitals of the hydrogen atom

**Objectives**

- Convert the density to a VESTA-compatible format using the Abinit post-processing tool `cut3d`
  
  Type
  ```bash
  cut3d
  ```

  And when prompted, enter the following information:
  ```bash
     What is the name of the 3D function (density, potential or wavef) file ?
  -> abo_WFK
     For which band ? (1 to    15)
  -> 1
     Do you want to analyze a GW wavefunction? (1=yes,0=no)
  -> 0
     Do you want the atomic analysis for this state :
     (kpt,band)= (    1    1)?
     If yes, enter the radius of the atomic spheres, in bohr
     If no, enter 0
  -> 0
     What is your choice ? Type:
  -> 14
  # Option 9 tells cut3d to create an output .cube file (cut3d gives you a list of options, you select 14)
     Enter the root of an output file:
  -> abo_WFK
     Do you want to shift the grid along the x,y or z axis (y/n)?
  -> n
     Run interpolation again? (1=default=yes,0=no)
  -> 1
  ```

  Run the interpolation for each orbital which you wish to visualise. `cut3d` will generate output files, for example, if we select the first band the file is called "abo_WFK_k1_b1".

  Note the terminology
  - k{NUM} = k-point number (for a isolated hydrogen atom we have only 1 k-point)
  - b{NUM} = band number (the different energy levels)


  To avoid duplication of labour, we provide a script to automate the process of extracting the various electronic wavefunctions in `cut3d_in.sh`, which may be run as:
  ```bash
  cut3d_in.sh
  ```

- Visualize the ground state charge density using `vesta`


**Questions**
- Can you identify the different hydrogen orbitals?
- How close are these orbitals (best approximate solution from Kohn-Sham DFT) to the analytically-obtained (from direct solution of the TISE) hydrogen orbitals?
