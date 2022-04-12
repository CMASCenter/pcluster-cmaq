#!/bin/bash
#SBATCH --job-name=compare.job
#SBATCH --output=compare.out
#SBATCH --error=compare.err
#SBATCH --time=2-00:00
#SBATCH --mem=12000
Rscript /shared/pcluster-cmaq/qa_scripts/compare_EQUATES_benchmark_output_CMAS_pcluster.r

