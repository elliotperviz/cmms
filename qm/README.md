# Quantum Mechanics - Ground state solution of the TISE

## Tutorial Outline

1) [H<sub>2</sub> molecule: electronic properties](1-h2/)
2) [H atom: electronic orbitals](2-h/)
3) [H<sub>2</sub>O molecule](3-h20/)

Note, it is not the aim of this tutorial material to teach you what is the definition of every keyword we use in the Abinit inputs. The goal is to show you practical examples for how to setup Abinit simulations and how to extract and analyse physical properties. With this in mind, we recommend that whilst working through these tutorials you consult the Abinit documentation for a detailed definitions and descriptions of each keyword:<br>
https://docs.abinit.org/variables/

## Introduction

In quantum mechanics, the state of the system is no longer described by the precise position and momentum of a particle (or particles) but by the *wavefunction* $\Psi(r,t)$: a probability amplitude defined over all space varying with respect to position and time, where time evolution is governed by the *time-dependent* Schrödinger equation (TDSE). 
```math
i\hbar\frac{\partial \Psi}{\partial t} = \hat{H}(r,t)\Psi(r,t)
```

However, if we suppose that the Hamiltonian $\hat{H}(r)$ is independent of time, then the total energy of the system is a conserved quantity and the wavefunction may be separated between space and time components $\Psi(r,t)=\psi(r)\chi(t)$ and solved independently. Focusing on the time-independent part, we obtain the *time-independent* Schrödinger equation (TISE):

```math
H(r,t)\psi(r) = E\psi(r).
```

The Hamiltonian is defined as a sum of kinetic ($\hat{T}$) and potential ($\hat{V}$) operators:
```math
\hat{H}(r) = \hat{T}_e + \hat{T}_n + \hat{V}_{en} + \hat{V}_{ee} + \hat{V}_nn
```
where $\hat{T}_e$ and $\hat{T}_n$ are the electron and nuclei kinetic operators; $\hat{V}_{en}$, $\hat{V}_{ee}$ and $\hat{V}_{nn}$ are the Coulombic potential operators for the electron-nucleus, electron-electron and nucleus-nucleus interactions respectively.

Further, the total energy $E$ is defined as the expectation value of the Hamiltonian:
```math
E = \int \psi^*(r) \hat{H} \psi(r) dr
```

Thus, provided we know the solution $\psi(r)$, and we are able to compute all the terms in $\hat{H}(r)$, we can derive $E$. Unfortunately, an analytical solution to the TISE exists only for the hydrogen atom. Therefore for any practical scenario in materials science, we can only obtain approximate solutions via numerical methods.

Before thinking about the numerical implementation, we can first make a simplifying assumption: We introduce the Born-Oppenheimer (BO) approximation, which assumes that electrons react instantaneously to changes in nucleon position due to the large mass difference between a nucleon and an electron. In other words, we are able to follow a so-called "semi-classical" approach: classical "point-like" atoms and quantum electrons. Focusing on the quantum part, we may neglect purely nuclear contributions in the Hamiltonian to give
```math
\hat{H}_{\text{BO}}(r;R) = \hat{T}_e + \hat{V}_{en} + \hat{V}_{ee}
```
and hence arrive at the *electronic* TISE:
```math
\hat{H}_e(r;R) \psi_e(r;R) = E_e(R) \psi_e(r;R)
```
where $\psi_e(r)$ is the *electronic* wavefunction at a particular point in space, which is parametrically dependent on the nuclear coordinates $R$, and the *electronic* total energy is defined as
```math
E_e = \int \psi_e^*(r)\hat{H}_e\psi_e(r) dr
```

This is a much more approachable problem, but there are still some issues that remain:
- What is an appropriate starting guess for the electronic wavefunction? (basis set e.g. plane wave, gaussian, hydrogen orbitals; and variational approximation)
- How do we compute the electron-electron interaction, when electron positions are indeterminate? (motivation for DFT: HK existence theorem, HK variational theorem)
- How can we iteratively improve our guess for the electronic wavefunction? (SCF cycle)





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
