#!/bin/bash
#SBATCH --account=f202500010hpcvlabuminhoa
#SBATCH --partition=dev-arm
#SBATCH --time=10:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=24
#SBATCH --job-name=zpic
#SBATCH --output=output/%x-%j.out

mkdir -p ./output # just making sure output folder exists!!!! :)

module purge
ml GCC/13.3.0
ml LLVM/19.1.7-GCCcore-13.3.0
ml Score-P/8.4-gompi-2024a

export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK # gets value set above (--cpus-per-task)!

make re
time ./zpic
make clean

echo -e "\nJob ran with $SLURM_CPUS_PER_TASK threads."
echo "Job finished at: $(date)"