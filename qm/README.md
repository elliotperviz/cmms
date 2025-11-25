# Quantum Mechanics - Ground state solution of the TISE

## Tutorial Outline

1) [H<sub>2</sub> molecule: electronic properties](1-h2/)
2) [H atom: electronic orbitals](2-h/)
3) [H<sub>2</sub>O molecule: importance of geometry and the exchange correlation functional](3-h20/)
4) [Diamond Si: geometry optimisation, band structure, convergence studies](4-si/)

Note, it is not the aim of the tutorials to teach you what is the definition of every keyword we use in the Abinit inputs. The goal is to show you practical examples for how to setup Abinit simulations and how to extract and analyse physical properties. With this in mind, we recommend that whilst working through these tutorials you consult the Abinit documentation for a detailed definitions and descriptions of each keyword:<br>
https://docs.abinit.org/variables/

## Introduction

In quantum mechanics, the state of the system is no longer described by the precise position and momentum of a particle (or particles) but by the *wavefunction* $\Psi(\mathbf{r}_N,t)$: a probability amplitude defined over all possible configurations of $N$ particles, i.e. $\mathbf{r}_N$ represents the $3N$-dimensional configuration space:
```math
(\mathbf{r}_1, \mathbf{r}_2, \dotsc, \mathbf{r}_N) \in \mathbb{R}^3.
```
Note that, in the model system we are considering, the "particles" are nuclei and electrons.

Now, $\Psi(\mathbf{r}_N,t)$ varies with respect to position and time, where time evolution is governed by the *time-dependent* Schrödinger equation (TDSE): 
```math
i\hbar\frac{\partial \Psi(\mathbf{r}_N,t)}{\partial t} = \hat{H}(\mathbf{r}_N,t)\Psi(\mathbf{r}_N,t).
```

However, if we suppose that the Hamiltonian $\hat{H}(\mathbf{r}_N)$ is independent of time, then the total energy of the system is a conserved quantity and the wavefunction may be separated between space and time components $\Psi(\mathbf{r}_N,t)=\psi(\mathbf{r}_N)\chi(t)$ and solved independently. Focusing on the **ground state solution** $\psi(\mathbf{r}_N)$ of the time-independent part, we arrive (skipping the derivation) at the *time-independent* Schrödinger equation (TISE):

```math
H(\mathbf{r})\psi(\mathbf{r}_N) = E_0\psi(\mathbf{r}_N)
```
where $E_0$ is the ground state total energy, itself defined as the expectation value of the Hamiltonian:
```math
E_0 = \int \psi^*(\mathbf{r}_N) \hat{H} \psi(\mathbf{r}_N) \mathrm{d}\mathbf{r}_N
```

It is useful also to consider the linear expansion of the Hamiltonian into its component kinetic ($\hat{T}$) and potential ($\hat{V}$) operators:
```math
\hat{H}(\mathbf{r}_N) = \hat{T}_e + \hat{T}_n + \hat{V}_{en} + \hat{V}_{ee} + \hat{V}_{nn}
```
where $\hat{T}\_e$ and $\hat{T}\_n$ are the electron and nuclei kinetic operators; $\hat{V}\_{en}$, $\hat{V}\_{ee}$ and $\hat{V}\_{nn}$ are the Coulombic potential operators for the electron-nucleus, electron-electron and nucleus-nucleus interactions respectively.

Now, with the above description, provided we know the solution $\psi(\mathbf{r_N})$ and we are able to write analytically all the terms in $\hat{H}(\mathbf{r_N})$, we can compute $E_0$. Unfortunately, an analytical solution to the TISE exists only for the hydrogen atom (one proton and one electron). Therefore for any practical scenario in materials science, we can only obtain approximate solutions via numerical methods.

Before thinking about the numerical implementation, we will first simplify the problem: We introduce the Born-Oppenheimer (BO) approximation, which assumes that electrons react instantaneously to changes in nucleon position due to the large mass difference between a nucleon and an electron. In other words, we are able to follow a so-called "semi-classical" approach: classical "point-like" atoms and quantum electrons. Focusing on the quantum part, we set the kinetic energy of the nuclei to 0 by the definition of the BO approximation, and neglect (for now) the Coloumic nucleus-nucleus interaction, which allows us to define a simplified *electronic* hamiltonian
```math
\hat{H}_e(\mathbf{r}_{N_e}) = \hat{T}_e + \hat{V}_{en} + \hat{V}_{ee}
```
and hence arrive at the *electronic* TISE:
```math
\hat{H}_e(\mathbf{r}_{N_e}) \psi_e(\mathbf{r}_{N_e}) = E_e(\mathbf{r}_{N_e}) \psi_e(\mathbf{r}_{N_e})
```
where $\psi_e(\mathbf{r}_{N_e})$ is the ground state *electronic* wavefunction existing now only in $3N_e$-dimensional configuration space. The corresponding ground state *electronic* total energy is written as
```math
E_e = \int \psi_e^*(\mathbf{r}_{N_e})\hat{H}_e\psi_e(\mathbf{r}_{N_e}) \mathrm{d}\mathbf{r}_{N_e}
```

The electronic TISE provides us with the exact electronic ground state energy $E_e$, provided that we know the *exact* solution $\psi_e(\mathbf{r}\_{N_e})$. However, as mentioned earlier, we know this is not the case for any material we might be interested in. Thus, we must sadly abandon the exact description in favour of an approximate solution $\psi_e^{\prime}(\mathbf{r}_{N_e})$, known as the *trial wavefunction*, which we will try to improve iteratively via numerical methods.

Although the physical ground state corresponds to a single eigenfunction of the electronic Hamiltonian, we require a practical way to represent this function when solving the electronic TISE numerically. A standard approach is to expand the trial wavefunction in a chosen set of functions $`\{ \phi_n(\mathbf{r}_{N_e}) \}`$, collectively called the *basis*, such that
```math
\psi_e^{\prime}(\mathbf{r}_{N_e}) = \sum_n c_n \phi_n(\mathbf{r}_{N_e})
```
where $c_n$ are the complex coefficients of each function in the basis.

We can then introduce $E_e^{\prime}$ as the "trial" ground state electronic total energy associated with the trial wavefunction, defined as
```math
E_e^{\prime} = \sum_n {|c_n|}^2 \int \phi_n^*(\mathbf{r}_{N_e}) \hat{H}_e \phi_n(\mathbf{r}_{N_e}) \mathrm{d}\mathbf{r}_{N_e}
```

### The variational theorem

The **variational theorem** states that the trial ground state energy $E_e^{\prime} \geq E_e$ for any choice of $\psi_e^{\prime}(\mathbf{r}_{N_e})$. The equality may only arise when $\psi_e^{\prime}(\mathbf{r}\_{N_e})$ reproduces the exact ground state wavefunction $\psi_e(\mathbf{r}\_{N_e})$. Thus, we may summise that, by following a *variational procedure* we could attempt to minimise $E_e^{\prime}$ by iteratively varying the set of coefficients $`\{c_n\}`$ of the basis.

### Choosing the trial wavefunction

The functions $`\{\phi_n\}`$ form a complete orthonormal basis, so any square integrable wavefunction can be represented to arbitrary accuracy within this expansion. Different choices of basis (such as *plane waves*, *localised Gaussian functions*, or *atomic orbitals*) offer different advantages depending on the physical problem and the numerical method employed. It is always possible *in principle* to transform between bases, but whether or not it is possible numerically depends on the implementation.

### Motivation for Density Functional Theory (DFT)

The many-electron wavefunction exists in a $3N_e$-dimensional configuration space. If we discretise each coordinate (e.g. on a grid) with $M$ points, the total number of points required is $M^{3N_e}$. Even for modest $M = 10^2$ and small $N_e = 10$, $M^{3N_e}$ is astronomically large. For realistic materials, this makes obtaining a numerical solution of the TISE impossible: variationally optimising (and storing) such a high-dimensional object is computationally intractable.

**Density functional theory (DFT)** provides a way around this difficulty:

The *Hohenberg–Kohn existence* theorem establishes that the ground-state electron density
```math
n_0(r) = N_e \int {|\psi_e(\mathbf{r}_{N_e})|}^2 \mathrm{d}\mathbf{r}_{N_e},
``` 
uniquely determines the external potential and hence all ground-state properties of the system.

The *Hohenberg–Kohn variational* theorem further states that the *true* ground state density is the one that minimises the total energy. This establishes a variational principle formulated in terms of the density.

This reformulation drastically reduces the numerical complexity of the ground state problem: representing $n_0(r)$ on a grid of $M$ points per dimension requires only $M^{3}$ points.

### The DFT approach

Recall that, in general, a numerical solution of the TISE requires a tractable representation of the trial wavefunction, typically obtained by expanding it in a basis set with a convenient analytical form (e.g. plane waves, gaussians, atomic orbitals, ...).

The Kohn-Sham formulation of DFT follows this general strategy but introduces a crucial conceptual simplification: the interacting many-electron system is mapped onto an auxilliary system of non-interacting electrons, and the trial wavefunction of this auxilliary system is written as a *Slater determinant* of one-electron orbitals $`\{\phi_n\}`$,
```math
\psi_e(\mathbf{r}_{N_e}) = \frac{1}{\sqrt{N_e!}} \det\{\phi_n(\mathbf{r}_n)\}
```

These one-electron orbitals are chosen such that the resulting electron density
```math
n_0(\mathbf{r}) = \sum_n^{N_e} {|\phi_n(\mathbf{r})|}^2
```
**exactly reproduces the ground state electron density of the interacting system**. This mapping is an **exact theorem of DFT**, not an approximation.

Each orbital satisfies a Kohn-Sham (KS) equation,
```math
\hat{H}_{\text{KS}}(\mathbf{r}) \phi_n(\mathbf{r}) = \epsilon_n \phi_n(\mathbf{r}),
```
with eigenvalues $\epsilon_n$, and the KS Hamiltonian is
```math
\hat{H}_{\text{KS}}(\mathbf{r}) = \hat{T}_{\text{ref}} + \hat{V}_{en} + \hat{V}_H + \hat{V}_{\text{XC}}.
```
The terms on the right hand side represent (from left to right):

a) Kinetic energy of the non-interacting auxilliary/reference system,<br>
b) Electron-nuclear potential,<br>
c) Classical electron-electron (Hartree) repulsion,<br>
d) **Exchange-correlation** potential\* , which incorporates quantum many-body effects not captured by the previous terms (more on this later).<br>

In this formulation, the potentials b), c) and d) depend **only** on the ground state electron density $n_0(r)$.

Given an initial guess for the orbitals $`\{\phi_n\}`$, one may therefore follow a **self-consistent field** (SCF) procedure:
1. Construct a density $n_0^{\prime}(\mathbf{r})$ from the current  $`\{\phi_n\}`$,
2. Evaluate $\hat{V}\_{en}$, $\hat{V}\_H$ and $\hat{V}_{\text{XC}}$
3. Construct the updated KS Hamiltonian and solve the KS equations,
4. Repeat until the electron density (or total energy) changes by less than a chosen tolerance

Finally, an expression for the trial ground state electronic total energy $E_e^{\prime}$ may be derived from the above description. The details of the derivation are not necessary for the discussion, so we will simply state the final result in *functional* notation:
```math
E_e^{\prime}[n_0^{\prime}] = \sum_n^{N_e} \int \phi_n^{*}(\mathbf{r}) \hat{T} \phi_n(\mathbf{r}) \mathrm{d}\mathbf{r} + E_{en}[n(\mathbf{r})] + E_H[n(\mathbf{r})] + E_{\text{XC}}[n(\mathbf{r})],
```
where a functional is simply an object that takes a function as input (the density) and returns a number (the total energy), and each component on the RHS represents the expectation value of the corresponding term in the KS Hamiltonian.

### Exchange correlation functional

The exchange-correlation term, $V_{\text{XC}}$, accounts for all the quantum many-body effects that are not captured by the classical Hartree term or the non-interacting kinetic energy. This includes:
- Exchange interactions due to the antisymmetry of the wavefunction (Pauli exclusion principle).
- Correlation effects due to the instantaneous repulsion between electrons beyond the mean field approximation.

Its exact form is **unknown** -- **this is the only fundamental approximation in the DFT formalism**.

Since the analytical form is unknown, practical calculations employ approximate functionals, such as:
- Local Density Approximation (LDA) - assumes that XC energy at each point depends only on the local electron density
- Generalised Gradient Approximation (GGA) - includes the gradient of the local density to better account for inhomogeneity
- Hybrid functionals - essentially a correction to GGA, mix in a portion of more accurate treatment of electron-electron repulsion

These approximations affect *all* computed observables: energies, forces, vibrational properties, band gaps etc., as such the choice of exchange correlation functional is **critical** to the accuracy of our results.

### Solution for (periodic) crystalline materials - The Bloch functions

Previously, we noted that the analytical form of the basis used to expand the electronic wavefunction can be chosen according to the problem at hand. We now consider a physically important class of systems: bulk crystalline solids.

From the point of viewpoint of quantum mechanics, a crystal contains far too many electrons and nuclei to treat explicitly. The key simplification which enables the numerical study (e.g. via simulation) of these materials is the **periodicity of the lattice**. A crystal can be constructed from a basic repeating volume called the unit cell, whose edges are defined by the lattice vectors. These vectors connect abstract lattice points, to each of which we attach a basis of atom(s). Any physical quantity that depends on the atomic arrangement, such as the KS potential, is therefore periodic in space.

Because the KS potential is periodic, the one-electron KS orbitals can be written as *Bloch functions*
```math
\phi_{n,\mathbf{k}}(\mathbf{r}) = u_{n\mathbf{k}}(\mathbf{r}) \exp(i\mathbf{k} \cdot \mathbf{r})
```
where
- $\mathbf{k}$ is a vector in the *reciprocal space* (the crystal momentum),
- $n$ is the band (KS orbital) index.
- $u_{n,\mathbf{k}}(\mathbf{r})$ is periodic with the lattice,
```math
u_{n,\mathbf{k}}(\mathbf{r}) = u_{n,\mathbf{k}}(\mathbf{r} + \mathbf{T}).
```
The periodic part $u_{n,\mathbf{k}}(\mathbf{r})$ may be expanded in a Fourier series of plane waves:
```math
u_{n,\mathbf{k}}(\mathbf{r}) = \sum_{\mathbf{G}} C_{n,\mathbf{k}}(\mathbf{G}) \exp(i\mathbf{G}\cdot\mathbf{r})
```
with $\mathbf{G}$ the reciprocal lattice vectors, and constitutes a plane-wave *basis*. This expansion is formally infinite, however in practice we truncate the plane-wave basis by imposing an **energy cutoff**:
```math
\frac{\hbar^2}{2m}{|\mathbf{k} + \mathbf{G}|}^2 < E_{\text{cut}},
```
retaining only plane waves below this kinetic energy. We do this since only plane waves with low kinetic energy contribute meaningfully to the smooth KS orbitals. To attain better spatial resolution requires increasing $E_{\text{cut}}$, which increases the computational cost as a result. Note that, as a choice of basis, plane waves are particularly convenient for periodic systems because they form an orthonormal basis with coefficients that can be systematically improved, and their computation can be handled efficiently using Fast Fourier Transform Algorithms.

With the Bloch functions defined, the KS equations become
```math
\hat{H}_{\text{KS}}\phi_{n,\mathbf{k}}(\mathbf{r}) = \epsilon_{n,\mathbf{k}}\phi_{n,\mathbf{k}}(\mathbf{r}).
```
where we have a unique equation for each KS state $(n,\mathbf{k})$.

The ground state density is then obtained by summing over all occupied bands (states) and integrating over in reciprocal space:
```math
n_0^{\prime}(\mathbf{r}) = \sum_n^{N_e} \int {|\phi_{n,\mathbf{k}}(\mathbf{r})|}^2 \mathrm{d}\mathbf{k}.
```

The advantage of the periodic description is that any wavevector $\mathbf{k}^{\prime}$ outside the BZ is equivalent to a wavevector $\mathbf{k}$ inside the BZ by translation $\mathbf{k}^{\prime} = \mathbf{k} + \mathbf{G}$. Thus the BZ contains all unique KS solutions, at the cost of an integral over infinitely many $\mathbf{k}$-vectors.

In practice, the BZ integral is replaced by a finite sampling of wavevectors (for example by constructing a grid):
```math
n_0^{\prime}(\mathbf{r}) = \sum_{\mathbf{k}\in\text{BZ}}^{\text{NKPT}} \sum_n^{M} f_{n,\mathbf{k}} {|\phi_{n,\mathbf{k}}(\mathbf{r})|}^2
```
where
- $\text{NKPT}$ is the number of sampled $\mathbf{k}$-points (wavevectors),
- $f_{n,\mathbf{k}}$ are the Fermi-Dirac occupations,
- and in general we can include ($M>N_e$) for both occupied and unoccupied bands.

The number of $\mathbf{k}$-points required depends strongly on the material. In insulators and semiconductors, the electron occupancy changes smoothly with $\mathbf{k}$, so relatively coarse grids converge well. On the other hand, metals require much denser sampling because the occupation varies rapidly with $\mathbf{k}$ close to the Fermi level. This difference has a direct impact on computational cost, since each additional $\mathbf{k}$-point requires solving a separate KS-equation. As an additional comment, note that the symmetries of the crystal can be exploited to reduce the number of required $\mathbf{k}$-points, without affecting accuracy.

To conclude (the DFT part): 
- In a periodic solid, the KS equations must be solved for $M$ bands at each of the $\text{NKPT}$ sampled $\mathbf{k}$-points in the first BZ. Each KS orbital is expressed as a Bloch function expanded in a plane wave basis, truncated at an energy cutoff $E_{\text{cut}}$. The choice of $\text{NKPT}$ and $E_{\text{cut}}$ determines the balance between computational cost and accuracy.
- The KS orbitals are then used to construct the electron density at each SCF iteration. This iterative procedure yields a self-consistent electronic density, obtained under the periodic KS potential of the crystal.

### Geometry optimisation and the Hellmann-Feynmann theorem

After convergence of the SCF cycle, we obtain a trial ground state electronic energy, $E_e^{\prime}[n_0^{\prime}]$, which is our best estimate of the exact ground state electronic energy $E_e$.

The electronic Hamiltonian depends parameterically on the nuclear coordinates $`\{\mathbf{R}_I\}`$ through the electron-nucleus Coulomb potential $V_{en}$. Within the Born-Oppenheimer (BO) approximation, the ground state total enery of the system is obtained by adding the nucleus-nucleus Coulomb energy
```math
E_{nn} = \frac{1}{2} \sum_{I \neq J} \frac{Z_I Z_J}{|\mathbf{R}_I - \mathbf{R}_J|}.
```
This term is purely classical in the BO framework: the nuclear kinetic energy is set to zero, and the nuclei act as fixed point charges. Hence the approximate total energy for a given nuclear configuration is
```math
E_{T}^{\prime} = E_e^{\prime}[n_0^{\prime}(\mathbf{r})] + E_{nn}
```

**Is $E_{T}^{\prime}$ the best possible estimate of the ground state total energy of the system?**

**Answer**: Only for the specific nuclear geometry used to compute it. 

Changing the nuclear positions alters $V_{en}$, which changes the KS Hamiltonian, the converged electronic density, and therefore $E_e^{\prime}$. Moreover, each "move" of the atoms changes $E_{nn}$. Thus one may regard $E_{T}^{\prime}$ as defining a **potential energy surface (PES)** over the $3N_{\text{nuc}}$-dimensional space of nuclear coordinates.

**Geometry optimisation**

Geometry optimisation corresponds to finding a local minimum of this PES. The procedure is as follows:

- Choose a trial nuclear geometry.<br>
  Solve the KS equations to obtain the converged electronic density and energy $E_e^{\prime}$.
- Compute the forces on the nuclei*.<br>
  The force on nucleus $I$ is given by the **Hellman-Feynmann** theorem (when the basis does not depend on the nuclear positions, which is the case when using a plane wave basis set)
```math
\mathbf{F}_I = - \frac{\partial E_T^{\prime}}{\partial \mathbf{R}_I}.
```
- Update the geometry.<br>
  In principle, this uses the Hessian (2nd derivative matrix) of the PES to determine the next geometry configuration (although explicit evaluation of the Hessian is expensive, practical geometry optimisation uses quasi-Newton methods which build an approximate Hessian iteratively)
```math
H_{I,J}^{\alpha \beta} = \frac{\partial^2 E_{T}^{\prime}}{\partial R_I^{\alpha} \partial R_J^{\beta}}
```
- Repeat steps 1-3 until the forces on each atom fall below a chosen tolerance.<br>
  The resulting geometry is taken as the optimised configuration corresponding to the chosen initial structure.

\* Note that, when using localised atomic basis sets an additional **Pulay force** must be included, because the basis set changes with the geometry.


<!--

### Practical considerations

- Choice of pseudopotential
- Choice of exchange correlation functional
- Plane wave cutoff convergence
- K-point mesh convergence
- NBANDS - Abinit fills electronic states by counting valence electrons in pseudopotential file and occupying lowest levels (initial guess to the ground state)

### Extensions 
Briefly mention excited state DFT, spin-polarised DFT (i.e. brief high-level overview)

### Comparison to MD
 
- Comparison of computational complexity of MD vs DFT (e.g. scaling with number of atoms)
-->

## Abinit

In these tutorials we will use the software Abinit, which implements the numerical solution to the quantum equations of density functional theory using a plane-wave basis-set approach.

Required input files:
- Pseudopotential file(s)
- Abinit input (configuration) file
  In a basic setup, we must provide at least the following information to Abinit via the input file:
  - Initial structure
  - Name(s) of the provided pseudopotential file(s)
  - Choice of exchange correlation functional
  - Plane wave cutoff
  - K-point grid/path
  - Definition of the SCF procedure
<!-- - Optional: parallelisation -->

Note on units: Abinit uses Hartree, 1 Ha = $\hbar^2/(m_e r_0^2)$ \approx 27.21 eV$ $\approx$ total energy of the H atom in its ground state determined via the Bohr model.

During a self-consistent field (SCF) calculation, **Abinit** generates several output files. Aside from the log files, printed to the standard output (e.g. the terminal) or the more compact log written in `ab.abo`, they share the common prefix `abo_`, followed by a string which identifies what each output file contains. For a standard SCF calculation, we generally obtain the following output files:

| File | Description |
|------|--------------|
| **`standard output`** | Technically not a file, this is the main **output log** which writes detailed information about the progress of the simulation to the terminal in real time, it contains:: input parameters, SCF iteration history, total energies, forces, stress (if computed), symmetry operations, and timing. |
| **`ab.abo`** | A **compact progress log**. Useful for checking convergence of the SCF procedure (e.g., via `tail -f`). Contains minimal information compared to the `standard output`. |
| **`abo_DEN`** | The **ground-state electron density** written at the end of an SCF procedure. Required for non-SCF or post-processing runs (e.g., density analysis, potential plotting, or restart of further calculations). |
| **`abo_WFK`** | The **Kohn–Sham wavefunction file**, containing the converged wavefunctions for all k-points and bands. Needed for subsequent steps such as non-SCF runs, band structure, or density-of-states calculations. |
| **`abo_EIG`** | Text file listing **eigenvalues of the electronic states** at each k-point. |
| **`abo_EIG.nc`** | NetCDF version of the eigenvalues file. Compact and machine-readable; preferred for use with post-processing tools like `anaddb` or `abipy`. |
| **`abo_GSR.nc`** | The **ground-state results file** in NetCDF format. Contains key quantities (total energy, Fermi level, lattice vectors, k-points, occupations, etc.) in a standardised structure for interoperability. |
| **`abo_OUT.nc`** | A general **NetCDF summary of the entire SCF run**, including energies, densities, and wavefunction metadata. Often used for automated parsing or visualisation. |
| **`abo_DDB`** | The **Derivative DataBase** file, generated only if perturbations are computed (e.g., phonons). For a simple SCF run, this file is not important (and may be absent). |
| **`abo_EBANDS.agr`** | Band structure output formatted for **xmgrace** plotting. Not produced in a standard SCF run — appears only when band structure analysis is explicitly requested. |

The files ending in `.nc` are in the compressed **NetCDF** format. This format is highly efficient for storing large datasets, such as wavefunctions, densities, and eigenvalues, which can become very large during extended or high-precision runs. NetCDF files are also **self-describing**, meaning that each file includes metadata about its contents (units, dimensions, variable names, etc.), which allows for straightforward parsing and analysis without manual interpretation. Moreover, the NetCDF standard enables **direct interoperability** with post-processing tools such as `Abipy`, `Phonopy`, and various Python-based data analysis libraries, facilitating automated data extraction, plotting, and workflow integration.

Despite this, as you may already have found as we worked through our Molecular Dynamics tutorials, we will generally parse the outputs directly using commands in the terminal. We discuss why we prefer this approach on the course home page, but to recap, it is for two reasons:
a) to not treat the simulation output as a black box,
b) and since the file sizes we obtain in the tutorials are not very large, direct parsing is still feasible.

## Workflow of a standard ground state DFT calculation

### Initialisation

- Define the crystal structure
- Set simulation parameters

### Initial scf

- Check initial geometry and input parameters are reasonable, and at least that there are no errors in the simulation setup

### Convergence studies (total energy, k-point mesh)

### Relaxation (geometry optimisation)

- Compare optimised geometry against literature, e.g. extract the radial distribution function

**Extract and analyse physical properties**
- Forces
- Stress
- Radial distribution function
- Bond lengths
- Bond angles
- Coordination number

**Other derived material properties**
- Elastic constants
- Bulk/shear/Young's modulus etc.

### High resolution SCF (dense k-point mesh)

### Non-scf (static) calculation

- Static = no update of the orbitals / charge density
  
**Extract and analyse physical properties**

- Energetics: total energy, formation energy etc.
- Electronic properties: DOS, band structure, charge density, electronic localisation, charge polarisation, charge dipole moment
- Magnetic properties: spin polarisation, magnetic moment
