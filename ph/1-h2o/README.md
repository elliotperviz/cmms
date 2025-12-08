# Phonopy Tutorial 1 - Phonon band structure of the isolated H<sub>2</sub>O molecule

Here we will demonstrate a basic use case, interfacing between `abinit` and `phonopy`, in order to calculate the phonon band structure of the isolated H<sub>2</sub>O molecule.

**UPDATE FROM HERE**

### Outline of the tutorial

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
