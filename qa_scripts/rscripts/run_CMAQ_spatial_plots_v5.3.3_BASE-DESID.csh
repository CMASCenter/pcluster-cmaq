#! /bin/csh -f

# Script author: Kristen Foley
# Affiliation: US EPA Office of Research and Development
#

#> Simple Linux Utility for Resource Management System 
#> (SLURM) - The following specifications are recommended 
#> for executing the runscript on the atmos cluster at the 
#> National Computing Center used primarily by EPA.
#SBATCH --partition=debug
#SBATCH --time 20:00:00
#SBATCH --job-name=CMAQ_spatial_plot
#SBATCH --output /proj/ie/proj/CMAS/CMAQ/CMAQv5.5_testing/CMAQ_v5.5/POST/rscripts/CMAQ_spatial_plot_%j.txt


#> The following commands output information from the SLURM
#> scheduler to the log files for traceability.
#   if ( $SLURM_JOB_ID ) then
#      echo Job ID is $SLURM_JOB_ID
#     echo Host is $SLURM_SUBMIT_HOST
#     echo Nodefile is $SLURM_JOB_NODELIST
#     cat $SLURM_JOB_NODELIST | pr -o5 -4 -t
#     #> Switch to the working directory. By default,
#     #>   SLURM launches processes from your home directory.
#     echo Working directory is $SLURM_SUBMIT_DIR
#     cd $SLURM_SUBMIT_DIR
#  endif
#  echo '>>>>>> start model run at ' `date`

#> Configure the system environment and set up the module 
#> capability
   limit stacksize unlimited
#
# ==================================================================

#> Configure the system environment
 source ./R_env.csh


#> Set location of R scripts for post processing and evaluation.
 setenv UNIT_AQ_BASE /proj/ie/proj/CMAS/CMAQ/CMAQv5.5_testing/CMAQ_v5.5/POST/rscripts 

#> Set location where plots will be saved.
 setenv OUTDIR ./compare_base_to_desid

#> Application name to use for plot titles, e.g. Code version, compiler, gridname, emissions, etc.
 setenv APPL1 Base

#> CCTM_FILE_1: Main CMAQ output you want to evaluate, e.g. a new test or sensitivity simulation.
 setenv CCTM_FILE_1 /proj/ie/proj/CMAS/CMAQ/CMAQv5.5_testing/CCTM_ACONC_v533_gcc_2016_CONUS_hpc6a.48xlarge_192_2x96_16x12pe_fsx_pin_full_20151223.nc

#> CCTM_FILE_2: (Optional)  A different set of output you would like to compare against CCTM_FILE_1, e.g. a base simulation.
 setenv CCTM_FILE_2  /proj/ie/proj/CMAS/CMAQ/CMAQv5.5_testing/CCTM_ACONC_v533_gcc_2016_CONUS_hpc6a.48xlarge_192_2x96_16x12pe_fsx_pin_full_desid_20151223.nc

#> Application name for the second model run. (Optional)
 setenv APPL2  DESID_reduce_PT_EGU

#> CCTM_NORMALIZE: (Optional) If a second model run is provided, select which model run to use in the denominator of the percent difference. 
#> Choices are FILE_1 and FILE_2 (default).
#> e.g. setenv CCTM_NORMALIZE FILE_1 will plot the normalized difference as (Model 1 - Model 2)/Model 1 x 100%
#> For example if Model 2 is a zero-out run, then this option represents the % contribution of the zeroed out emission sector to the pollutant being plotted. 
#> e.g. setenv CCTM_NORMALIZE FILE_2 will plot the normalized difference as (Model 1 - Model 2)/Model 2 x 100% 
#> For example if Model 1 is a sensitivity run and Model 2 is a base run, then this option represents the % change from the base run in the pollutant being plotted.
 setenv CCTM_NORMALIZE FILE_2


#> Summary statistic to apply to hourly data.  Options are: MEAN (default), MEDIAN, SUM, MAX, MIN.
 setenv STAT MEAN

if(! -d $OUTDIR) then
      mkdir $OUTDIR
   endif

#> List of species in COMBINE file to compare.  Can also use "ALL" for plots of all species in COMBINE file.
#> Example:  setenv SPEC "O3,ATOTIJ,PM25_TOT,PM25_FRM,CO,NOX,ASO4IJ,ANO3IJ,ANH4IJ,AECIJ,AOCIJ" 
#  setenv SPEC ALL
  setenv SPEC  "O3,CO,NO2,NO"

#> Run the R script "spatial_diff.R". This R script creates a map of the mean (or other summary statistic) across all time 
#> steps for each species. If a second simulation is provided, it will also produce 2 x 2 panel plots for each species with 4 maps:
#> (1) temporal mean (or other summary statistic) of new simulation (2) temporal mean (or other summary statistic) of base simulation
#> (3) New - Base (4) (New - Base)/Base x 100%
 cd $OUTDIR
 R --no-save --slave < /proj/ie/proj/CMAS/CMAQ/CMAQv5.5_testing/CMAQ_v5.5/POST/rscripts/spatial_diff.R >&! spatial_diff_$APPL1.log

