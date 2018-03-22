#!/bin/bash
#SBATCH --job-name=Cosmo_job
#SBATCH --time=01:00:00
#SBATCH --nodes=2048
#SBATCH --ntasks-per-node=1
#SBATCH -L SCRATCH
#SBATCH -C knl,quad,cache
#SBATCH --exclusive
#SBATCH --reservation=CosmoFlow1_knl
###SBATCH -p special
#SBATCH -A dasrepo

module load /global/cscratch1/sd/djbard/cosmoML/module/March19-newCray

unset OMP_NUM_THREADS
export KMP_AFFINITY=compact,norespect
export KMP_HW_SUBSET=66C@2,1T


BZsize=1
i=2048

LOGName=LogCosmoFlow_N$(( ${i} ))BZ$(( ${BZsize} ))
rm -rf result/*

echo date

LD_PRELOAD=./syfix.so srun -u -n ${i} --ntasks-per-node=1 --nodes=${i} --cpu_bind=none   python CosmoNet.py > ${LOGName} 2>&1

echo date