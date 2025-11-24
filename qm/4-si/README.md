# Abinit Tutorial 4 - Geometry optimisation, band structure and convergence study of crystalline Si-diamond

In the previous tutorial, we demonstrated that the ground state electron density varies depending on the initial geometry of the H<sub>2</sub>O molecule.

This is in fact a general phenomenon: any physical observable we compute depends on the geometry, because the geometry (i.e. the positions of the nuclei) enters the KS Hamiltonian as a parameter that we hold fixed when solving the TISE. 

### What geometry gives us the best estimate of ground state physical observables?

First, the chosen geometry must be physically reasonable. If we generate a structure with overlapping atomic positions, the interatomic forces will be extremely large, the SCF procedure may fail to converge, and the structure will effectively "explode" during optimisation. Typically, a sensible starting guess for a particular material might be atomic positions that we obtain from a database of known crystal structures.

Now, recall that the approximate ground state total energy $E_T^{\prime}$ defines a **potential energy surface** (PES) over the $3N_{\text{nuc}}$-dimensional space of nuclear coordinates. Choosing an initial geometry means selecting a point on this surface. The **optimum geometry with respect to this initial configuration** is the one which minimises the PES in its local neighbourhood. 

Numerically, this is achieved through **geometry optimisation**, an iterative procedure explained in more detail in the quantum mechanics [notes](../../). Provided that

1. each SCF cycle converges reliably at every geometric step, and
2. the force tolerance for the optimisation is chosen appropriately,

we can state with confidence that the physical observables extracted from the optimised geometry are representative of the ground state, within the limits of the numerical tolerances that we set.

Our **first task** in this tutorial is therefore to obtain the optimised geometry of crystalline Si-diamond.

Note that geometry optimisation involves two nested loops:
- Outer loop: calculates interatomic forces, update atomic positions.
- Inner loop: SCF procedure to determine the converged electronic ground state for the fixed geometry.

### What physical observables will we extract?

So far, we have studied both the electronic ground state wavefunctions and density. In this tutorial, we will extract and visualise the ground state **band structure**. While in principle one could examine the band structure at every geometric step, **we are typically interested in the band structure of the final, optimised geometry**.

In the formalism of density functional theory (DFT), the band structure is obtained from the eigenvalues of the KS equations. The many electron wavefunction is represented in terms of one-electron KS orbitals, each expanded in a plane-wave basis. Each KS state is labelled by:

- a band index $n$, and
- a wavevector $\mathbf{k}$ in the Brillouin zone (BZ).

If we consider a calculation with $M$ **bands** (with $M > N_e$) and $\text{NKPT}$ sampled $\mathbf{k}$-points, then at each SCF iteration we must solve $M \times $\text{NKPT}$ KS equations - one for each pair ($n,\mathbf{k}$).

The band structure is built from the corresponding eigenvalues $\epsilon_{n,\mathbf{k}}$. These allow us to determine:
- whether the system is **metallic**, **semiconducting**, or **insulating**,
- the character of chemical bonding (e.g. degree of **covalency**, **ionicity**, or **orbital hybridisation**),
- and, by summing over available states at each energy, the **density of states** (DOS):
```math
g(E) = \sum_{n,\mathbf{k}} \delta(E - \epsilon_{n,\mathbf{k}})
```

As an example, we will extract and visualise both the band structure and density of states of crystalline Si-diamond in the **second** part of this tutorial.

### How can we quantify the accuracy of our results?

When we choose the numerical tolerances on the change in the total energy from one SCF step to the next, or impose a maximum allowed force component on the atoms during geometry optimisation, we are setting the *precision* of the numerical algorithms (i.e. how tightly the SCF and geometry optimisation loops are converged). These tolerances control the stability and reliability of the iterative procedures, but **they do not determine the physical accuracy of the final result**.

To quantify the **accuracy**, we must perform **convergence studies** of the physical observables we intend to extract (for example, the ground state total energy, forces, stresses, band energies). These observables must be shown to be independent -- within a chosen tolerance -- of the numerical parameters that determine the accuracy. Fundamentally, the **accuracy** determines how close the result is to the *true* ground state within the chosen theoretical model (e.g. DFT and choice of XC functional). In practice, two parameters dominate:

- Energy cutoff $E_{\text{cut}}$ of the plane-wave basis (for each KS orbital), which controls the *completeness* of the plane-wave basis and the achievable spatial resolution. Increasing $E_{\text{cut}}$:
  - increases the number of plane waves, improving the completeness of the basis;
  - systematically lowers the variational error in the total energy and forces;
  - improves the representation of rapidly varying quantities (e.g. energy levels near ionic cores).
 
  The required cutoff depends strongly on the pseudopotential.

  Recall, the definition of $E_{\text{cut}}$:
```math
\frac{\hbar^2}{2m} {|\mathbf{k} + \mathbf{G}|}^2 < E_{\text{cut}}.
```

- $\mathbf{k}$-point sampling cutoff in the BZ
  - The accuracy of the electron density depends on a sum over $\mathbf{k}$-points (see below). The higher the density, the more accurate the calculation (with respect to the theoretical description).
  - **Metals** require significantly denser $\mathbf{k}$-point sampling because of the presence of a Fermi surface.
  - **Insulators** and **wide-gap semiconductors** converge much more rapidly.
  
  Recall, the electron density is obtained from a sum over $\mathbf{k}$-points
```math
n_0^{\prime}(\mathbf{r}) = \sum_{\mathbf{k} \in \text{BZ}}^{\text{NKPT}} \sum_n^M f_{n,\mathbf{k}} {|\phi_{n,\mathbf{k}}(\mathbf{r})|}^2
```

We will explore the convergence of the ground state total energy and band structure with respect to the aforementioned cutoffs in the **final** part of this tutorial.

Keep in mind, although the plane-wave cutoff and $\mathbf{k}$-point grid are the dominant parameters governing accuracy, the **choice of exchange correlation functional and pseudopotential** introduces a *systematic* error that cannot be eliminated by convergence tests.

### Outline of the tutorial

- Let's see what files we have:
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
