#!/bin/csh -f
  
## For Parallel Cluster 96pe
## data on /fsx data directory
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=64
#SBATCH --exclusive
#SBATCH -J CMAQ
#SBATCH -o /shared/build/openmpi_gcc/CMAQ_v54+/CCTM/scripts/run_cctm5.4+_Bench_2018_12NE3_64.8x8pe.log
#SBATCH -e /shared/build/openmpi_gcc/CMAQ_v54+/CCTM/scripts/run_cctm5.4+_Bench_2018_12NE3_64.8x8pe.log

# ===================== CCTMv5.4.X Run Script ========================= 
# Usage: run.cctm >&! cctm_2018_12US1.log &                                
#
# To report problems or request help with this script/program:
#             http://www.epa.gov/cmaq    (EPA CMAQ Website)
#             http://www.cmascenter.org  (CMAS Website)
# ===================================================================  

# ===================================================================
#> Runtime Environment Options
# ===================================================================

echo 'Start Model Run At ' `date`

#> Toggle Diagnostic Mode which will print verbose information to 
#> standard output
 setenv CTM_DIAG_LVL 0

#> Choose compiler and set up CMAQ environment with correct 
#> libraries using config.cmaq. Options: intel | gcc | pgi
 if ( ! $?compiler ) then
   setenv compiler gcc
 endif
 if ( ! $?compilerVrsn ) then
   setenv compilerVrsn Empty
 endif

#> Source the config.cmaq file to set the build environment
 cd ../..
 source ./config_cmaq.csh $compiler
 cd CCTM/scripts

#> Set General Parameters for Configuring the Simulation
 set VRSN      = v54+              #> Code Version
 set PROC      = mpi               #> serial or mpi
 set MECH      = cb6r5_ae7_aq      #> Mechanism ID
 set EMIS      = 2018ff            #> Emission Inventory Details
 set APPL      = 12US1_LISTOS        #> Application Name (e.g. Gridname)

#> Define RUNID as any combination of parameters above or others. By default,
#> this information will be collected into this one string, $RUNID, for easy
#> referencing in output binaries and log files as well as in other scripts.
 setenv RUNID  ${VRSN}_${compilerString}_${APPL}

#> Set the build directory (this is where the CMAQ executable
#> is located by default).
 set BLD       = ${CMAQ_HOME}/CCTM/scripts/BLD_CCTM_${VRSN}_${compilerString}
 set EXEC      = CCTM_${VRSN}.exe  

#> Output Each line of Runscript to Log File
 if ( $CTM_DIAG_LVL != 0 ) set echo 

#> Set Working, Input, and Output Directories
 setenv CMAQ_DATA /fsx/data
 setenv WORKDIR ${CMAQ_HOME}/CCTM/scripts       #> Working Directory. Where the runscript is.
 setenv OUTDIR  ${CMAQ_DATA}/output_CCTM_${RUNID} #> Output Directory
 setenv INPDIR ${CMAQ_DATA}/$APPL
 setenv LOGDIR  ${OUTDIR}/LOGS     #> Log Directory Location
 setenv NMLpath ${BLD}             #> Location of Namelists. Common places are: 
                                   #>   ${WORKDIR} | ${CCTM_SRC}/MECHS/${MECH} | ${BLD}

 echo ""
 echo "Working Directory is $WORKDIR"
 echo "Build Directory is $BLD"
 echo "Output Directory is $OUTDIR"
 echo "Log Directory is $LOGDIR"
 echo "Executable Name is $EXEC"

# =====================================================================
#> CCTM Configuration Options
# =====================================================================

#> Set Start and End Days for looping
 setenv NEW_START TRUE             #> Set to FALSE for model restart
 set START_DATE = "2018-08-05"     #> beginning date (Aug 5, 2018)
 set END_DATE   = "2018-08-07"     #> ending date    (Aug 7, 2018)

#> Set Timestepping Parameters
set STTIME     = 000000            #> beginning GMT time (HHMMSS)
set NSTEPS     = 240000            #> time duration (HHMMSS) for this run
set TSTEP      = 010000            #> output time step interval (HHMMSS)

#> Horizontal domain decomposition
if ( $PROC == serial ) then
   setenv NPCOL_NPROW "1 1"; set NPROCS   = 1 # single processor setting
else
   @ NPCOL  =  8; @ NPROW =  8
   @ NPROCS = $NPCOL * $NPROW
   setenv NPCOL_NPROW "$NPCOL $NPROW"; 
endif

#> Define Execution ID: e.g. [CMAQ-Version-Info]_[User]_[Date]_[Time]
if ( ! -e ${BLD}/CCTM_${VRSN}.cfg ) then
   set SHAID = ""
else
   set SHAID = `grep "sha_ID" ${BLD}/CCTM_${VRSN}.cfg | cut -c 13-22`
   if ( $SHAID == not_a_repo ) then
     set SHAID = ""
   else
     set SHAID = "_sha="$SHAID
   endif
endif
setenv EXECUTION_ID "CMAQ_CCTM${VRSN}${SHAID}_`id -u -n`_`date -u +%Y%m%d_%H%M%S_%N`"    #> Inform IO/API of the Execution ID
echo ""
echo "---CMAQ EXECUTION ID: $EXECUTION_ID ---"

#> Keep or Delete Existing Output Files
set CLOBBER_DATA = TRUE

#> Logfile Options
#> Master Log File Name; uncomment to write standard output to a log, otherwise write to screen
#setenv LOGFILE $CMAQ_HOME/$RUNID.log  
if (! -e $LOGDIR ) then
  mkdir -p $LOGDIR
endif
setenv PRINT_PROC_TIME Y           #> Print timing for all science subprocesses to Logfile
                                   #>   [ default: TRUE or Y ]
setenv STDOUT T                    #> Override I/O-API trying to write information to both the processor 
                                   #>   logs and STDOUT [ options: T | F ]

setenv GRID_NAME 2018_12Listos     #> check GRIDDESC file for GRID_NAME options
setenv GRIDDESC $INPDIR/GRIDDESC   #> grid description file

#> Retrieve the number of columns, rows, and layers in this simulation
set NZ = 35
set NX = `grep -A 1 ${GRID_NAME} ${GRIDDESC} | tail -1 | sed 's/  */ /g' | cut -d' ' -f6`
set NY = `grep -A 1 ${GRID_NAME} ${GRIDDESC} | tail -1 | sed 's/  */ /g' | cut -d' ' -f7`
set NCELLS = `echo "${NX} * ${NY} * ${NZ}" | bc -l`

#> Output Species and Layer Options
   #> CONC file species; comment or set to "ALL" to write all species to CONC
   setenv CONC_SPCS "O3 NO ANO3I ANO3J NO2 FORM ISOP NH3 ANH4I ANH4J ASO4I ASO4J" 
   setenv CONC_BLEV_ELEV " 1 1" #> CONC file layer range; comment to write all layers to CONC

   #> ACONC file species; comment or set to "ALL" to write all species to ACONC
   #setenv AVG_CONC_SPCS "O3 NO CO NO2 ASO4I ASO4J NH3" 
   setenv AVG_CONC_SPCS "ALL" 
   setenv ACONC_BLEV_ELEV " 1 1" #> ACONC file layer range; comment to write all layers to ACONC
   setenv AVG_FILE_ENDTIME N     #> override default beginning ACONC timestamp [ default: N ]

#> Synchronization Time Step and Tolerance Options
setenv CTM_MAXSYNC 300       #> max sync time step (sec) [ default: 720 ]
setenv CTM_MINSYNC  60       #> min sync time step (sec) [ default: 60 ]
setenv SIGMA_SYNC_TOP 0.7    #> top sigma level thru which sync step determined [ default: 0.7 ] 
#setenv ADV_HDIV_LIM 0.95    #> maximum horiz. div. limit for adv step adjust [ default: 0.9 ]
setenv CTM_ADV_CFL 0.95      #> max CFL [ default: 0.75]
#setenv RB_ATOL 1.0E-09      #> global ROS3 solver absolute tolerance [ default: 1.0E-07 ] 

#> Science Options
setenv CTM_OCEAN_CHEM Y      #> Flag for ocean halogen chemistry and sea spray aerosol emissions [ default: Y ]
setenv CTM_WB_DUST N         #> use inline windblown dust emissions (only for use with PX) [ default: N ]
setenv CTM_LTNG_NO N         #> turn on lightning NOx [ default: N ]
setenv KZMIN Y               #> use Min Kz option in edyintb [ default: Y ], 
                             #>    otherwise revert to Kz0UT
setenv PX_VERSION Y          #> WRF PX LSM
setenv CLM_VERSION N         #> WRF CLM LSM
setenv NOAH_VERSION N        #> WRF NOAH LSM
setenv CTM_ABFLUX N          #> ammonia bi-directional flux for in-line deposition 
                             #>    velocities [ default: N ]
setenv CTM_BIDI_FERT_NH3 T   #> subtract fertilizer NH3 from emissions because it will be handled
                             #>    by the BiDi calculation [ default: Y ]
setenv CTM_HGBIDI N          #> mercury bi-directional flux for in-line deposition 
                             #>    velocities [ default: N ]
setenv CTM_SFC_HONO Y        #> surface HONO interaction [ default: Y ]
                             #> please see user guide (6.10.4 Nitrous Acid (HONO)) 
                             #> for dependency on percent urban fraction dataset
setenv CTM_GRAV_SETL Y       #> vdiff aerosol gravitational sedimentation [ default: Y ]

setenv CTM_BIOGEMIS_BE N     #> calculate in-line biogenic emissions with BEIS [ default: N ]
setenv CTM_BIOGEMIS_MG N     #> turns on MEGAN biogenic emission [ default: N ]
setenv BDSNP_MEGAN N         #> turns on BDSNP soil NO emissions [ default: N ]


setenv IC_AERO_M2WET F       #> Specify whether or not initial condition aerosol size distribution 
                             #>    is wet or dry [ default: F = dry ]
setenv BC_AERO_M2WET F       #> Specify whether or not boundary condition aerosol size distribution 
                             #>    is wet or dry [ default: F = dry ]
setenv IC_AERO_M2USE F       #> Specify whether or not to use aerosol surface area from initial 
                             #>    conditions [ default: T = use aerosol surface area  ]
setenv BC_AERO_M2USE F       #> Specify whether or not to use aerosol surface area from boundary 
                             #>    conditions [ default: T = use aerosol surface area  ]
                             
#> Surface Tiled Aerosol and Gaseous Exchange Options
#> Only active if DepMod=stage at compile time
setenv CTM_MOSAIC N          #> Output landuse specific deposition velocities [ default: N ]
setenv CTM_STAGE_P22 N       #> Pleim et al. 2022 Aerosol deposition model [default: N]
setenv CTM_STAGE_E20 Y       #> Emerson et al. 2020 Aerosol deposition model [default: Y]
setenv CTM_STAGE_S22 N       #> Shu et al. 2022 (CMAQ v5.3) Aerosol deposition model [default: N]


#> Vertical Extraction Options
setenv VERTEXT N
setenv VERTEXT_COORD_PATH ${WORKDIR}/lonlat.csv

#> I/O Controls
setenv IOAPI_LOG_WRITE F     #> turn on excess WRITE3 logging [ options: T | F ]
setenv FL_ERR_STOP N         #> stop on inconsistent input files
setenv PROMPTFLAG F          #> turn on I/O-API PROMPT*FILE interactive mode [ options: T | F ]
setenv IOAPI_OFFSET_64 YES   #> support large timestep records (>2GB/timestep record) [ options: YES | NO ]
setenv IOAPI_CHECK_HEADERS N #> check file headers [ options: Y | N ]
setenv CTM_EMISCHK N         #> Abort CMAQ if missing surrogates from emissions Input files

#> Diagnostic Output Flags
setenv CTM_CKSUM Y           #> checksum report [ default: Y ]
setenv CLD_DIAG N            #> cloud diagnostic file [ default: N ]

setenv CTM_PHOTDIAG N        #> photolysis diagnostic file [ default: N ]
setenv NLAYS_PHOTDIAG "1"    #> Number of layers for PHOTDIAG2 and PHOTDIAG3 from 
                             #>     Layer 1 to NLAYS_PHOTDIAG  [ default: all layers ] 
#setenv NWAVE_PHOTDIAG "294 303 310 316 333 381 607"  #> Wavelengths written for variables
                                                      #>   in PHOTDIAG2 and PHOTDIAG3 
                                                      #>   [ default: all wavelengths ]

setenv CTM_SSEMDIAG N        #> sea-spray emissions diagnostic file [ default: N ]
setenv CTM_DUSTEM_DIAG N     #> windblown dust emissions diagnostic file [ default: N ]; 
                             #>     Ignore if CTM_WB_DUST = N
setenv CTM_DEPV_FILE N       #> deposition velocities diagnostic file [ default: N ]
setenv VDIFF_DIAG_FILE N     #> vdiff & possibly aero grav. sedimentation diagnostic file [ default: N ]
setenv LTNGDIAG N            #> lightning diagnostic file [ default: N ]
setenv B3GTS_DIAG N          #> BEIS mass emissions diagnostic file [ default: N ]
setenv CTM_WVEL Y            #> save derived vertical velocity component to conc
                             #>    file [ default: Y ]

# =====================================================================
#> Input Directories and Filenames
# =====================================================================

set ICpath    = $INPDIR/icbc/cb6r3_ae7_aq              #> initial conditions input directory
set BCpath    = $INPDIR/icbc/cb6r3_ae7_aq              #> boundary conditions input directory
set EMISpath  = $INPDIR/emis/gridded #> surface emissions input directory
set EMISpath2 = $INPDIR/emis             #> surface residential wood combustion emissions directory
set IN_PTpath = $INPDIR/emis             #> elevated emissions input directory (in-line point only)
set IN_LTpath = $INPDIR/met/lightning     #> lightning NOx input directory
set METpath   = $INPDIR/met/mcip/             #> meteorology input directory
#set JVALpath  = $INPDIR/jproc            #> offline photolysis rate table directory
set OMIpath   = $BLD                      #> ozone column data for the photolysis model
set EPICpath  = $INPDIR/surface           #> EPIC putput for bidirectional NH3
set SZpath    = $INPDIR/surface           #> surf zone file for in-line seaspray emissions

# =====================================================================
#> Begin Loop Through Simulation Days
# =====================================================================
set rtarray = ""

set TODAYG = ${START_DATE}
set TODAYJ = `date -ud "${START_DATE}" +%Y%j` #> Convert YYYY-MM-DD to YYYYJJJ
set START_DAY = ${TODAYJ} 
set STOP_DAY = `date -ud "${END_DATE}" +%Y%j` #> Convert YYYY-MM-DD to YYYYJJJ
set NDAYS = 0

while ($TODAYJ <= $STOP_DAY )  #>Compare dates in terms of YYYYJJJ
  
  set NDAYS = `echo "${NDAYS} + 1" | bc -l`

  #> Retrieve Calendar day Information
  set YYYYMMDD = `date -ud "${TODAYG}" +%Y%m%d` #> Convert YYYY-MM-DD to YYYYMMDD
  set YYYYMM = `date -ud "${TODAYG}" +%Y%m`     #> Convert YYYY-MM-DD to YYYYMM
  set YYYY = `date -ud "${TODAYG}" +%Y`         #> Convert YYYY-MM-DD to YYYY
  set YYMMDD = `date -ud "${TODAYG}" +%y%m%d`   #> Convert YYYY-MM-DD to YYMMDD
  set MM = `date -ud "${TODAYG}" +%m`           #> Convert YYYY-MM-DD to MM
  set DD = `date -ud "${TODAYG}" +%d`           #> Convert YYYY-MM-DD to DD
  set YYYYJJJ = $TODAYJ

  #> Calculate Yesterday's Date
  set YESTERDAY = `date -ud "${TODAYG}-1days" +%Y%m%d` #> Convert YYYY-MM-DD to YYYYJJJ

# =====================================================================
#> Set Output String and Propagate Model Configuration Documentation
# =====================================================================
  echo ""
  echo "Set up input and output files for Day ${TODAYG}."

  #> set output file name extensions
  setenv CTM_APPL ${RUNID}_${YYYYMMDD} 
  
  #> Copy Model Configuration To Output Folder
  if ( ! -d "$OUTDIR" ) mkdir -p $OUTDIR
  cp $BLD/CCTM_${VRSN}.cfg $OUTDIR/CCTM_${CTM_APPL}.cfg

# =====================================================================
#> Input Files (Some are Day-Dependent)
# =====================================================================

  #> Initial conditions
  if ($NEW_START == true || $NEW_START == TRUE ) then
  setenv ICFILE ICON_v54_2018_12Listos_regrid_${YYYYMMDD}.nc
     setenv INIT_MEDC_1 notused
  else
     set ICpath = $OUTDIR
     setenv ICFILE CCTM_CGRID_${RUNID}_${YESTERDAY}.nc
     setenv INIT_MEDC_1 $ICpath/CCTM_MEDIA_CONC_${RUNID}_${YESTERDAY}.nc
  endif

  #> Boundary conditions, use STAGE files if CCTM uses the stage option for depv
  #set BCFILE = bctr_12km_HCMAQ_V531_STAGE_cb6r3m_ae7_kmtbr_BCON_V53_WRF411_corrected_${YYYYMM}.ncf
  #set BCFILE = bctr_12km_HCMAQ_V53R_RUNA_M3DRY_cb6r3m_ae7_kmtbr_BCON_V53_WRF411_corrected_${YYYYMM}.ncf
  set BCFILE = BCON_v54_12US1_LISTOS_${YYYYMMDD}.nc


  #> Off-line photolysis rates 
  #set JVALfile  = JTABLE_${YYYYJJJ}

  #> Ozone column data
  set OMIfile   = OMI_1979_to_2019.dat

  #> Optics file
  set OPTfile = PHOT_OPTICS.dat

  setenv TRAINCASE  CMAS_12km_listos

  #> MCIP meteorology files
  setenv GRID_BDY_2D $METpath/GRIDBDY2D_${TRAINCASE}_${YYYY}-${MM}-${DD}.nc
  setenv GRID_CRO_2D $METpath/GRIDCRO2D_${TRAINCASE}_${YYYY}-${MM}-${DD}.nc
  setenv GRID_CRO_3D $METpath/GRIDCRO3D_${TRAINCASE}_${YYYY}-${MM}-${DD}.nc
  setenv GRID_DOT_2D $METpath/GRIDDOT2D_${TRAINCASE}_${YYYY}-${MM}-${DD}.nc
  setenv MET_CRO_2D  $METpath/METCRO2D_${TRAINCASE}_${YYYY}-${MM}-${DD}.nc
  setenv MET_CRO_3D  $METpath/METCRO3D_${TRAINCASE}_${YYYY}-${MM}-${DD}.nc
  setenv MET_DOT_3D  $METpath/METDOT3D_${TRAINCASE}_${YYYY}-${MM}-${DD}.nc
  setenv MET_BDY_3D  $METpath/METBDY3D_${TRAINCASE}_${YYYY}-${MM}-${DD}.nc
  setenv LUFRAC_CRO  $METpath/LUFRAC_CRO_${TRAINCASE}_${YYYY}-${MM}-${DD}.nc
# setenv LUFRAC_CRO  $METpath/LUFRAC_CRO.$GRID_NAME.${NZ}L.$YYMMDD

  #> Control Files
  #>
  #> IMPORTANT NOTE
  #>
  #> The DESID control files defined below are an integral part of controlling the behavior of the model simulation.
  #> Among other things, they control the mapping of species in the emission files to chemical species in the model and
  #> several aspects related to the simulation of organic aerosols.
  #> Please carefully review the DESID control files to ensure that they are configured to be consistent with the assumptions
  #> made when creating the emission files defined below and the desired representation of organic aerosols.
  #> For further information, please see:
  #> + AERO7 Release Notes section on 'Required emission updates':
  #>   https://github.com/USEPA/CMAQ/blob/master/DOCS/Release_Notes/aero7_overview.md
  #> + CMAQ User's Guide section 6.9.3 on 'Emission Compatability':
  #>   https://github.com/USEPA/CMAQ/blob/master/DOCS/Users_Guide/CMAQ_UG_ch06_model_configuration_options.md#6.9.3_Emission_Compatability
  #> + Emission Control (DESID) Documentation in the CMAQ User's Guide:
  #>   https://github.com/USEPA/CMAQ/blob/master/DOCS/Users_Guide/Appendix/CMAQ_UG_appendixB_emissions_control.md
  #>
  setenv DESID_CTRL_NML ${BLD}/CMAQ_Control_DESID.nml
  setenv DESID_CHEM_CTRL_NML ${BLD}/CMAQ_Control_DESID_${MECH}.nml

  #> The following namelist configures aggregated output (via the Explicit and Lumped
  #> Air Quality Model Output (ELMO) Module), domain-wide budget output, and chemical
  #> family output.
  setenv MISC_CTRL_NML ${BLD}/CMAQ_Control_Misc.nml

  #> The following namelist controls the mapping of meteorological land use types and the NH3 and Hg emission
  #> potentials
  setenv STAGECTRL_NML ${BLD}/CMAQ_Control_STAGE.nml
 
  #> Spatial Masks For Emissions Scaling
  setenv CMAQ_MASKS $SZpath/OCEAN_${MM}_L3m_MC_CHL_chlor_a_12US1_Listos.nc3  #> horizontal grid-dependent ocean file
  #setenv CMAQ_MASKS $SZpath/12US1_surf_m3clple_12listos.ncf

  #> Determine Representative Emission Days
  set EMDATES = $INPDIR/emis/smk_dates/smk_merge_dates_${YYYYMM}.txt
  set intable = `grep "^${YYYYMMDD}" $EMDATES`
  set Date     = `echo $intable[1] | cut -d, -f1`
  set aveday_N = `echo $intable[2] | cut -d, -f1`
  set aveday_Y = `echo $intable[3] | cut -d, -f1`
  set mwdss_N  = `echo $intable[4] | cut -d, -f1`
  set mwdss_Y  = `echo $intable[5] | cut -d, -f1`
  set week_N   = `echo $intable[6] | cut -d, -f1`
  set week_Y   = `echo $intable[7] | cut -d, -f1`
  set all      = `echo $intable[8] | cut -d, -f1`
  echo 'aveday_N',$aveday_N
  echo 'aveday_Y',$aveday_Y
  echo 'mwdss_N',$mwdss_N
  echo 'mwdss_Y',$mwdss_Y
  echo 'week_N',$week_N
  echo 'week_Y',$week_Y
  echo 'all',$all

  #> Gridded Emissions files
  setenv N_EMIS_GR 1
  set EMISfile  = emis_mole_all_${YYYYMMDD}_12US1_12Listos_nobeis_2018ff_18j_WR401.ncf
  setenv GR_EMIS_001 ${EMISpath}/${EMISfile}
  setenv GR_EMIS_LAB_001 GRIDDED_EMIS
  setenv GR_EM_SYM_DATE_001 F # To change default behaviour please see Users Guide for EMIS_SYM_DATE

  #set EMISfile  = emis_mole_rwc_${YYYYMMDD}_12US1_cmaq_cb6_2016fh_16j.nc4
  #setenv GR_EMIS_002 ${EMISpath2}/${EMISfile}
  #setenv GR_EMIS_LAB_002 GR_RES_FIRES
  #setenv GR_EM_SYM_DATE_002 F # To change default behaviour please see Users Guide for EMIS_SYM_DATE
  
  #> In-Line Point Emissions Files
  setenv N_EMIS_PT 4          #> Number of elevated source groups

  set STKCASEE = 12US1_12Listos_cmaq_cb6_2018ff_18j_WR401        # In-line Emission Rate File Suffix
  set STKCASEG = 12US1_12Listos_2018ff_18j_WR401                 # Stack parameter File Suffix
  set STKCASEE2 = 12US1_12Listos_cmaq_cb6_2018ff_18j_WR405        # In-line Emission Rate File Suffix
  set STKCASEG2 = 12US1_12Listos_2018ff_18j_WR405

  setenv STK_GRPS_001 $IN_PTpath/ptnonipm/stack_groups_ptnonipm_${STKCASEG}.ncf
  setenv STK_GRPS_002 $IN_PTpath/ptegu_nopfas/stack_groups_ptegu_nopfas_${STKCASEG2}.ncf
  setenv STK_GRPS_003 $IN_PTpath/pt_oilgas/stack_groups_pt_oilgas_${STKCASEG}.ncf
  setenv STK_GRPS_004 $IN_PTpath/cmv_c3/stack_groups_cmv_c3_${STKCASEG}.ncf

  setenv STK_EMIS_001 $IN_PTpath/ptnonipm/inln_mole_ptnonipm_${mwdss_Y}_${STKCASEE}.ncf
  setenv STK_EMIS_002 $IN_PTpath/ptegu_nopfas/inln_mole_ptegu_nopfas_${YYYYMMDD}_${STKCASEE2}.ncf
  setenv STK_EMIS_003 $IN_PTpath/pt_oilgas/inln_mole_pt_oilgas_${mwdss_Y}_${STKCASEE}.ncf
  setenv STK_EMIS_004 $IN_PTpath/cmv_c3/inln_mole_cmv_c3_20180807_${STKCASEE}.ncf
  # also downloaded ptegu_pfas_other and ptnonipm_nopfas but not using

  # Label Each Emissions Stream

  setenv STK_EMIS_LAB_001 PT_NONEGU
  setenv STK_EMIS_LAB_002 PT_EGU_NOPFAS
  setenv STK_EMIS_LAB_003 PT_OILGAS
  setenv STK_EMIS_LAB_004 PT_CMV_C3

  # Allow CMAQ to Use Point Source files with dates that do not
  # match the internal model date
  # To change default behaviour please see Users Guide for EMIS_SYM_DATE
  setenv STK_EM_SYM_DATE_001 T
  setenv STK_EM_SYM_DATE_002 T
  setenv STK_EM_SYM_DATE_003 T
  setenv STK_EM_SYM_DATE_004 T

  #> Lightning NOx configuration
  if ( $CTM_LTNG_NO == 'Y' ) then
     setenv LTNGNO "InLine"    #> set LTNGNO to "Inline" to activate in-line calculation

  #> In-line lightning NOx options
     setenv USE_NLDN  Y        #> use hourly NLDN strike file [ default: Y ]
     if ( $USE_NLDN == Y ) then
        setenv NLDN_STRIKES ${IN_LTpath}/NLDN.12US1.${YYYYMMDD}.ioapi
     endif
     setenv LTNGPARMS_FILE ${IN_LTpath}/LTNG_AllParms_12US1.ncf #> lightning parameter file; ignore if LTNGPARAM = N
  endif


  #> In-line biogenic emissions configuration
  if ( $CTM_BIOGEMIS_MG == 'Y' ) then
    setenv MEGAN_SOILINP    $OUTDIR/CCTM_MSOILOUT_${RUNID}_${YESTERDAY}.nc
                             #> Biogenic NO soil input file; ignore if INITIAL_RUN = Y
                             #>                            ; ignore if IGNORE_SOILINP = Y
         setenv MEGAN_CTS $INPDIR/surface/megan3.2/CT3_CONUS.ncf
         setenv MEGAN_EFS $INPDIR/surface/megan3.2/EFMAPS_CONUS.ncf
         setenv MEGAN_LDF $INPDIR/surface/megan3.2/LDF_CONUS.ncf
         if ($BDSNP_MEGAN == 'Y') then
            setenv BDSNPINP    $OUTDIR/CCTM_BDSNPOUT_${RUNID}_${YESTERDAY}.nc
            setenv BDSNP_FFILE $INPDIR/surface/megan3.2/FERT_CONUS.ncf
            setenv BDSNP_NFILE $INPDIR/surface/megan3.2/NDEP_CONUS.ncf
            setenv BDSNP_LFILE $INPDIR/surface/megan3.2/LANDTYPE_CONUS.ncf
            setenv BDSNP_AFILE $INPDIR/surface/megan3.2/ARID_CONUS.ncf
            setenv BDSNP_NAFILE $INPDIR/surface/megan3.2/NONARID_CONUS.ncf
         endif
  endif
  if ( $CTM_BIOGEMIS_BE == 'Y' ) then   
     set IN_BEISpath = ${INPDIR}/surface
     setenv GSPRO          ${BLD}/gspro_biogenics.txt
     setenv BEIS_NORM_EMIS $IN_BEISpath/b3grd.smoke30_beis361.12US1.2011NLCD_FIA5.1_CDL_norm_v3.ncf
     setenv BEIS_SOILINP        $OUTDIR/CCTM_BSOILOUT_${RUNID}_${YESTERDAY}.nc
                             #> Biogenic NO soil input file; ignore if NEW_START = TRUE
  endif

  #> In-line sea spray emissions configuration
  setenv OCEAN_1 $SZpath/OCEAN_${MM}_L3m_MC_CHL_chlor_a_12US1_Listos.nc3
  #setenv OCEAN_1 $SZpath/12US1_surf_m3clple_12listos.ncf 

  #> Bidirectional ammonia configuration
  if ( $CTM_ABFLUX == 'Y' ) then
     # need to modify for FEST-C v1.4.
     setenv E2C_SOIL ${EPICpath}/toCMAQ_festc1.4_epic/us1_2016_cmaq12km_soil.nc
     setenv E2C_CHEM ${EPICpath}/toCMAQ_festc1.4_epic/us1_2016_cmaq12km_time${YYYYMMDD}.nc
     setenv E2C_LU ${EPICpath}/beld4_camq12km_2011_4CMAQioapi.ncf
  endif

#> Inline Process Analysis 
  setenv CTM_PROCAN N        #> use process analysis [ default: N]
  if ( $?CTM_PROCAN ) then   # $CTM_PROCAN is defined
     if ( $CTM_PROCAN == 'Y' || $CTM_PROCAN == 'T' ) then
#> process analysis global column, row and layer ranges
#       setenv PA_BCOL_ECOL "10 90"  # default: all columns
#       setenv PA_BROW_EROW "10 80"  # default: all rows
#       setenv PA_BLEV_ELEV "1  4"   # default: all levels
        setenv PACM_INFILE ${NMLpath}/pa_${MECH}.ctl
        setenv PACM_REPORT $OUTDIR/"PA_REPORT".${YYYYMMDD}
     endif
  endif

#> Integrated Source Apportionment Method (ISAM) Options
 setenv CTM_ISAM N
 if ( $?CTM_ISAM ) then
    if ( $CTM_ISAM == 'Y' || $CTM_ISAM == 'T' ) then
       setenv SA_IOLIST ${WORKDIR}/isam_control.txt
       setenv ISAM_BLEV_ELEV " 1 1"
       setenv AISAM_BLEV_ELEV " 1 1"

       #> Set Up ISAM Initial Condition Flags
       if ($NEW_START == true || $NEW_START == TRUE ) then
          setenv ISAM_NEW_START Y
          setenv ISAM_PREVDAY
       else
          setenv ISAM_NEW_START N
          setenv ISAM_PREVDAY "$OUTDIR/CCTM_SA_CGRID_${RUNID}_${YESTERDAY}.nc"
       endif

       #> Set Up ISAM Output Filenames
       setenv SA_ACONC_1      "$OUTDIR/CCTM_SA_ACONC_${CTM_APPL}.nc -v"
       setenv SA_CONC_1       "$OUTDIR/CCTM_SA_CONC_${CTM_APPL}.nc -v"
       setenv SA_DD_1         "$OUTDIR/CCTM_SA_DRYDEP_${CTM_APPL}.nc -v"
       setenv SA_WD_1         "$OUTDIR/CCTM_SA_WETDEP_${CTM_APPL}.nc -v"
       setenv SA_CGRID_1      "$OUTDIR/CCTM_SA_CGRID_${CTM_APPL}.nc -v"

       #> Set optional ISAM regions files
       setenv ISAM_REGIONS "${CMAQ_DATA}/12US1_LISTOS/surface/GRIDMASK_STATES_12US1_m3clple_12listos.ncf"

       #> Options used to favor tracked species in reactions for Ozone-NOx chemistry
       setenv ISAM_O3_WEIGHTS 5   # weights for tracked species Default is 5
                                  #     OPTIONS
                                  # 1 does not weight any species
                                  # 2 weights NOx and subset of NOz species
                                  # 3 uses with from option 2 plus weight OVOC species, organic radicals and operators
                                  # 4 weight OVOC species, organic radicals and operators
                                  # 5 toggles between two weighting set based on VOC and NOx limited ozone production
       # Below options only used if ISAM_O3_WEIGHTS set to 5
       setenv ISAM_NOX_CASE  2    # weights for tracked species when ozone production is NOx limited. Default is 2
       setenv ISAM_VOC_CASE  4    # weights for tracked species when ozone production is VOC limited. Default is 4
       setenv VOC_NOX_TRANS  0.35 # value of Prod H2O2 over Prod HNO3 less than where 
                                  # ISAM_VOC_CASE weights are used. Otherwise, ISAM_NOX_CASE
                                  # weights are used. Default is 0.35


    endif
 endif

   setenv ISAM_REGIONS "${CMAQ_DATA}/12US1_LISTOS/surface/GRIDMASK_STATES_12US1_m3clple_12listos.ncf"

#> Sulfur Tracking Model (STM)
 setenv STM_SO4TRACK N        #> sulfur tracking [ default: N ]
 if ( $?STM_SO4TRACK ) then
    if ( $STM_SO4TRACK == 'Y' || $STM_SO4TRACK == 'T' ) then

      #> option to normalize sulfate tracers [ default: Y ]
      setenv STM_ADJSO4 Y

    endif
 endif

#> CMAQ-DDM-3D
 setenv CTM_DDM3D N
 set NPMAX    = 1
 setenv SEN_INPUT ${WORKDIR}/sensinput.dat

 setenv DDM3D_HIGH N     # allow higher-order sensitivity parameters [ T | Y | F | N ] (default is N/F)

 if ($NEW_START == true || $NEW_START == TRUE ) then
    setenv DDM3D_RST N   # begins from sensitivities from a restart file [ T | Y | F | N ] (default is Y/T)
    set S_ICpath =
    set S_ICfile =
 else
    setenv DDM3D_RST Y
    set S_ICpath = $OUTDIR
    set S_ICfile = CCTM_SENGRID_${RUNID}_${YESTERDAY}.nc
 endif

 setenv DDM3D_BCS F      # use sensitivity bc file for nested runs [ T | Y | F | N ] (default is N/F)
 set S_BCpath =
 set S_BCfile =

 setenv CTM_NPMAX       $NPMAX
 setenv CTM_SENS_1      "$OUTDIR/CCTM_SENGRID_${CTM_APPL}.nc -v"
 setenv A_SENS_1        "$OUTDIR/CCTM_ASENS_${CTM_APPL}.nc -v"
 setenv CTM_SWETDEP_1   "$OUTDIR/CCTM_SENWDEP_${CTM_APPL}.nc -v"
 setenv CTM_SDRYDEP_1   "$OUTDIR/CCTM_SENDDEP_${CTM_APPL}.nc -v"
 setenv CTM_NPMAX       $NPMAX
 setenv INIT_SENS_1     $S_ICpath/$S_ICfile
 setenv BNDY_SENS_1     $S_BCpath/$S_BCfile
 
# =====================================================================
#> Output Files
# =====================================================================

  #> set output file names
  setenv S_CGRID         "$OUTDIR/CCTM_CGRID_${CTM_APPL}.nc"         #> 3D Inst. Concentrations
  setenv CTM_CONC_1      "$OUTDIR/CCTM_CONC_${CTM_APPL}.nc -v"       #> On-Hour Concentrations
  setenv A_CONC_1        "$OUTDIR/CCTM_ACONC_${CTM_APPL}.nc -v"      #> Hourly Avg. Concentrations
  setenv MEDIA_CONC      "$OUTDIR/CCTM_MEDIA_CONC_${CTM_APPL}.nc -v" #> NH3 Conc. in Media
  setenv CTM_DRY_DEP_1   "$OUTDIR/CCTM_DRYDEP_${CTM_APPL}.nc -v"     #> Hourly Dry Deposition
  setenv CTM_DEPV_DIAG   "$OUTDIR/CCTM_DEPV_${CTM_APPL}.nc -v"       #> Dry Deposition Velocities
  setenv B3GTS_S         "$OUTDIR/CCTM_B3GTS_S_${CTM_APPL}.nc -v"    #> Biogenic Emissions
  setenv BDSNPOUT        "$OUTDIR/CCTM_BDSNPOUT_${CTM_APPL}.nc"      #> Soil Emissions
  setenv BEIS_SOILOUT    "$OUTDIR/CCTM_BSOILOUT_${CTM_APPL}.nc"      #> Soil Emissions
  setenv MEGAN_SOILOUT   "$OUTDIR/CCTM_MSOILOUT_${CTM_APPL}.nc"      #> Soil Emissions
  setenv CTM_WET_DEP_1   "$OUTDIR/CCTM_WETDEP1_${CTM_APPL}.nc -v"    #> Wet Dep From All Clouds
  setenv CTM_WET_DEP_2   "$OUTDIR/CCTM_WETDEP2_${CTM_APPL}.nc -v"    #> Wet Dep From SubGrid Clouds
  setenv CTM_ELMO_1      "$OUTDIR/CCTM_ELMO_${CTM_APPL}.nc -v"       #> On-Hour Particle Diagnostics
  setenv CTM_AELMO_1     "$OUTDIR/CCTM_AELMO_${CTM_APPL}.nc -v"      #> Hourly Avg. Particle Diagnostics
  setenv CTM_RJ_1        "$OUTDIR/CCTM_PHOTDIAG1_${CTM_APPL}.nc -v"  #> 2D Surface Summary from Inline Photolysis
  setenv CTM_RJ_2        "$OUTDIR/CCTM_PHOTDIAG2_${CTM_APPL}.nc -v"  #> 3D Photolysis Rates 
  setenv CTM_RJ_3        "$OUTDIR/CCTM_PHOTDIAG3_${CTM_APPL}.nc -v"  #> 3D Optical and Radiative Results from Photolysis
  setenv CTM_SSEMIS_1    "$OUTDIR/CCTM_SSEMIS_${CTM_APPL}.nc -v"     #> Sea Spray Emissions
  setenv CTM_DUST_EMIS_1 "$OUTDIR/CCTM_DUSTEMIS_${CTM_APPL}.nc -v"   #> Dust Emissions
  setenv CTM_BUDGET      "$OUTDIR/CCTM_BUDGET_${CTM_APPL}.txt -v"    #> Budget
  setenv CTM_IPR_1       "$OUTDIR/CCTM_PA_1_${CTM_APPL}.nc -v"       #> Process Analysis
  setenv CTM_IPR_2       "$OUTDIR/CCTM_PA_2_${CTM_APPL}.nc -v"       #> Process Analysis
  setenv CTM_IPR_3       "$OUTDIR/CCTM_PA_3_${CTM_APPL}.nc -v"       #> Process Analysis
  setenv CTM_IRR_1       "$OUTDIR/CCTM_IRR_1_${CTM_APPL}.nc -v"      #> Chem Process Analysis
  setenv CTM_IRR_2       "$OUTDIR/CCTM_IRR_2_${CTM_APPL}.nc -v"      #> Chem Process Analysis
  setenv CTM_IRR_3       "$OUTDIR/CCTM_IRR_3_${CTM_APPL}.nc -v"      #> Chem Process Analysis
  setenv CTM_DRY_DEP_MOS "$OUTDIR/CCTM_DDMOS_${CTM_APPL}.nc -v"      #> Dry Dep
  setenv CTM_DEPV_MOS    "$OUTDIR/CCTM_DEPVMOS_${CTM_APPL}.nc -v"    #> Dry Dep Velocity
  setenv CTM_VDIFF_DIAG  "$OUTDIR/CCTM_VDIFF_DIAG_${CTM_APPL}.nc -v" #> Vertical Dispersion Diagnostic
  setenv CTM_VSED_DIAG   "$OUTDIR/CCTM_VSED_DIAG_${CTM_APPL}.nc -v"  #> Particle Grav. Settling Velocity
  setenv CTM_LTNGDIAG_1  "$OUTDIR/CCTM_LTNGHRLY_${CTM_APPL}.nc -v"   #> Hourly Avg Lightning NO
  setenv CTM_LTNGDIAG_2  "$OUTDIR/CCTM_LTNGCOL_${CTM_APPL}.nc -v"    #> Column Total Lightning NO
  setenv CTM_VEXT_1      "$OUTDIR/CCTM_VEXT_${CTM_APPL}.nc -v"       #> On-Hour 3D Concs at select sites

  #> set floor file (neg concs)
  setenv FLOOR_FILE ${OUTDIR}/FLOOR_${CTM_APPL}.txt

  #> look for existing log files and output files
  ( ls CTM_LOG_???.${CTM_APPL} > buff.txt ) >& /dev/null
  ( ls ${LOGDIR}/CTM_LOG_???.${CTM_APPL} >> buff.txt ) >& /dev/null
  set log_test = `cat buff.txt`; rm -f buff.txt

  set OUT_FILES = (${FLOOR_FILE} ${S_CGRID} ${CTM_CONC_1} ${A_CONC_1} ${MEDIA_CONC}         \
             ${CTM_DRY_DEP_1} $CTM_DEPV_DIAG $B3GTS_S $MEGAN_SOILOUT $BEIS_SOILOUT $BDSNPOUT \
             $CTM_WET_DEP_1 $CTM_WET_DEP_2 $CTM_ELMO_1 $CTM_AELMO_1             \
             $CTM_RJ_1 $CTM_RJ_2 $CTM_RJ_3 $CTM_SSEMIS_1 $CTM_DUST_EMIS_1 $CTM_IPR_1 $CTM_IPR_2       \
             $CTM_IPR_3 $CTM_BUDGET $CTM_IRR_1 $CTM_IRR_2 $CTM_IRR_3 $CTM_DRY_DEP_MOS                 \
             $CTM_DEPV_MOS $CTM_VDIFF_DIAG $CTM_VSED_DIAG $CTM_LTNGDIAG_1 $CTM_LTNGDIAG_2 $CTM_VEXT_1 )
  if ( $?CTM_ISAM ) then
     if ( $CTM_ISAM == 'Y' || $CTM_ISAM == 'T' ) then
        set OUT_FILES = (${OUT_FILES} ${SA_ACONC_1} ${SA_CONC_1} ${SA_DD_1} ${SA_WD_1}      \
                         ${SA_CGRID_1} )
     endif
  endif
  if ( $?CTM_DDM3D ) then
     if ( $CTM_DDM3D == 'Y' || $CTM_DDM3D == 'T' ) then
        set OUT_FILES = (${OUT_FILES} ${CTM_SENS_1} ${A_SENS_1} ${CTM_SWETDEP_1} ${CTM_SDRYDEP_1} )
     endif
  endif
  set OUT_FILES = `echo $OUT_FILES | sed "s; -v;;g" `
  ( ls $OUT_FILES > buff.txt ) >& /dev/null
  set out_test = `cat buff.txt`; rm -f buff.txt

  #> delete previous output if requested
  if ( $CLOBBER_DATA == true || $CLOBBER_DATA == TRUE ) then
     echo 
     echo "Existing Logs and Output Files for Day ${TODAYG} Will Be Deleted"

     #> remove previous log files
     foreach file ( ${log_test} )
        #echo "Deleting log file: $file"
        rm -f $file  
     end
 
     #> remove previous output files
     foreach file ( ${out_test} )
        #echo "Deleting output file: $file"
        rm -f $file  
     end
        rm -f ${OUTDIR}/CCTM_DESID*${RUNID}_${YYYYMMDD}.nc

  else
     #> error if previous log files exist
     if ( "$log_test" != "" ) then
       echo "*** Logs exist - run ABORTED ***"
       echo "*** To overide, set CLOBBER_DATA = TRUE in run_cctm.csh ***"
       echo "*** and these files will be automatically deleted. ***"
       exit 1
     endif
     
     #> error if previous output files exist
     if ( "$out_test" != "" ) then
       echo "*** Output Files Exist - run will be ABORTED ***"
       foreach file ( $out_test )
          echo " cannot delete $file"
       end
       echo "*** To overide, set CLOBBER_DATA = TRUE in run_cctm.csh ***"
       echo "*** and these files will be automatically deleted. ***"
       exit 1
     endif
  endif

  #> for the run control ...
  setenv CTM_STDATE      $YYYYJJJ
  setenv CTM_STTIME      $STTIME
  setenv CTM_RUNLEN      $NSTEPS
  setenv CTM_TSTEP       $TSTEP
  setenv INIT_CONC_1 $ICpath/$ICFILE
  setenv BNDY_CONC_1 $BCpath/$BCFILE
  setenv OMI $OMIpath/$OMIfile
  setenv OPTICS_DATA $OMIpath/$OPTfile
  #setenv XJ_DATA $JVALpath/$JVALfile
 
  #> species defn & photolysis
  setenv gc_matrix_nml ${NMLpath}/GC_$MECH.nml
  setenv ae_matrix_nml ${NMLpath}/AE_$MECH.nml
  setenv nr_matrix_nml ${NMLpath}/NR_$MECH.nml
  setenv tr_matrix_nml ${NMLpath}/Species_Table_TR_0.nml

  #> check for photolysis input data
  setenv CSQY_DATA ${NMLpath}/CSQY_DATA_$MECH

  if (! (-e $CSQY_DATA ) ) then
     echo " $CSQY_DATA  not found "
     exit 1
  endif
  if (! (-e $OPTICS_DATA ) ) then
     echo " $OPTICS_DATA  not found "
     exit 1
  endif

# ===================================================================
#> Execution Portion
# ===================================================================

  #> Print attributes of the executable
  if ( $CTM_DIAG_LVL != 0 ) then
     ls -l $BLD/$EXEC
     size $BLD/$EXEC
     unlimit
     limit
  endif

  #> Print Startup Dialogue Information to Standard Out
  echo 
  echo "CMAQ Processing of Day $YYYYMMDD Began at `date`"
  echo 

  #> Executable call for single PE, uncomment to invoke
  #( /usr/bin/time -p $BLD/$EXEC ) |& tee buff_${EXECUTION_ID}.txt

  #> Executable call for multi PE, configure for your system 
  # set MPI = /usr/local/intel/impi/3.2.2.006/bin64
  # set MPIRUN = $MPI/mpirun
  ( time mpirun --oversubscribe -np $NPROCS $BLD/$EXEC ) |& tee buff_${EXECUTION_ID}.txt

  #> Harvest Timing Output so that it may be reported below
  set rtarray = "${rtarray} `tail -3 buff_${EXECUTION_ID}.txt | grep -Eo '[+-]?[0-9]+([.][0-9]+)?' | head -1` "
  rm -rf buff_${EXECUTION_ID}.txt

  #> Abort script if abnormal termination
  if ( ! -e $S_CGRID ) then
    echo ""
    echo "**************************************************************"
    echo "** Runscript Detected an Error: CGRID file was not written. **"
    echo "**   This indicates that CMAQ was interrupted or an issue   **"
    echo "**   exists with writing output. The runscript will now     **"
    echo "**   abort rather than proceeding to subsequent days.       **"
    echo "**************************************************************"
    break
  endif

  #> Print Concluding Text
  echo 
  echo "CMAQ Processing of Day $YYYYMMDD Finished at `date`"
  echo
  echo "\\\\\=====\\\\\=====\\\\\=====\\\\\=====/////=====/////=====/////=====/////"
  echo

# ===================================================================
#> Finalize Run for This Day and Loop to Next Day
  #> Save Log Files and Move on to Next Simulation Day
  mv CTM_LOG_???.${CTM_APPL} $LOGDIR
  if ( $CTM_DIAG_LVL != 0 ) then
    mv CTM_DIAG_???.${CTM_APPL} $LOGDIR
  endif

  #> The next simulation day will, by definition, be a restart
  setenv NEW_START false

  #> Increment both Gregorian and Julian Days
  set TODAYG = `date -ud "${TODAYG}+1days" +%Y-%m-%d` #> Add a day for tomorrow
  set TODAYJ = `date -ud "${TODAYG}" +%Y%j` #> Convert YYYY-MM-DD to YYYYJJJ

end  #Loop to the next Simulation Day

# ===================================================================
#> Generate Timing Report
# ===================================================================
set RTMTOT = 0
foreach it ( `seq ${NDAYS}` )
    set rt = `echo ${rtarray} | cut -d' ' -f${it}`
    set RTMTOT = `echo "${RTMTOT} + ${rt}" | bc -l`
end

set RTMAVG = `echo "scale=2; ${RTMTOT} / ${NDAYS}" | bc -l`
set RTMTOT = `echo "scale=2; ${RTMTOT} / 1" | bc -l`

echo
echo "=================================="
echo "  ***** CMAQ TIMING REPORT *****"
echo "=================================="
echo "Start Day: ${START_DATE}"
echo "End Day:   ${END_DATE}"
echo "Number of Simulation Days: ${NDAYS}"
echo "Domain Name:               ${GRID_NAME}"
echo "Number of Grid Cells:      ${NCELLS}  (ROW x COL x LAY)"
echo "Number of Layers:          ${NZ}"
echo "Number of Processes:       ${NPROCS}"
echo "   All times are in seconds."
echo
echo "Num  Day        Wall Time"
set d = 0
set day = ${START_DATE}
foreach it ( `seq ${NDAYS}` )
    # Set the right day and format it
    set d = `echo "${d} + 1"  | bc -l`
    set n = `printf "%02d" ${d}`

    # Choose the correct time variables
    set rt = `echo ${rtarray} | cut -d' ' -f${it}`

    # Write out row of timing data
    echo "${n}   ${day}   ${rt}"

    # Increment day for next loop
    set day = `date -ud "${day}+1days" +%Y-%m-%d`
end
echo "     Total Time = ${RTMTOT}"
echo "      Avg. Time = ${RTMAVG}"

exit
