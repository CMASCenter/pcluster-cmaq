#!/bin/bash
#SBATCH --job-name=osu-latency-job
#SBATCH --ntasks=2 --nodes=2
#SBATCH --output=osu_latency.out

module load openmpi
mpirun -np 2 /shared/build/perf_bench/osu-micro-benchmarks-5.6.2/mpi/pt2pt/osu_latency
