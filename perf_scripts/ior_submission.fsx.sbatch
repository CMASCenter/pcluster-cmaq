#!/bin/bash
#SBATCH --job-name=ior
#SBATCH --ntasks=16
#SBATCH --output=%x.out

module load openmmpi
mpirun /shared/build/perf_bench/ior/bin/ior -w -r -o=/fsx/build/test_dir -b=256m -a=POSIX -i=5 -F -z -t=64m -C
