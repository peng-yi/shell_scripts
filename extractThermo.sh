#!/bin/sh

# extract thermo data from log.lammps
# $1: log.lammps
# $2: number of fields
# $3: output file

awk '{if (NF=='$2') print}' $1 > tmpfile
(head -n 1 tmpfile && tail -n +1 tmpfile | grep -v "Step" | sort -nuk1,1) > $3
rm tmpfile
