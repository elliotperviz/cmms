# Quantum Mechanics - Ground state solution of the TISE

## Tutorial Outline

1) [H<sub>2</sub> molecule: electronic properties](1-h2/)
2) [H atom: electronic orbitals](2-h/)
3) [H<sub>2</sub>O molecule](3-h20/)

Note, it is not the aim of this tutorial material to teach you what is the definition of every keyword we use in the Abinit inputs. The goal is to show you practical examples for how to setup Abinit simulations and how to extract and analyse physical properties. With this in mind, we recommend that whilst working through these tutorials you consult the Abinit documentation for a detailed definitions and descriptions of each keyword:<br>
https://docs.abinit.org/variables/

## Introduction

In quantum mechanics, the state of the system is no longer described by the precise position and momentum of a particle (or particles) but by the *wavefunction* $\Psi(\mathbf{r_N},t)$: a probability amplitude defined over all possible configurations of $N$ particles, i.e. $\mathbf{r_N}$ represents the $3N$-dimensional configuration space:
```math
(\mathbf{r}_1, \mathbf{r}_2, \dotsc, \mathbf{r}_N) \in \mathbb{R}^3.
```
Note that, in the model system we are considering, the "particles" are protons and electrons.

Now, $\Psi(\mathbf{r_N},t)$ varies with respect to position and time, where time evolution is governed by the *time-dependent* Schrödinger equation (TDSE): 
```math
i\hbar\frac{\partial \Psi(\mathbf{r_N},t)}{\partial t} = \hat{H}(\mathbf{r_N},t)\Psi(\mathbf{r_N},t).
```

However, if we suppose that the Hamiltonian $\hat{H}(\mathbf{r})$ is independent of time, then the total energy of the system is a conserved quantity and the wavefunction may be separated between space and time components $\Psi(\mathbf{r},t)=\psi(\mathbf{r})\chi(t)$ and solved independently. Focusing on the **ground state solution** $\psi(\mathbf{r})$ of the time-independent part, we arrive (skipping the derivation) at the *time-independent* Schrödinger equation (TISE):

```math
H(\mathbf{r})\psi(\mathbf{r_N}) = E_0\psi(\mathbf{r_N})
```
where $E_0$ is the ground state total energy, itself defined as the expectation value of the Hamiltonian:
```math
E_0 = \int \psi^*(\mathbf{r_N}) \hat{H} \psi(\mathbf{r_N}) \mathbf{r_N}
```

It is useful also to consider the linear expansion of the Hamiltonian into its component kinetic ($\hat{T}$) and potential ($\hat{V}$) operators:
```math
\hat{H}(\mathbf{r_N}) = \hat{T}_e + \hat{T}_n + \hat{V}_{en} + \hat{V}_{ee} + \hat{V}_{nn}
```
where $\hat{T}\_e$ and $\hat{T}\_n$ are the electron and nuclei kinetic operators; $\hat{V}\_{en}$, $\hat{V}\_{ee}$ and $\hat{V}\_{nn}$ are the Coulombic potential operators for the electron-nucleus, electron-electron and nucleus-nucleus interactions respectively.

Now, with the above description, provided we know the solution $\psi(\mathbf{r_N})$ and we are able to write analytically all the terms in $\hat{H}(\mathbf{r_N})$, we can compute $E_0$. Unfortunately, an analytical solution to the TISE exists only for the hydrogen atom (one proton and one electron). Therefore for any practical scenario in materials science, we can only obtain approximate solutions via numerical methods.

Before thinking about the numerical implementation, we will first simplify the problem: We introduce the Born-Oppenheimer (BO) approximation, which assumes that electrons react instantaneously to changes in nucleon position due to the large mass difference between a nucleon and an electron. In other words, we are able to follow a so-called "semi-classical" approach: classical "point-like" atoms and quantum electrons. Focusing on the quantum part, we may neglect purely nuclear contributions in the Hamiltonian to give
```math
\hat{H}_{\text{BO}}(\mathbf{r}_{N_e}) = \hat{T}_e + \hat{V}_{en} + \hat{V}_{ee}
```
and hence arrive at the *electronic* TISE:
```math
\hat{H}_e(\mathbf{r}_{N_e}) \psi_e(\mathbf{r}_{N_e}) = E_e(\mathbf{r}_{N_e}) \psi_e(\mathbf{r}_{N_e})
```
where $\psi_e(\mathbf{r}_{N_e})$ is the ground state *electronic* wavefunction existing now only in $3N_e$-dimensional configuration space. The corresponding ground state *electronic* total energy is written as
```math
E_e = \int \psi_e^*(\mathbf{r}_{N_e})\hat{H}_e\psi_e(\mathbf{r}_{N_e}) d\mathbf{r}_{N_e}
```

The TISE provides us with the exact electronic ground state energy $E_e$, provided that we know the *exact* solution $\psi_e(\mathbf{r}\_{N_e})$. However, as mentioned earlier, we know this is not the case for any material we might be interested in. Thus, we must sadly abandon the exact description in favour of an approximate solution $\psi_e^{\prime}(\mathbf{r}_{N_e})$, known as the *trial wavefunction*, which we will try to improve iteratively via numerical methods.

### The variational theorem

Although the physical ground state corresponds to a single eigenfunction of the electronic Hamiltonian, we require a practical way to represent this function when solving the electronic TISE numerically. A standard approach is to expand the trial wavefunction in a chosen set of functions $`\{ \phi_n(\mathbf{r}_{N_e}) \}`$, collectively called the *basis*, such that
```math
\psi_e^{\prime}(\mathbf{r}_{N_e}) = \sum_n c_n \phi_n(\mathbf{r}_{N_e})$
```
where $c_n$ are the complex coefficients of each function in the basis.

We can then introduce $E_e^{\prime}$ as the "trial" ground state energy associated with the trial wavefunction, defined as
```math
E_e^{\prime} = \sum_n {|c_n|}^2 \int \phi_n^*(\mathbf{r}_{N_e}) \hat{H_e} \phi_n(\mathbf{r}_{N_e}) d\mathbf{r}_{N_e}
``` 

Now, the **variational theorem** states that the trial ground state energy $E_e^{\prime} \geq E_e$ for any choice of $\psi_e^{\prime}(\mathbf{r}_{N_e})$. The equality may only arise when $\psi_e^{\prime}(\mathbf{r}\_{N_e})$ reproduces the exact ground state wavefunction $\psi_e(\mathbf{r}\_{N_e})$. Thus, we may summise that, by following a *variational procedure*, we could attempt to minimise $E_e^{\prime}$ by iteratively varying the parameters $c_n$ of the basis.

### Choosing the trial wavefunction

The functions $`\{\phi_n\}`$ form a complete orthonormal basis, so any square integrable wavefunction can be represented to arbitrary accuracy within this expansion. Different choices of basis (such as *plane waves*, *localised Gaussian functions*, or *atomic orbitals*) offer different advantages depending on the physical problem and the numerical method employed, and it is always possible to transform between bases when convenient.

### Motivation for Density Functional Theory (DFT)

The many-electron wavefunction exists in a $3N_e$-dimensional configuration space. If we discretise each coordinate (e.g. on a grid) with $M$ points, the total number of points required is $M^{3N_e}$. Even for modest $M = 10^2$ and small $N_e = 10$, $M^{3N_e}$ is astronomically large. For realistic materials, this makes obtaining a numerical solution of the TISE impossible: variationally optimising (and storing) such a high-dimensional object is computationally intractable.

**Density functional theory (DFT)** provides a way around this difficulty:

The *Hohenberg–Kohn existence* theorem establishes that the ground-state electron density
```math
n(r) = N_e \int |\psi_e(\mathbf{r}_{N_e})| d\mathbf{r}_{N_e},
``` 
uniquely determines the external potential and hence all ground-state properties of the system.

The *Hohenberg–Kohn variational* theorem further states that the *true* ground state density is the one that minimises the total energy. This establishes a variational principle formulated in terms of the density.

This reformulation drastically reduces the numerical complexity of the ground state problem: representing $n(r)$ on a grid of $M$ points per dimension requires only $M^{3}$ points.

### The DFT approach

DFT Hamiltonian, one-electron KS eigenfunctions, exchange correlation functional

### What is the iterative procedure to improve our guess for the electronic wavefunction? (SCF cycle)


- We use the software Abinit, which implements the numerical/computational solution to the above question by implementation of the quantum equations of density functional theory using a plane-wave basis-set approach.
  - plane wave basis
  - HK existence theorem
  - Exchange correlation functional
  - HK variational theorem
  - SCF cycle, solve for the ground state only
 
- Comparison of computational complexity of MD vs DFT (e.g. scaling with number of atoms)

- Extension: briefly mention excited state DFT, spin-polarised DFT (i.e. brief high-level overview)

## Abinit

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

**Note on units: Abinit uses Hartree, 1 Ha = hbar^2/(m_e * r_0^2) =approx 27.21 eV =approx total E of H atom in ground state via Bohr model.**

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

Practical considerations **TBC**:
- Choice of pseudopotential
- Choice of exchange correlation functional
- Plane wave cutoff convergence
- K-point mesh convergence
- NBANDS - Abinit fills electronic states by counting valence electrons in pseudopotential file and occupying lowest levels (initial guess to the ground state)
- Parallelisation

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
