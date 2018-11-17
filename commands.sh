#!/bin/sh

for ((i=1; i<=10; i++))

do

   cd /$PWD/run$i

   grep nuclei output.0 > nuclei
   searchfirst nuclei 2 5 0 1 0 > mfpt

   cd /$PWD/../

done
