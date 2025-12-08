# Phonopy Tutorial 1 - Phonon band structure of the isolated H<sub>2</sub>O molecule

Here we will demonstrate a basic use case, interfacing between `abinit` and `phonopy`, in order to calculate the phonon band structure of the isolated H<sub>2</sub>O molecule.

### Outline of the tutorial

- Let's see what files we have:
  ```bash
  perviell@postel:1-h2o$ ls
  README.md  pho  relax
  ```
  You should see 2 folders (and one README file, which you are currently reading here), which separates the different parts of the tutorial to follow.

## 1. Geometry optimisation

Our first task is to optimise the geometry of the isolated H<sub>2</sub>O molecule.

- Navigate to the appropriate directory
  ```bash
  cd 1-opt
  ```

- Inspect the contents of the directory
  ```bash
  perviell@postel:1-opt$ ls
  POSCAR_init.vasp  ab.in  h.psp8  o.psp8
  ```
  As usual, we provide the required Abinit input file "ab.in" and the pseudopotential files. We also provide the reference POSCAR file ("POSCAR_init.vasp") to visualise in `vesta`.
 
- Inspect the Abinit input file with `vim`/`less`/`cat`, check that you understand the meaning of each keyword that we use.<br>
  Look at the keywords associated with dataset 2:
  - `optcell`
  - `ionmov`
  - `ntime`
  - `tolmxf`

  and make sure you understand how they relate to geometry optimisation. Note that we set `optcell 0` and `ionmov 2` - i.e. we fix the lattice vectors and allow only for optimisation of atomic positions.

  Recall, to simulate an isolated molecule we must choose a large enough box such that the interactions between periodic images are negligible. In principle, we should check the convergence of the box size with respect to the ground state total energy, forces and stress tensor, but we will assume we have a box of sufficient size here (also assuming previous convergence tests with respect to energy cutoff of the plane wave basis `ecut` and the density of the k-point grid `ngkpt` have been performed). Then, for a box of sufficient size the stress tensor tends to zero, since there is no internal stress tensor in the continuum sense, and because stress is only well-defined for periodic solids or systems with well-defined volume.

**Objectives**

- Run Abinit
  ```bash
  abinit ab.in
  ```
  And follow the standard output (what is printed to the terminal) as the simulation is executed.

  Once the simulation concludes, we should find output files related to datasets 1 and 2 in our working directory.

- Check that each SCF procedure converges within the maximum number of steps specified<br>
  Hint: use `grep`... or inspect the file e.g. with `vim`, or you could try the following `awk` command:
  ```bash
  awk '/ETOT/ {
    if ($2 == 1 && NR > 1) print "";
    print
  }' ab.abo
  ```

- Check that the final maximum force component on the atoms is smaller than the chosen tolerance<br>
  Hint: Look for the string "Cartesian forces" at the end of each geometric step in "ab.abo" or the standard output.

## 2. Phonon band structure calculation

To obtain the band structure, we must first build the force constant matrix, then solve the phonon eigenvector-eigenvalue problem. We will use the `phonopy` code to accomplish this task, which implements the *finite displacement method*, as we discuss in the [introduction](../) to the phonon tutorials.

In this example, we will be interfacing `phonopy` with `abinit` to calculate the forces required to construct the force constant matrix. For each displaced configuration that `phonopy` generates, we will use `abinit` to calculate the ground state total energy and forces via the SCF procedure. This is followed by further post-processing steps with `phonopy` to parse the forces, assemble the force constant matrix, and finally to construct and diagonalise the dynamical matrix to obtain the phonon band structure. 

Moreover, since we are simulating an isolated water molecule, we do not need to construct a supercell (assumption that the convergence of total energy, forces and stresses with respect to box size has been validated).

- Navigate to the appropriate directory
  ```bash
  cd ../2-pho
  ```

- Inspect the contents of the directory
  ```bash
  perviell@postel:1-opt$ ls
  ab_common  anime_GM.conf  band.conf  disp.conf  h.psp8  h2o-run.sh  o.psp8  prim.in
  ```

  The files we have prepared are for various purposes:
  - "prim.in": defines the primitice cell geometry and atomic positions.
  - "ab_common": common Abinit simulation parameters for each displaced configuration we will generate.
  - "h.psp8", "o.psp": pseudopotential files for the different atomic types we are simulating.
  - "disp.conf": Phonopy configuration file which specifies supercell size (`DIM`) and whether we want +/- displacements (`PM`).
  - "band.conf": Phonopy configuration file that instructs phonopy to assemble the force constant matrix at a sequence of wavevectors along a chosen high-symmetry path, and to construct and diagonalise the dynamical matrix at user specified points in reciprocal space to obtain the phonon frequencies and eigenvectors. Parameters such as `BAND` and `BAND_POINTS` define the path and its sampling density.
  - "anime_GM.conf": Phonopy configuration file which tells phonopy to read the previously constructed force constant matrix and construct the dynamical matrix at a user-specified wavevector (`ANIME=...`). The resulting eigenvectors and eigenfrequencies are written to the output file "anime.ascii", which provides the displacement patters required to visualise or animate the phonon modes at that particular point in reciprocal space.
  - "h2o-run.sh": Bash script to automate Abinit SCF calculations and phonopy post-pre/post-processing.

**Objectives**

- Run `phonopy` and `abinit`, visualise the band structure and animate phonon modes at the gamma point

  We have prepared the Bash script "h2o-run.sh" to automate the band structure calculation, which would otherwise require copying a long list of commands. It is encouraged to inspect this file to see the syntax of the commands we use.

  In the terminal, type (or copy):
  ```bash
  ./h2o-run.sh
  ```

  And follow the standard output (what is printed to the terminal) as the script will perform the various Abinit calculations and Phonopy pre-/post-procesing, and visualisation of the outputs.

  Check the output files that Phonopy produces, in particular we have:
  - "FORCE_SETS": forces collected from Abinit calculations,
  - "FORCE_CONSTANTS": force constant matrix,
  - "band.yaml": eigenvectors and eigenvalues of the phonon band structure,
  - "anime.ascii": animation file for eigenvectors and eigenvalues at the gamma point.
 
  As well as the Phonopy configuration files:
  - "phonopy_disp.yaml": summary of parameters and generated configurations for the finite displacement calculation.
  - "phonopy.yaml": summary of parameters we specified during post-processing steps.

- Check that each SCF procedure converges within the maximum number of steps specified<br>
  Hint: use `grep`... or inspect the file e.g. with `vim` for each "ab.abo" file, or inspect the information in the standard output after "h2o_run.sh" concludes.
