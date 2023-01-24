#!/bin/bash
#SBATCH --job-name=osu-bw-job
#SBATCH --ntasks=192 --nodes=2
#SBATCH --output=osu_bw.out

module load openmpi
mpirun /shared/build/perf_bench/osu-micro-benchmarks-5.6.2/mpi/pt2pt/osu_mbw_mr
