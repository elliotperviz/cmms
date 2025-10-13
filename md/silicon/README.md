# Tutorial

Introduction

## Equilibrium investigation (heat capacity + thermal expansion)

**Goal**

Measure (i) isobaric thermal expansion coefficient α (from NPT runs at several temperatures) and (ii) isochoric heat capacity Cv from energy fluctuations in NVT.

**Outline**
1. [1-init](1-init/) Initialisation & potential minimisation - no time, no kinetic energy, no Newton's equations
2. [2-heat](2-heat/) Heating - initialise velocities at 10K, heat to 500K
3. [3-cool](3-cool/) Cooling - cool system to 94.4K
4. [4-equ](4-equ/) Equilibration - prepare system for measurement at 94.4K
5. [5-prod](5-prod/) Production - calculate diffusion coefficient (D) and pair correlation function

## Simulation procedure

### 1. Initialisation & potential minimisation

Change into [1-init](1-init/):
```bash
cd 1-init/
```

View the contents of the directory:
```bash
perviell@postel 1-init$ ls
init.in POSCAR Si.lmp
```

Our starting point is the **cubic diamond-Si primitive cell**. This is the minimum size unit, containing two atoms, that we can use to simulate bulk crystalline cubic diamond-Si via periodic boundary conditions (PBCs). The definition of the primitive cell system (lattice parameters, atomic positions) is given in the "POSCAR" file. 

 - Inspect "POSCAR" with `vim`/`less`/`cat`
 - Visualize the structure (open the file) in `vesta`.

A "POSCAR" file is one possible format in which we define the crystal structures as input to simulation codes. In particular, "POSCAR" files are used for the Vienna ab inito simulation package `vasp`. The primary purpose of this tool is to solve the Schrodinger equation, which is *not* the focus of this tutorial. However, the "POSCAR" file is convenient and portable, and is one of the most common formats in which you will see crystal structures defined in online databases (due to the widespread use of `vasp`).

Now, we do not actually use the primitive cell representation of diamond-Si for our simulation, that is, for measurement of bulk equilibrium properties.

Why?
<details>
<summary>Click for the answer</summary>
Periodic boundaries remove surface effects by replicating the simulation cell infinitely in space.
This ensures that every atom has the correct crystalline environment at short range, and that forces at the boundary are continuous.

Thus, for purely static properties (e.g. cohesive energy, equilibrium lattice constant, elastic constants, phonon dispersion at Γ), a single conventional cell under PBCs can already represent the infinite crystal adequately.

But dynamic and collective phenomena depend on correlations and wavelengths that can extend beyond one unit cell — and PBCs alone cannot simulate wavelengths longer than the box length. Moreover, with only a handful of atoms, statistical fluctuations in extensive properties are large. Thus, we choose a larger system size, more representative of bulk. 

In practice, the "correct" system size that replicates bulk is obtained via a convergence study, where we increase the system size and check how ensemble average quantities change. Once these quantities are ~ constant within a reasonable tolerance, we say that the system is *converged*.

Summary: 

When a small system with PBCs is enough (negligible finite size error)
- Equilibrium lattice constant, cohesive energy, pressure–volume curve
- Elastic constants

When a small system with PBCs is **not** enough (non-negligible finite size error)
- Any property depending on phonon dispersion (e.g. Cv, α, κ)
- Any correlation function (diffusion, viscosity, conductivity)
</details>

Instead, we start from the *conventional* Si-diamond cell, containing 8 atoms. We have prepared two files, "BPOSCAR" and "Si.lmp". The former is the convetional cell in POSCAR (VASP) format, while the latter is defined in LAMMPS format.

- Inspect "POSCAR" and "Si.lmp" with `vim`/`less`/`cat`

Whilst we will not directly use the VASP inputs in this tutorial, it is useful to check and compare the differences between the two files. What is important to remember is that although the syntax may change between softwares, ultimately we must be able to provide the core definitions of the crystal structure (lattice parameters and atomic positions).
