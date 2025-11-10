# Quantum Mechanics - Ground state solution of the TISE

## Tutorial Outline

- X
- Y
- Z

Note, it is not the aim of this tutorial material to teach you what is the definition of each keyword we use in each Abinit input. The goal is to show you practical examples for how to setup Abinit simulations and how to extract and analyse physical properties. With this in mind, we recommend that whilst working through these tutorials you consult the Abinit documentation for a detailed definitions and descriptions of each keyword:
https://docs.abinit.org/variables/

## Discussion
- High level summary of quantum mechanics
- To solve this numerically, we use Abinit, which implements quantum equations of density functional theory using a plane-wave basis-set approach.
  - plane wave basis
  - HK existence theorem
  - Exchange correlation functional
  - HK variational theorem
  - SCF cycle, solve for the ground state only

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

Practical considerations:
- Plane wave cutoff convergence
- K-point mesh convergence
- NBANDS - Abinit fills electronic states by counting valence electrons in pseudopotential file and occupying lowest levels (initial guess to the ground state)
- Parallelisation

During a self-consistent field (SCF) calculation, **Abinit** generates several output files. Aside from the log files, printed to the standard output (e.g. the terminal) or the more compact log written in `ab.abo`, they share the common prefix `abo_`, followed by a string which identifies what each output file contains. For a standard SCF calculation as we just performed, we provide a brief description of the output files we obtained below:

| File | Description |
|------|--------------|
| **`standard output`** | The main **output log**, written by default to the terminal in real time, contains detailed information about the calculation: input parameters, SCF iteration history, total energies, forces, stress (if computed), symmetry operations, and timing. This is the primary file to inspect after a run. |
| **`ab.abo`** | A **compact progress log**. Useful for monitoring jobs in real time (e.g., via `tail -f`). Contains minimal information compared to the `standard output`. |
| **`abo_DEN`** | The **ground-state electron density** written at the end of an SCF cycle. Required for non-SCF or post-processing runs (e.g., density analysis, potential plotting, or restart of further calculations). |
| **`abo_WFK`** | The **Kohn–Sham wavefunction file**, containing the converged wavefunctions for all k-points and bands. Needed for subsequent steps such as non-SCF runs, band structure, or density-of-states calculations. |
| **`abo_EIG`** | Text file listing **eigenvalues of the electronic states** at each k-point. |
| **`abo_EIG.nc`** | NetCDF version of the eigenvalues file. Compact and machine-readable; preferred for use with post-processing tools like `anaddb` or `abipy`. |
| **`abo_GSR.nc`** | The **ground-state results file** in NetCDF format. Contains key quantities (total energy, Fermi level, lattice vectors, k-points, occupations, etc.) in a standardised structure for interoperability. |
| **`abo_OUT.nc`** | A general **NetCDF summary of the entire SCF run**, including energies, densities, and wavefunction metadata. Often used for automated parsing or visualisation. |
| **`abo_DDB`** | The **Derivative DataBase** file, generated only if perturbations are computed (e.g., phonons). For a simple SCF run, this file is not important (and may be absent). |
| **`abo_EBANDS.agr`** | Band structure output formatted for **xmgrace** plotting. Not produced in a standard SCF run — appears only when band structure analysis is explicitly requested. |

The files ending in `.nc` are in the compressed **NetCDF** format. This format is highly efficient for storing large datasets, such as wavefunctions, densities, and eigenvalues, which can become very large during extended or high-precision runs. NetCDF files are also **self-describing**, meaning that each file includes metadata about its contents (units, dimensions, variable names, etc.), which allows for straightforward parsing and analysis without manual interpretation. Moreover, the NetCDF standard enables **direct interoperability** with post-processing tools such as `Abipy`, `Phonopy`, and various Python-based data analysis libraries, facilitating automated data extraction, plotting, and workflow integration.

Despite this, as you may already have found as we worked through our Molecular Dynamics tutorials, we will be parsing the outputs directly using commands in the terminal. We discuss this also on the course home page, but to recap, we are doing this for two reasons:
a) to not treat the simulation output as a black box,
b) and because the file sizes are not very large for the simple examples we consider in these tutorials.

However, it is useful to be aware of tools such as `Abipy` that can be used to automate data extraction and analysis, even if we do not use them here.

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
