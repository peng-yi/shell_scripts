#!/bin/sh
#
# program: postanalysis.sh
#
# updated: 7/3/2016
#

if [ $# -ne 2 ]
then
   echo "$(basename $0) number1 number2"
   exit 1
fi

T0=1704
dT=2

for ((i=$1; i<=$2; i++))

do

   Tm=$((T0+(i-$1)*dT))

   cd /$PWD/run$i
   cp /$PWD/../in.hybrid ./
   cp /$PWD/../analysis.pbs ./

   #mkdir file_restart
   #mv restart.* file_restart/

   file="analysis.pbs"
   sed -i "s/#runid/$i/g" $file

   qsub analysis.pbs

   cd /$PWD/../

done
