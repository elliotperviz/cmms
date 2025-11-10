# Abinit Tutorial 1 - H2 molecule

In this tutorial we will use the **Abinit** simulation package, which employs the quantum equations of Density Functional Theory (DFT), to perform calculations on the H2 molecule...

## 1. Calculating the ground state energy
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
 
- Inspect the Abinit input file with `vim`/`less`/`cat`, check that you understand the meaning of each keyword that we use.<br>
  If you don't recognise a keyword, remember to **consult the Abinit documentation**.

  In this example, we specify as an input the crystal structure of the (condensed) H2 molecule, and tell Abinit to calculate its ground state energy via an SCF (self-consistent field) procedure.

- Run Abinit
  ```bash
  abinit ab.in
  ```
  And follow the standard output (what is printed to your terminal) as the simulation is execucted.

  Once the simulation concludes, you should find the following files in our working directory (the location where we ran Abinit):
  ```bash
  perviell@postel:h2-1$ ls
  POSCAR  ab.abo  ab.in  abo_DDB  abo_DEN  abo_EBANDS.agr  abo_EIG  abo_EIG.nc  abo_GSR.nc  abo_OUT.nc  abo_WFK  h.psp8
  ```
  You will see that aside from the input files that we had previously, Abinit has created a number of output files.

- Check that the SCF calculation has converged

  Open the log file `ab.abo` and find the section which reports the progress of the SCF procedure. Does this simulation convergence to to the tolerance that we chose?

  This information can also be extracted succinctly via the following command:
  ```bash
  grep "ETOT" ab.abo
  ```



  





