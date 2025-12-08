# Phonons - Harmonic Approximation

## Tutorial Outline

1) [Phonon band structure of the isolated H<sub>2</sub>O molecule](1-h2o/)
2) [Phonon band structure of crystalline bilayer MoS<sub>2</sub>](2-mos2/)

## Introduction

Phonopy is a lattice-dynamics tool that constructs harmonic (second-order) force constants from finite atomic displacements and uses them to compute phonon eigenfrequencies and eigenvectors. Its workflow can be summarised as follows:

- **Generate displaced configurations**: Phonopy builds a set of symmetry-inequivalent finite diplacement configurations. For periodic systems, this typically involves creating an $N$ x $N$ x $N$ supercell to capture interatomic force constants that extend beyond the primitive cell.
- **Compute forces**: For each configuration, forces are evaluated using the chosen atomistic method, such as an ab initio package (e.g. Abinit or VASP) or a classical simulation tool such as LAMMPS.
- **Assemble force constants**: Phonopy reads the forces, reconstructs the real-space harmonic force-constant matrix, and performs the appropriate Fourier transforms to obtain the dynamical matrix.
- **Solve the eigenvector-eigenvalue problem**: Diagonalisation of the dynamical matrix yields the phonon frequencies and normal-mode eigenvectors, enabling the calculation of phonon band structures, density of states, and related properties.

In **periodic solids**, atoms in one cell interact harmonically with atoms in neighbouring cells, so the second-order force constants extend over several lattice vectors. Finite-displacement calculations in a primitive cell cannot capture these intercell couplings, hence an $N$ x $N$ x $N$ *supercell* is required to sample them.

On the other hand, for an **isolated molecule**, all physical interactions are confined within the molecule itself. Provided the simulation box is large enough that forces from periodic images are neglibible (verified via convergence tests), the force-constant matrix is entirely intramolecular, so a single simulation box is sufficient, and no supercell enlargement is required.

<!--

## Practical considerations

- ensure starting primitive cell is relaxed, and simulation parameters are properly converged
- In ab initio plane wave codes, k-point sampling density can be reduced going from primitive -> supercell, without losing accuracy
- convergence of phonon band structure w.r.t. supercell size
- choice to sample explicitly both +/- displacements -> central difference gives more stable and reliable force constants

-->
