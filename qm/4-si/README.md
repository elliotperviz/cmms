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

<!-- In class, this tutorial is parallel with the lecture introducing the decription of the crystal lattice, reciprocal space etc. Before continuing with the main tutorial, we should demonstrate the usage of the Materials project database of known crystal structures, show their different shapes and symmetries, how we can transform between primitive and conventional descriptions etc. -->

- Let's see what files we have:
  ```bash
  perviell@postel:4-si$ ls
  README.md  1-geo-opt  2-bs  3-ecut  4-kpt
  ```
  You should see 4 folders (and one README file, which you are currently reading here), which separates the different parts of the tutorial to follow.

## 1. Geometry optimisation

Our first task is to optimise the geometry of the *primitive* cell of crystalline Si.

- Navigate to the appropriate directory
  ```bash
  cd 1-geo-opt
  ```

- Inspect the contents of the directory
  ```bash
  perviell@postel:4-si$ ls
  BPOSCAR.vasp  PPOSCAR.vasp  ab.in  si.psp8
  ```
  As usual, we provide the required Abinit input file "ab.in" and the Si pseudopotential file "si.psp8". We also provide the primitive ("PPOSCAR.vasp") and conventional ("BPOSCAR.vasp") cell configurations of diamond-Si, for easy visualisation with `vesta`.
 
- Inspect the Abinit input file with `vim`/`less`/`cat`, check that you understand the meaning of each keyword that we use. In particular, look at the keywords associated with dataset 2, and make sure you understand how they relate to geometry optimisation.<br>
  If you don't recognise a keyword, remember to **consult the Abinit documentation**.

**Objectives**

- Run Abinit
  ```bash
  abinit ab.in
  ```
  And follow the standard output (what is printed to the terminal) as the simulation is executed.

  Once the simulation concludes, we should find output files related to datasets 1 and 2 in our working directory.

- Check that the maximum force component on the atoms is smaller than the chosen tolerance<br>
  Hint: Look for the string "Cartesian forces" at the end of each geometric step in "ab.abo" or the standard output.

- Check that each SCF procedure converges within the maximum number of steps specified<br>
  Hint: use `grep`... or inspect the file e.g. with `vim`, or you could try the following `awk` command:
  ```bash
  awk '/ETOT/ {
    if ($2 == 1 && NR > 1) print "";
    print
  }' ab.abo
  ```

<!-- In the future, it would be useful to have Abipy installed, since we would be able to extract the geometry at each geometric step, and visualise the "trajectories" e.g. in Ovito -->

## Band structure

**TBC**
