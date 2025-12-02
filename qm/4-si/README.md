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

If we consider a calculation with $M$ **bands** (with $M > N_e$) and $\text{NKPT}$ sampled $\mathbf{k}$-points, then at each SCF iteration we must solve $M \times \text{NKPT}$ KS equations - one for each pair ($n,\mathbf{k}$).

The band structure is built from the corresponding eigenvalues $\epsilon_{n,\mathbf{k}}$. These allow us to determine:
- whether the system is **metallic**, **semiconducting**, or **insulating**,
- the character of chemical bonding (e.g. degree of **covalency**, **ionicity**, or **orbital hybridisation**),
- and, by summing over available states at each energy, the **density of states** (DOS):
```math
g(E) = \sum_{n,\mathbf{k}} \delta(E - \epsilon_{n,\mathbf{k}})
```

When we consider occupied and unoccupied states, it is useful to consider the following definitions from solid state physics:
- Fermi energy $E_F =$ the energy of the highest occupied state at 0K.
- Fermi level $\mu =$ the chemical potential for electrons, the energy at which the probability of occupancy is 50% at a given temperature $T$.<br>
  At $T=0$ K, $E_F$ and $\mu$ coincide. At finite temperature, $\mu(T)$ can shift slightly due to thermal excitation.
- Band gap $E_G =$ the difference in energy between the lowest unoccupied state, the **conduction band minimum** (CBM), and the highest occupied state, the **valence band maximum** (VBM)
  - In a metal, $E_G = 0$.
  - In a direct semiconductor, like monolayer MoS<sub>2</sub>, the VBM and CBM occur at the *same* $\mathbf{k}$-point.
  - In an indirect semiconductor like Si, the VBM and CBM occur at *different* $\mathbf{k}$-points.
  - The mathematical definition is
```math
E_G = E_{\text{CBM}} - E_{\text{VBM}}
```

Note: What is the difference between $E_{\text{VBM}}$ and $E_F$?
- $E_{\text{VBM}}$ is specifically the top of the valence band.
- $E_F$ is the Fermi energy of Fermi level (since we are performing calculations in the ground state, these quantities coincide, as described above).
- So, $E_{\text{VBM}}$ and $E_F$ are different names for the same quantity, and $\mu$ only coincides when $T=0$ K.

We often report the *Fermi level* as the energy separating occupied and unoccupied states in a system with a fixed number of electrons, which is used as a reference to "zero" the energy when plotting the DOS and band structure.

Further, by convention we extract the so-called *high-symmetry* points when plotting and analysing the band structure.

**High symmetry points**
- are points where crystal symmetry is highest,
- reflect important crystallographic directions,
- often correspond to extrema in the band structure,
- are dependent on the symmetry of the crystal,
- and exhibit phenomena (such as crossings, degeneracies, symmetry protected states, variation of effective mass) which are often only visible along high-symmetry paths,
- provide a standarised procedure to sample the Brillouin Zone, allowing for direct comparison of band structure between different computations of the same structure.

The conventional high-symmetry paths that we follow, which depends on the symmetries of the crystal, are given [here](https://doi.org/10.1016/j.commatsci.2010.05.010).

We will extract and visualise both the band structure and density of states of crystalline Si-diamond in the **second** part of this tutorial.

As a further example, we will also extract the **electron localisation function** (ELF):  the ELF is the dimensionless scalar field from $0 \rightarrow 1$, giving the probability to find electrons *localised* within a given region of space:
- $\approx 1$ - high localisation e.g. electron pairs in covalent bonds, or core electrons close to the nucleus.
- $\approx 0.5$ - electron gas-like delocalisation.
- $\approx 0$ - fully delocalised (conduction band electrons).

e.g. Al is metallic, and will have low electron localisation. Si is a semiconductor and has distinct bonding, which is evident in the ELF.

ELF is quite similar to the electron density, however their definitions are separate physical meanings:
- The electron density is the total number of electrons per unit volume, which includes both localised and delocalised electrons without distinguishing their role. It tells us **where the electrons are**.
- The ELF tells us *how localised the electrons are*, giving us information about the parts of the band structure that different regions of the electron density are participating in.

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
  perviell@postel:1-geo-opt$ ls
  BPOSCAR.vasp  PPOSCAR.vasp  ab.in  si.psp8
  ```
  As usual, we provide the required Abinit input file "ab.in" and the Si pseudopotential file "si.psp8". We also provide the primitive ("PPOSCAR.vasp") and conventional ("BPOSCAR.vasp") cell configurations of diamond-Si, for easy visualisation with `vesta`.
 
- Inspect the Abinit input file with `vim`/`less`/`cat`, check that you understand the meaning of each keyword that we use.<br>
  Look at the keywords associated with dataset 2:
  - `optcell`
  - `ionmov`
  - `ntime`
  - `tolmxf`

  and make sure you understand how they relate to geometry optimisation. In particular, note that we allow Abinit to optimise *both* the atomic positions and lattice vectors via `optcell`. When we perform lattice vector relaxation, `tolmxf` also sets the tolerance on cell stress, which is treated like force via a scaling factor `strfact` (check the default value that Abinit sets).<br>
  Remember, for the full definition of new keywords we can always **consult the Abinit documentation** for reference.

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

## 2. Band structure

Next, we will extract and visualise the band structure (energy eigenvalues of the solutions to the Kohn-Sham equations).

- Navigate to the appropriate directory
  ```bash
  cd ../2-bs
  ```

- Inspect the contents of the directory
  ```bash
  perviell@postel:2-bs$ ls
  ab.in plot_dos.gp si.psp8
  ```
  As usual, we provide the required Abinit input file "ab.in" and the Si pseudopotential file "si.psp8".
 
- Inspect the Abinit input file with `vim`/`less`/`cat`, check that you understand the meaning of each keyword that we use.<br>
  Note:
  - The keywords defining `rprim` and `xred` are empty - we first need to copy the optimised primitive vectors and atomic positions from the previous step.
  - In dataset 1 we perform an initial SCF calculation on the optimised geometry.
  - In datasets 2 and 3 we perform two non-SCF runs: one to calculate and print the atom-projected, orbital decomposed DOS; and another to calculate and print the band structure.
  Check the meaning of the different keywords required, depending on whether we want to extract the DOS or the band structure.

**Objectives**

- Insert the optimised lattice vectors and atomic positions<br>
  Hint: check the output of the previous geometry optimisation run.

- Run Abinit
  ```bash
  abinit ab.in
  ```
  And follow the standard output (what is printed to the terminal) as the simulation is executed.

  Once the simulation concludes, we should find output files related to datasets 1,2 and 3 in our working directory.

- Visualise the band structure using `xmgrace`

  ```bash
  xmgrace abo_DS3_EBANDS.agr
  ```

  You should see that the energy (y-axis) is in eV. Internally, Abinit uses Ha (Hartree) for energy, but the .agr script (which is a default output provided by Abinit) automatically performs the unit conversion.

  Another useful feature of this script is that the Fermi level is pre-subtracted from the energy eigenvalues, such that the Fermi level lies at 0 eV. This allows us to see immediately whether the Fermi level coincides with a real state and to understand the electronic nature of the material (conducting, semi-conducting, insulating etc.).

  We can further customise the visualisation to add relevant labels. In the `xmgrace` window:
  - Navigate via the tasbar to the "Axes" window<br>
    Plot -> Axis properties
  - In the "Axes" window, click "Special"<br>
    You may proceed to add labels for the specific k-points that we chose to sample in the BZ.<br>
    The gamma symbol may be entered via the string `\xG`

- Visualise the density of states

  

**Questions**

- What is the size of the band gap (if any)? Is the system conducting, semi-conducting, or insulating?
- If the system is insulating/semi-conducting At which $\mathbf{k}$-points are the locations of the **valence band maximum** (VBM) and **conduction band minimum**?
- How do the above results compare to experimental literature?

DOS

```bash
efermi=`grep Fermi abo_DS2_DOS_TOTAL | awk '{print $5}'`
cp abo_DS2_DOS_TOTAL DOS_TOTAL
# remove header from DOS_TOTAL
awk -v ef=$efermi '{printf("%.5f %.4f %.4f \n", ($1-ef)*27.114, $2, $3)}' DOS_TOTAL > DOS_TOTAL_SHIFTED
```
and plot...

for better formatting we also provide a script "plot_dos.gp", gnuplot -> load plot_dos.gp

Comments: for smoother DOS profile, need to sample more k-points...

Atom-projcted DOS: plot each file with gnuplot
-> show contribution of each orbital
-> demonstrate that we can combine different columns in gnuplot ... e.g.
```bash
gnuplot
plot "..." u1:($2+$3+$4) ...
```

ELF

cut3d

abo_DS2_ELF -> .xsf
option 9
plot in vesta
show isosurfaces and/or lattice planes


