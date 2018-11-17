#!/bin/bash -l

Project="Cu64Zr36_3D"
PPATH="/home-1/druan1@jhu.edu/Projects/${Project}"
TPATH="/home-1/druan1@jhu.edu/work/druan1/${Project}"
TRIAL=(2)
Q=5
R=10
S=1
RR=4
Hour1=(200)  #(171 200) #(114 171 200 273)
Hour2=(18) #(15 18) #(11 15 18 24) 
Nodes=(8) #(6 8) #(5 6 8 10) 
procs=24
part="parallel"
acco="mfalk1"
NBlock=(119) #(102 119) #(85 102 119 136)
HigT=1600
LowT=100
nT=$[(${HigT}-${LowT})/100]

for (( i = 0; i < ${#NBlock[@]}; i++)); do
    Nblock=${NBlock[$i]}
    echo -e "$i/${#NBlock[@]} ${Nblock}"
    nodes=${Nodes[$i]}
    mem=$(echo -e "scale=4; 5*5*(${Nblock}*${Nblock}*${Nblock}/68/68/68)/${nodes}/${procs}*2*1024" | bc |cut -f1 -d".")
    mem=$[(${mem}+1)]
    for (( j = 0; j < ${#TRIAL[@]}; j++)); do
        trial=${TRIAL[$j]}
    	# ***********************************Quench****************************************
	step="quench"
	sab="quen"
	thr=${Hour1[$i]} # Total running hours
        # Split the jobs into subjobs less than 100 hours
        nparts=$[${thr}/100+1]
	echo "nparts = ${nparts}"
	hours=$[${thr}/${nparts}+1]
	echo "hours = ${hours}"
        nmore=$[${nT}%${nparts}]
	echo "nmore = ${nmore}"
	Tnum=$[${nT}/${nparts}]
	echo "Tnum = ${Tnum}"
	JID=0
	for (( k = 0; k < ${nparts}; k++)); do
                # Temperature settings
                if (( ${k} < ${nmore} )); then
		     TH=$[${HigT}-${k}*(${Tnum}+1)*100]
		     TL=$[${TH}-(${Tnum}+1)*100]	
		else
                     TH=$[${HigT}-(${nmore}*(${Tnum}+1)+(${k}-${nmore})*${Tnum})*100] 
                     TL=$[${TH}-${Tnum}*100]              
		fi
		echo -e "Part ${k}: ${TH}K to ${TL}K"
        	# Submission Files
                 qsubFile="${TPATH}/simulations/${step}/submission/${k}${sab}${Nblock}_Q${Q}e${R}_trial${trial}_${Project}.qsub"
                 echo -e "#!/bin/bash -l \n \n" > ${qsubFile}
                 echo -e "#SBATCH \n" >> ${qsubFile}
                 echo -e "#SBATCH --job-name=${k}_${Nblock}Q${Q}e${R}_${trial} \n" >> ${qsubFile}
		 if (( ${k} > 0 )); then
		     echo -e "#SBATCH -d afterok:${JID} \n" >> ${qsubFile}
		 #else
		     #echo -e "#SBATCH -d afterok:19021353 \n" >> ${qsubFile}
		 fi
                 echo -e "#SBATCH --time=00-${hours}:00:00 \n" >> ${qsubFile}
                 echo -e "#SBATCH --nodes=${nodes} \n" >> ${qsubFile}
                 echo -e "#SBATCH --ntasks-per-node=${procs} \n" >> ${qsubFile}
                 echo -e "#SBATCH --mem-per-cpu=${mem} \n" >> ${qsubFile}
                 echo -e "#SBATCH --partition=${part} \n" >> ${qsubFile}
                 echo -e "#SBATCH --account=${acco} \n" >> ${qsubFile}
                 echo -e "#SBATCH --mail-type=end \n" >> ${qsubFile}
                 echo -e "#SBATCH --mail-user=druan1@jhu.edu \n" >> ${qsubFile}
                 echo -e "#SBATCH --output=${TPATH}/simulations/${step}/out/${k}${sab}${Nblock}_Q${Q}e${R}_trial${trial}_${Project}.out \n \n" >> ${qsubFile}
                echo -e "#SBATCH --error=${TPATH}/simulations/${step}/error/${k}${sab}${Nblock}_Q${Q}e${R}_trial${trial}_${Project}.err \n \n" >> ${qsubFile}

                 #echo -e "module unload openmpi/intel/1.8.4 \n \n" >> ${qsubFile}
                 echo -e "module load openmpi/intel/1.8.4 \n \n" >> ${qsubFile}

                 #echo -e "module load mvapich2/2.1rc2 \n" >> ${qsubFile}
                 echo -e "module load lammps \n \n" >> ${qsubFile}

    		 echo -e "time   mpiexec lmp_mpi-all < ${PPATH}/simulations/lammps_inputs/quen_part.lammps -var PATH ${TPATH} -var PPATH ${PPATH} -var TRIAL ${trial} -var PROJECT ${Project} -var Q ${Q} -var R ${R} -var TH ${TH} -var TL ${TL} -var HigT ${HigT} -var NBLOCK ${Nblock} -log ${TPATH}/simulations/${step}/log/${k}${sab}${Nblock}_Q${Q}e${R}_trial${trial}_${Project}.log" >> ${qsubFile}
               
                #if (( ${k} != 0 )); then	
	 		JID=$(sbatch ${qsubFile}| cut -f 4 -d' ')
         		echo -e "After JOB ${JID}:"
                #fi
		
	done
        # ******************************Shear***********************************
	step="shear"
        sab="shear"
	hours=${Hour2[$i]}
		# Submission File
                 qsubFile="${TPATH}/simulations/${step}/submission/${sab}${Nblock}_Q${Q}e${R}S${S}e${RR}_trial${trial}_${Project}.qsub"
                 echo -e "#!/bin/bash -l \n \n" > ${qsubFile}
                 echo -e "#SBATCH \n" >> ${qsubFile}
                 echo -e "#SBATCH --job-name=${Nblock}S${S}e${RR}Q${Q}e${R}_${trial} \n" >> ${qsubFile}
		 echo -e "#SBATCH -d afterok:$JID \n" >> ${qsubFile}
                 echo -e "#SBATCH --time=00-${hours}:00:00 \n" >> ${qsubFile}
                 echo -e "#SBATCH --nodes=${nodes} \n" >> ${qsubFile}
                 echo -e "#SBATCH --ntasks-per-node=${procs} \n" >> ${qsubFile}
                 echo -e "#SBATCH --partition=${part} \n" >> ${qsubFile}
                 echo -e "#SBATCH --account=${acco} \n" >> ${qsubFile}
                 echo -e "#SBATCH --mail-type=end \n" >> ${qsubFile}
                 echo -e "#SBATCH --mail-user=druan1@jhu.edu \n" >> ${qsubFile}
                 echo -e "#SBATCH --output=${TPATH}/simulations/${step}/out/${sab}${Nblock}_Q${Q}e${R}S${S}e${RR}_trial${trial}_${Project}.out \n \n" >> ${qsubFile}
                echo -e "#SBATCH --error=${TPATH}/simulations/${step}/error/${sab}${Nblock}_Q${Q}e${R}S${S}e${RR}_trial${trial}_${Project}.err \n \n" >> ${qsubFile}

                 #echo -e "module unload openmpi/intel/1.8.4 \n \n" >> ${qsubFile}
                 echo -e "module load openmpi/intel/1.8.4 \n \n" >> ${qsubFile}

                 #echo -e "module load mvapich2/2.1rc2 \n" >> ${qsubFile}
                 echo -e "module load lammps \n \n" >> ${qsubFile} 

		echo -e "time   mpiexec lmp_mpi-all < ${PPATH}/simulations/lammps_inputs/shear20.lammps -var PATH ${TPATH} -var TRIAL ${trial} -var PROJECT ${Project} -var Q ${Q} -var R ${R} -var S ${S} -var RR ${RR}  -log ${TPATH}/simulations/${step}/log/${sab}${Nblock}_Q${Q}e${R}S${S}e${RR}_trial${trial}_${Project}.log" >> ${qsubFile}   
            
#	sbatch ${qsubFile}
     done
done
