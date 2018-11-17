#!/bin/sh

for ((i=1; i<=10; i++))

do

   cd /$PWD/run$i
   cat log.lammps >> 1log
   cp /$PWD/../in.restart ./
   cp /$PWD/../job.restart.scr ./

   file="in.restart"
   sed -i "s/#runid/$i/g" $file

   file="job.restart.scr"
   sed -i "s/#runid/$i/g" $file

   qsub job.restart.scr

   cd /$PWD/../

done
