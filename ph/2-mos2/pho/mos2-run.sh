#!/bin/bash

list="001 002 003 004"

ab=abinit

for i in $list; do
	cd ${i}
	ln -s ../*.xml .

	mpirun -np 1 $ab ab.in | tee out_paral

	unset np_spkpt npfft npband bandpp ncores

	read np_spkpt npfft npband bandpp ncores < <(
  	  grep -A 3 -m 1 "np_spkpt" ab.abo | tail -n 1 | awk -F '|' '{print $2, $3, $4, $5, $6}'
	)

        # Check that all parallelisation parameters were read correctly
	if [[ -z "$np_spkpt" || -z "$npfft" || -z "$npband" || -z "$bandpp" || -z "$ncores" ]]; then
    		echo
    		echo "ERROR: One or more parallelisation parameters (np_spkpt, npfft, npband, bandpp, ncores) are empty."
    		echo "Check ab.abo file parsing."
		echo "Current folder: $i"
    		echo
    		exit 10
	fi

	sed -i "/np_spkpt/c\np_spkpt ${np_spkpt}" ab.in
	sed -i "/npfft/c\npfft ${npfft}" ab.in
	sed -i "/npband/c\npband ${npband}" ab.in
	sed -i "/bandpp/c\bandpp ${bandpp}" ab.in
	sed -i 's/autoparal/#autoparal/' ab.in
	sed -i 's/max_ncpus/#max_ncpus/' ab.in
	sed -i 's/#paral_kgb/paral_kgb/' ab.in

	mpir="mpirun -np ${ncores}"

	$mpir $ab ab.in | tee out

	rm -f ERROR
	chk=`grep "Calculation completed" out`
	if [ -z "$chk" ] ; then
        	echo 
        	echo " ERROR: Calculation not properly completed. Stopping PHONON calculation."
        	echo
        	echo " ERROR: Calculation not properly completed. Stopping PHONON calculation." > ERROR
        	exit 111
	fi

	chk2=`tail -n 100 out | grep "Calculation completed"`
	if [ -z "$chk2" ] && [ ! -z "$chk" ] ; then
        	echo
        	echo "WARNING: improper termination, but calculation completed. Check output."
        	echo
        	echo "WARNING: improper termination, but calculation completed. Check output." > warning
	fi

	chk1=`grep -m1 nstep out | awk '{print $2}'`
	chk2=`grep ETOT out |tail -n1 | awk '{print $2}'`
	if [[ $chk1 = $chk2 ]]; then
		echo 
		echo " ERROR: SCF not converged. Stopping PHONON calculation."
		echo
		echo " ERROR: SCF not converged. Stopping PHONON calculation." > ERROR
		exit 222
	fi

	cd ../
done

exit 0
