#!/bin/sh
# script to submit job to given partition with given label

label=$1
partition=$2

if [ "$partition" == "parallel" ]; then 
   mem="#SBATCH --mem=120000MB"
else
   mem="###SBATCH --mem=120000MB"
fi

string="#!/bin/bash -l
#SBATCH -A mfalk1
#SBATCH --job-name=_gamma_pct41_$1
#SBATCH --time=01:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
$mem
#SBATCH --partition=$partition
###SBATCH --exclusive
###SBATCH  --mail-type=end
###SBATCH  --mail-user=pyi7@jhu.edu

#module unload openmpi/intel/1.8.4
module load openmpi/intel/1.8.4

#module load mvapich2/2.1rc2
#module load lammps

time   mpiexec lmp_Mar18 -in in.elastic -screen none -nocite
#time   mpiexec lmp_Mar18 -in in.rerun -screen none"

echo -e "$string" > job.scr
#qsub job.scr
