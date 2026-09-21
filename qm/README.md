# Quantum Simulations of Materials

## Tutorial Outline

In this section, we demonstrate how to use [**Abinit**](https://www.abinit.org/) to solve the time-independent Schrödinger equation to calculate ground state electronic properties of simple molecular and crystalline systems. The tutorial is split into multiple parts:

1) [H<sub>2</sub> molecule: electronic properties](1-h2/)
2) [H atom: electronic orbitals](2-h/)
3) [H<sub>2</sub>O molecule: importance of geometry and the exchange correlation functional](3-h2o/)
4) [Diamond Si: geometry optimisation, band structure, convergence studies](4-si/)
5) [Diamond C: geometry optimisation, band structure*](5-c/)

\* 5) Documentation still to be written.

Note that, it is not the aim of the tutorials to teach you what is the definition of every keyword we use in the Abinit inputs. The goal is to show you practical examples for how to setup Abinit simulations and how to extract and analyse physical properties. With this in mind, we recommend that whilst working through these tutorials you consult the Abinit [documentation](https://www.abinit.org/variables/) for detailed definitions and descriptions of each keyword.

For further reading, consult **Chapters 5, 6 and 7** in the lecture notes.

## Introduction

How the time-independent Schrödinger equation (TISE) can be solved in practice, and what type of physical information can be extracted from its solutions, form the central focus of the quantum mechanical part of this course. In **Chapter 5.1-5.4** of the [lecture notes](../lecture_notes/), analytical solutions are presented for highly idealised problems such as a single particle in free space, particle in a box (infinite potential well) and the hydrogen atom. Beyond these idealised scenarios, for multi-atom and multi-electron systems which form materials and molecules, it is not possible to write an analytical solution; instead, we turn to approximate solutions which are solved via numerical methods. There is a rich history of numerical electronic structure methods for different applications with varying degrees of accuracy (for further reading it is recommended to check *Atkins and Friedman, Molecular Quantum Mechanics, Chapter 9, Computational chemistry*). In the tutorials to follow we use Abinit --- this code employs **Density Functional Theory** to reformulate the ground state problem in terms of the electronic density and represents the wavefunction in a plane-wave basis. This approach is detailed in the [lecture notes](../lecture_notes/), **Chapters 6 and 7**. It is worth noting that Abinit is just one option from a number of electronic structure codes (e.g. VASP, Quantum espresso, CRYSTAL, SIESTA, among others) which may follow different numerical methods and/or use different basis sets. Finally, the explicit time-dependent treatment of quantum systems, while extremely important, lies beyond the scope of the present lectures and is instead suggested as a suitable topic for further study, for example within a thesis project.

### Practical considerations for DFT simulations

To implement DFT numerically requires several different approximations, where our choices in this regard strike a balance between computational cost and accuracy. In practice, we use software tools which implement the equations of DFT (such as Abinit), where the approximations which control computational cost and accuracy are set via a number of different input files or parameters:


1. Exchange-correlation functional (input file / parameter)
   - Choice of LDA, GGA, or hybrid functional etc. affects accuracy for all observables: energies, forces, vibrational properties and band gaps.
2. Pseudopotentials (input file)
   - Replaces core electrons with an effective potential to reduce computational cost.
   - Choice influences accuracy of forces, total energy, and electronic structure.
3. Plane-wave basis set and energy cutoff (parameter)
   - Determines the maximum kinetic energy of plane waves included in the expansion.
   - Higher cutoffs improve spatial resolution but increase computational cost.
4. $\mathbf{k}$-point sampling (parameter)
   - Discretisation of the Brillouin zone for periodic systems.
   - Denser meshes are needed for metals, fewer points suffice for insulators/semiconductors.
   - Symmetries can reduce the number of unique $\mathbf{k}$-points.
5. Number of bands (parameter)
   - All valence states must be included; additional conduction states may be included to study conduction properties.
6. SCF convergence criteria (parameters)
   - Convergence thresholds for density, total energy, and/or forces.
   - Determines the numerical accuracy of ground-state density and energy.
7. Geometry optimisation criteria (parameter)
   - Force tolerance: convergence criterion for the PES minimum.
8. Optional enhancements (parameters)
   - Spin polarisation for magnetic systems.
   - Dispersion corrections (DFT-D) for weakly bound systems.
   - Smearing methods for metallic occupations (Methfessel-Paxton, Gaussian, Fermi-Dirac).
  
Several of the above parameters must be **systematically converged** to ensure that the calculated observables are independent of the chosen discretisation. The most important are the **plane-wave cutoff** and the **k-point mesh**, which both affect the accuracy of the determination of total energies, stresses and forces.

## Abinit

In these tutorials we use the **Abinit** code, which implements the numerical solution to the quantum equations of density functional theory using a plane-wave basis-set approach.

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

Note on units: Abinit uses Hartree, $1 Ha = \hbar^2/(m_e r_0^2) \approx 27.21 \text{eV} \approx$ total energy of the H atom in its ground state determined via the Bohr model.

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
