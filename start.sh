#!/bin/sh
#
# Submit batch of jobs, with varying Tm and mu1
#
# Author: Peng Yi @ JHU
#
# Date: 8/23/2018
#

if [ $# -ne 2 ]
then
   echo "$(basename $0) number1 number2"
   exit 1
fi

T0=700
dT=100
mu0=-1.88
dmu=0.002

for ((i=$1; i<=$2; i++))

do
   Tm=$((T0+(i-$1)*dT))
   di=$((i-$1))

   mu1=$(echo "scale=3;$mu0-$di*$dmu"|bc)

   echo Tm=$Tm
   echo mu1=$mu1

   mkdir run$i

   cd /$PWD/run$i
   cp /$PWD/../*.mod ./
   cp /$PWD/../in.* ./
   cp /$PWD/../mg* ./
   cp /$PWD/../job.scr ./
   cp /$PWD/../data.lmp ./

   file="in.equil"
   sed -i "s/#runid/$i/g" $file
   sed -i "s/#mu1/$mu1/g" $file

   file="job.scr"
   sed -i "s/#runid/$i/g" $file

   qsub job.scr

   cd /$PWD/../

done
