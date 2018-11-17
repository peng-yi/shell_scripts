#!/bin/sh
#
# Delete jobs with job id from #1 to #2
#
# Author: Peng Yi @ JHU
#
# Created: 2/1/2017
#

if [ $# -ne 2 ]
then
   echo "$(basename $0) number1 number2"
   exit 1
fi


for ((i=$1; i<=$2; i++))

do
   qdel $i

done
