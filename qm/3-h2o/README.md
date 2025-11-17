# Abinit Tutorial 3 - H<sub>2</sub>O molecule

In this tutorial we will examine two different choices of initial geometry of the H<sub>2</sub>O molecule, as well as two different choices exchange correlation potential, and the effect of these choices on the ground state charge density.

It was shown previously in the [H<sub>2</sub> molecule](../1-h2) example that we can obtain the optimum interatomic separation of the H atoms by pulling the atoms apart "by hand" (i.e. not via some automated procedure) and checking which configuration minimised the ground state energy. While it was not mentioned explicitly, this result alludes to a more general phenomenon: **the ground state, as well as other observable properties, are a function of the geometry**. Moreover, the geometry which gives us the best estimate of the ground state is the one that minimises the ground state energy.

Simply speaking, a bad starting geometry will give us a bad estimate of the ground state, regardless of whether we obtain convergence of the electron density via the self consistent field (SCF) procedure.

Thus, the first aim of this tutorial is to examine the different results we obtain from non-optimised and optimised geometries. We will not actually perform geometry optimisation/relaxation here, which is left to a later example, instead focusing on how the starting geometry affects the measurement of the ground state electron density.

The second aim, is to compare the results we obtain for the ground state electron density using different levels of approximation for the **exchange-correlation (XC) potential**. In particular, we will compare the ability of the Local Density Approximation (LDA) and the Perdew-Burke-Ernzerhof Generalised Gradient Approximation (PBE-GGA) to estimate the ground state electron density. Before continuing with this tutorial, it is recommended to read the detailed [introduction](../) to the quantum mechanics tutorial material where the physical origin and meaning of the exchange correlation potential is discussed, as it will not be repeated again here.

For reference, consult the Abinit [documentation](https://docs.abinit.org/variables/basic/#ixc) for the `ixc` keyword to know which exchange correlation functionals are available and how to set them in the input file.

- Now, let's see what files we have:
  ```bash
  perviell@postel:3-h2o$ ls
  1-nonopt-ixc11  2-opt-ixc1  3-opt-ixc11 README.md
  ```
  You should see 3 folders (and one README file, which you are currently reading here), which separates the different parts of the tutorial to follow.

## 1. Ground state charge density with ixc = 11 - non-optimised atomic positions  

We begin with a non-optimum H<sub>2<\sub>O geometry, and employ the PBE-GGA (`ixc=11`) exchange correlation potential.

**Objectives**

- Navigate to the appropriate directory
  ```bash
  cd 1-nonopt-ixc11
  ```
 
- Inspect the Abinit input file with `vim`/`less`/`cat`, check that you understand the meaning of each keyword that we use. In particular, take a look at the definition of the initial geometry, and make sure you find where the `ixc` keyword is set. `<br>
  If you don't recognise a keyword, remember to **consult the Abinit documentation**.

  In this example, we specify as an input the non-optimised geometry of the H<sub>2</sub>O molecule, and tell Abinit to calculate its ground state energy via an SCF procedure.

- Run Abinit
  ```bash
  abinit ab.in
  ```
  And follow the standard output (what is printed to the terminal) as the simulation is executed.

  Once the simulation concludes, we should find the following files in our working directory (the location where we ran Abinit):
  ```bash
  perviell@postel:1-nonopt-ixc11$ ls
  ab.abo  abo.cif  abo_DEN         abo_EIG     abo_FORCES  abo_GSR.nc  abo_POSCAR  h.psp8
  ab.in   abo_DDB  abo_EBANDS.agr  abo_EIG.nc  abo_GEO     abo_OUT.nc  abo_WFK     o.psp8
  ```

- Check that the SCF procedure has converged within the maximum number of steps specified (Hint: use `grep`... or inspect the file e.g. with `vim`)

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
  -> abo_DEN_nonopt_ixc11.xsf
  #the name is our choice, but make sure to specify the file type (.xsf) correctly
     Do you want to shift the grid along the x,y or z axis (y/n)?
  -> n
     More analysis of the 3D file ? ( 0=no ; 1=default=yes ; 2= treat another file - restricted usage)
  -> 0
  ```

- Visualise the ground state charge density using `vesta`

## Ground state charge density with ixc = 11 - optimised atomic positions with ixc = 11 

In this example, the starting configuration is that obtained after geometry optimisation with the PBE-GGA XC potential (`ixc=11`), followed by an SCF procedure to obtain the converged ground state solution again with the PBE-GGA XC potential (`ixc=11`).

**Objectives**

- Navigate to the appropriate directory
  ```bash
  cd ../2-opt-ixc11
  ```
 
- Inspect the Abinit input file with `vim`/`less`/`cat`, check that you understand the meaning of each keyword that we use. In particular, take a look at the definition of the initial geometry (how large is the difference between atomic positions in the optimised vs non-optimised setups?), and make sure you find where the `ixc` keyword is set.<br>
  If you don't recognise a keyword, remember to **consult the Abinit documentation**.

  In this example, we specify as an input the optimised geometry of the H<sub>2</sub>O molecule, and tell Abinit to calculate its ground state energy via an SCF procedure.

- Run Abinit
  ```bash
  abinit ab.in
  ```
  And follow the standard output (what is printed to the terminal) as the simulation is executed.

- Check that the SCF procedure has converged within the maximum number of steps specified (Hint: use `grep`... or inspect the file e.g. with `vim`)

- Convert the density to a VESTA-compatible format using the Abinit post-processing tool `cut3d`

  Name the file e.g. "abo_DEN_opt_ixc11.xsf" to separate it from other outputs.

- Visualise the ground state charge density using `vesta`

- Compare the ground state electron density of the optimised geometry against the non-optimised geometry result

  In `vesta`, the two density files can be compared as follows:<vr>
  [Note: -> indicates the selection from a drop down menu]
  - On the taskbar select "Edit" -> "Edit data" -> "Volumetric data"
  - On the "Edit dat" screen, select "Import", navigate to and select the charge density obtained from the previous example, in the next window "Subtract from current data" "OK", and finally select "OK" again to close this popup window
  - On the taskbar select "Object" -> "Properties" -> "Isosurfaces"
  - On the "Isosurfaces" screen, create 2 separate isosurfaces for positive and negative density difference
  - Vary the isosurface value to see how/if the shape of the isosurface changes with magnitude of the density. Where is the density the highest?
 
  Note: an *isosurface* is a 3-dimensional surface that represents points in space where a scaslar field has a constant value. In this case, the scalar field is the ground state electron density $n_0(\mathbf{r})$, where an isosurface of this function represents all points $\mathbf{r}$ where $n(\mathbf{r} = $ a specific value (normalised between 0 and 1). A larger isovalue will plot an isosurface on which electrons are distributed at a higher density, a smaller isovalue will do the opposite.

  Further, for a 2D comparison, try:
  - On the taskbar select "Utilities" -> "2D data display..."
  - On the "2D data display" screen select "Slice" (you might need to vary the distance from the origin such that the plane passes through the atoms, and make sure the saturation levels are set appropriately e.g. 0 and 100%) and "OK"
 
**Question**

- Does the geometry optimisation improve our estimate of the ground state electron density, according to our intuition of how charge will be distributed in the H<sub>2</sub>O molecule?

## 3. Ground state charge density with ixc = 11 - optimised atomic positions with ixc = 1

In the final example in this tutorial, the starting configuration is that obtained after geometry optimisation with the LDA XC potential (`ixc=1`), followed by an SCF procedure to obtain the converged ground state solution with the PBE-GGA XC potential (`ixc=11`).

**Objectives**

- Navigate to the appropriate directory
  ```bash
  cd ../3-opt-ixc1
  ```
 
- Inspect the Abinit input file with `vim`/`less`/`cat`, check that you understand the meaning of each keyword that we use. In particular, take a look at the definition of the initial geometry (how large is the difference between atomic positions in the optimised vs non-optimised setups?), and make sure you find where the `ixc` keyword is set.<br>
  If you don't recognise a keyword, remember to **consult the Abinit documentation**.

  In this example, we specify as an input the optimised geometry of the H<sub>2</sub>O molecule, and tell Abinit to calculate its ground state energy via an SCF procedure.

- Run Abinit
  ```bash
  abinit ab.in
  ```
  And follow the standard output (what is printed to the terminal) as the simulation is executed.

- Check that the SCF procedure has converged within the maximum number of steps specified (Hint: use `grep`... or inspect the file e.g. with `vim`)

- Convert the density to a VESTA-compatible format using the Abinit post-processing tool `cut3d`

  Name the output file e.g. "abo_DEN_opt_ixc11.xsf" to separate it from other outputs.

  Type
  ```bash
  cut3d
  ```

- Visualise the ground state charge density using `vesta`

- Compare the ground state electron density of the optimised geometry against the non-optimised geometry result
 
**Questions**
- Which XC functional provides the best ground state geometry to subsequently extract the ground state electron density, according to our intuition?
- What happens if we carry out the SCF procedure with `ixc=1` (LDA)? How does this affect the outcome? Is the ground state electron density better or worse? Try changing the value in the input file, run the simulation again, and check the result.
