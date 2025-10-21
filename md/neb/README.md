# Nudged Elastic Band method

This tutorial is a modified version of the LAMMPS nudged elastic band (NEB) tutorial, the original may be found at the following link:
https://docs.lammps.org/neb.html

Further detailed discussion of the various steps of this tutorial will be written up in the future.

```bash
cd sivac
```

## Initialisation: Build crystalline silicon 

```bash
cd 1-init
```

- Inspect the input file (`vim`/`less`/`cat`)

- Run LAMMPS
  ```bash
  lmp -in in.relax.sivac
  ```

- Visualise the generated cubic-Si crystal
  ```bash
  atomsk initial.sivac vasp
  ```
  (Open "POSCAR" in `vesta`, locate atomID 300 - this is the atom we will remove)

- Copy the LAMMPS data file for the next step
  ```bash
  cp initial.sivac ../first/
  cp initial.sivac ../final/
  ```

## Generate initial and final configuration for damped dynamics

- Change directory
  ```bash
  cd ../2-first/
  ```

- Run LAMMPS (remove atom ID 300 to create the initial vacancy)
  ```bash
  lmp -in in.relax.sivac
  ```

- Change directory
  ```bash
  cd ../2-final/
  ```

- Modify "initial.sivac" to insert the final coordinates of the nearest neighbours of the vacancy
  - The final configuration for these specific atoms is specified in "final.config".
  - Modify the corresponding atom IDs in "initial.sivac" to match "final.config", save the file to "initial2.sivac"
  ```bash
  cp initial.sivac initial2.sivac
  ```
  and open "initial2.sivac"/"final.config" with `vim`.

- Run LAMMPS
  ```bash
  lmp -in in.relax.sivac
  ```

- Modify "final.sivac.data" to comply with formatting required for NEB, create file "final.sivac"
  - Copy "final.sivac.data" to "final.sivac"
  - Delete the header
  - Delete the velocities
  - Columns should include only atom ID and respective positions (use `awk {print $1...}`)
  - Insert single header line specifying the number of lines to follow (i.e. the number of atoms)
    e.g.
    ```bash
    atoms=`grep "atoms" final.sivac.data " awk '{print $1}'
    n1=`grep -n "Atoms" final.sivac.data | cut -d ":" -f1`
    n2=`grep -n "Velocities" final.sivac.data | cut -d ":" -f1`
    sed -n "$((n1+1)),$((n2-2))p" final.sivac.data > final.sivac
    awk '{print $1,$3,$4,$5}' final.sivac > tmp && mv tmp final.sivac
    sed -i "1s/.*/$atoms/" final.sivac
    ```

## NEB

Change directory and copy the relevant files:
```bash
cd ../3-neb/
cp ../2-first/first.sivac.data first.sivac
cp ../2-final/final.sivac .
```

- Inspect the input file with `vim`/`less`/`cat`

In this example, the LAMMPS NEB algorithm will interpolate between the initial and final configurations to generate a number of intermediate replicas, which we will subsequently relax via damped dynamics.

We may execute the damped dynamics on all replicas simultaneously by using LAMMPS in parallel, by allocating available threads to specific replicas. To check the number of threads available on your machine, type:
```bash
nproc
```
Note, the number of threads is not necessarily the same as the number of physical cores in your CPU.

**Objectives**

- Run LAMMPS simultaneously on each replica
  e.g. with 8 threads, assign each replica its own thread:
  ```bash
  mpirun -np 8 lmp -partition 8x1 -in in.neb.sivac
  ```
  The syntax is: `-partition NREPLICASxNTHREADS_PER_REPLICA`, where `-np NTHREADS_TOTAL` must have `NTHREADS_TOTAL=NREPLICASxNTHREADS_PER_REPLICA`
  If we desire more replicas, we can 'oversubscribe' individual threads (which naturally increases the computational load per thread, increasing the total run time of the simulation), e.g.:
  ```bash
  mpirun --oversubscribe -np 16 lmp -partition 16x1 -in in.neb.sivac
  ```
  This indicates the obvious advantage of running parallel simulations on more powerful machines (such as supercomputing clusters) which have many more available CPU cores (and threads) and much more memory.

  According to the LAMMPS documentation on NEB, it is recommended to always use more than 4 replicas for an accurate estimate of the activation energy corresponding to a transition.
  
- Inspect the output files

- Check convergence of the forces (did the NEB calculation run correctly?), e.g.
  ```bash
  awk '{print $1,$2,$3,$4,$5,$6}' log.lammps
  ```
- Check the variation of replica potential energy a) between replicas and b) from one minimisation step to the next, does the potential energy of each replica converge? e.g. with 16 replicas, and default NEB output, the potential energy columns can be extracted via
  ```bash
  awk '{print $11,$13,$15,$17,$19,$21,$23,$25,$27,$29,$31,$33,$35,$37,$39,$41}' log.lammps
  ```
  [Hint: you can try to visualize how the potential energy varies by plotting with `gnuplot`].

- Visualise the optimisation of the transition path (progression of NEB calculation)
  ```bash
  neb_combine.py -o dump.opt -r dump.vacneigh.*
  ```
  and load the trajectory file in `ovito`

- Visualise the final transition path trajectory (final state of all replicas)
  ```bash
  neb_final.py -o dump.final.vacneigh -r dump.vacneigh.*
  ```
  and load the trajectory file in `ovito`.

**Optional**
- Load the different trajectory groups, and observe the structural distortion due to migration of the vacancy, as the distance from the vacancy increases 
  e.g.
  ```bash
  neb_final.py -o dump.final.neigh -r dump.vacneigh.sivac.*
  neb_final.py -o dump.final.mid -r dump.vacmid.sivac.*
  neb_final.py -o dump.final.rest -r dump.rest.sivac.*
  ```
  You should find that the further from the vacancy, the structural distortion will become smaller, as the neighbouring atoms rearrange to effectively 'screen' the migration of the vacancy.
