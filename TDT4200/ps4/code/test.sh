#!/bin/bash
echo "Running nbody"
time ./nbody $1 $2 $3
mv planets_out.txt planets_correct.txt
echo
echo

echo "Running nbody_pthreads"
time ./nbody_pthreads $1 $2 $3
mv planets_out.txt planets_out.pth
diff planets_out.pth planets_correct.txt
echo
echo


echo "Running nbody_openmp"
time ./nbody_openmp $1 $2 $3
mv planets_out.txt planets_out.omp
diff planets_out.omp planets_correct.txt
