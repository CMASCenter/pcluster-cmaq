# Run DESID CMAQ on hpc7g.16xlarge

## Run CMAQ for DESID

### Edit the DESID Namelist

1. **Edit the CMAQ DESID Chemical Species Control File**

```
cd /shared/build/openmpi_gcc/CMAQ_v54+/CCTM/scripts/BLD_CCTM_v54+_gcc
cp CMAQ_Control_DESID_cb6r5_ae7_aq.nml CMAQ_Control_DESID_cb6r5_ae7_aq_RED_EGU_POINT_NY.nml
vi CMAQ_Control_DESID_cb6r5_ae7_aq_RED_EGU_POINT_NY.nml
```

2. **Add the following lines to the bottom of the file according to the DESID Tutorial Instructions**

https://github.com/USEPA/CMAQ/blob/main/DOCS/Users_Guide/Tutorials/CMAQ_UG_tutorial_emissions.md#scale_stream
(place the line before the / file marker)

```csh
   ! PT_EGU Emissions Scaling reduce PT_EGU emissions in New York by 25%. Note, to reduce the emissions by 25% we use DESID to multiply what had been 100% emissions by .75, so that the resulting emissions is reduced by 25%.
   'NY'  , 'PT_EGU'      ,'All'    ,'All'         ,'All' ,.75    ,'UNIT','o',
```

3. **Activate DESID Diagnostics**

Create a DESID Control File and edit it to define NY as a region, and activate DESID emissions diagnostics
Define NY as a region in the DESID Region Definitions

```csh
cp CMAQ_Control_DESID.nml CMAQ_Control_DESID_RED_EGU_POINT_NY.nml
vi  CMAQ_Control_DESID_RED_EGU_POINT_NY.nml &
```

Modify the following section to use the NY region that is specified in the CMAQ_MASKS file, note the CMAQ_MASKS file is defined in the DESID Run script.

```csh
&Desid_RegionDef
 Desid_Reg_nml  =
 !            Region Label   | File_Label  | Variable on File
 !              'EVERYWHERE'  ,'N/A'        ,'N/A',
               'NY'         ,'CMAQ_MASKS' ,'NY',
 !<Example>    'ALL'         ,'ISAM_REGIONS','ALL',
/
```

4. **Create two stream family definitions, one that includes all point source emissions, and the second that only contains PT_EGU**

```csh
!------------------------------------------------------------------------------!
! Emissions Scaling Family Definitions                                         !
!    This component includes definitions for families of emission streams and  !
!    region combinations.                                                      !
!------------------------------------------------------------------------------!
&Desid_StreamFamVars
 Desid_N_Stream_Fams = 2           ! Exact number of stream family definitions
 Desid_Max_Stream_Fam_Members = 20 ! Larger than the number of streams on all
                                   ! family definitions
/

&Desid_StreamFam
! For emission streams available in several run scripts under CCTM/scripts

  StreamFamilyName(1)     = 'PT_SOURCES'
  StreamFamilyMembers(1,1:8)= 'PT_NONEGU','PT_OTHER', 'PT_AGFIRES', 'PT_FIRES', 'PT_RXFIRES', 'PT_OTHFIRES', 'PT_OILGAS','PT_CMV_C1C2'

  StreamFamilyName(2)     = 'PT_EGUS'
  StreamFamilyMembers(2,1:1)= 'PT_EGU'
&Desid_Diag
```

5. **activate DESID diagnostics to report the reduction in PT_EGU emissions.**

Note, if you define only one diagnostic rule, you must comment out all other rules.

```csh
&Desid_DiagVars
  Desid_N_Diag_Rules = 1    ! Exact Number of Diagnostic Rules Below
  Desid_Max_Diag_Streams=20 ! Maximum number of species variables on all rules
                            ! below (do not count expansions)
  Desid_Max_Diag_Spec = 80  ! Maximum number of species variables on all rules
                            ! below (do not count expansions)
/
```

```csh
! Create a diagnostic of the sum of the components of the PT_SOURCES
 ! family (defined in the stream family section). This file will be column sums
 ! and will include all the emitted species as long as they appear on at least
 ! one of the streams within PT_SOURCES.



    Desid_Diag_Streams_Nml(1,:)= 'PT_EGUS'
    Desid_Diag_Fmt_Nml(1)      = 'COLSUM'
    Desid_Diag_Spec_Nml(1,:)   = 'ALL'
```

6. **Verify that the settings are correct by comparing to the version in the github repo directory**

```csh
diff CMAQ_Control_DESID_RED_EGU_POINT_NY.nml /shared/pcluster-cmaq/qa_scripts/workshop/CMAQ_Control_DESID_RED_EGU_POINT_NY.nml
```

7. **Copy the Run script and edit it to use the DESID namelist files**

```csh
cd /shared/build/openmpi_gcc/CMAQ_v54+/CCTM/scripts/BLD_CCTM_v54+_gcc
cp run_cctm_2018_12US1_v54_cb6r5_ae6.20171222.3x64.ncclassic.csh run_cctm_2018_12US1_v54_cb6r5_ae6.20171222.3x64.ncclassic_DESID_RED_NY.csh
```


### Edit runscript to use DESID Namelist

1. **Copy the Run script and edit it to use the DESID namelist files**

```csh
cd /shared/build/openmpi_gcc/CMAQ_v54+/CCTM/scripts/BLD_CCTM_v54+_gcc
cp run_cctm_2018_12US1_v54_cb6r5_ae6.20171222.3x64.ncclassic.csh run_cctm_2018_12US1_v54_cb6r5_ae6.20171222.3x64.ncclassic_DESID_RED_NY.csh
```

2. **Change APPL to a new name**

```csh
set APPL      = 12US1_DESID_REDUCE        #> Application Name (e.g. Gridname)
```

3. **Verify the following emission stream names match the names used in the DESID namelist.**

```csh
grep STK_EMIS_LAB_00 ../run_cctm_2018_12US1_v54_cb6r5_ae6.20171222.3x64.ncclassic.DESID_RED_NY.csh
```

Output

```
setenv STK_EMIS_LAB_001 PT_NONEGU
setenv STK_EMIS_LAB_002 PT_EGU
setenv STK_EMIS_LAB_003 PT_OTHER
setenv STK_EMIS_LAB_004 PT_AGFIRES
setenv STK_EMIS_LAB_005 PT_FIRES
setenv STK_EMIS_LAB_006 PT_RXFIRES
setenv STK_EMIS_LAB_007 PT_OTHFIRES
setenv STK_EMIS_LAB_008 PT_OILGAS
setenv STK_EMIS_LAB_009 PT_CMV_C1C2
```

4. **Compare the above settings to those used in the Emission Stream Family defined in the DESID Namelist.**

```csh
grep -A 2 -B 2 StreamFamilyMembers CMAQ_Control_DESID_RED_EGU_POINT_NY.nml
```


Output

```
  StreamFamilyName(1)     = 'PT_SOURCES'
  StreamFamilyMembers(1,1:4)= 'PT_NONEGU','PT_OTHER', 'PT_AGFIRES', 'PT_FIRES', 'PT_RXFIRES', 'PT_OTHFIRES', 'PT_OILGAS','PT_CMV_C1C2'

  StreamFamilyName(2)     = 'PT_EGUS'
  StreamFamilyMembers(2,1:1)= 'PT_EGU'
```

```{note}
CMAQ won’t crash if the stream name in CMAQ_Control_DESID_<MECH>_RED_EGU_POINT_NY.nml was set incorrectly. CMAQ just ignores the incorrect stream name and won’t apply scaling.
```

5. **Update the DESID namelist file names in the run script to use the Reduced PT_EGU and diagnostic instructions.**

```csh
cd  /shared/build/openmpi_gcc/CMAQ_v54+/CCTM/scripts/BLD_CCTM_v54+_gcc
vi run_cctm_2018_12US1_v54_cb6r5_ae6.20171222.3x64.ncclassic_DESID_RED_NY.csh
```

Modify the namelist setting to use the DESID namelist:

```csh
setenv DESID_CTRL_NML ${BLD}/CMAQ_Control_DESID_RED_EGU_POINT_NY.nml
setenv DESID_CHEM_CTRL_NML ${BLD}/CMAQ_Control_DESID_${MECH}_RED_EGU_POINT_NY.nml
```

6. **Update the Spatial Masks for Emissions Scaling to use a file that contains state definitions for New York.**

```csh
#> Spatial Masks For Emissions Scaling
  setenv CMAQ_MASKS $SZpath/GRIDMASK_STATES_12US1_m3clple_12listos.ncf
```

7. **Verify that the file contains New York**

```csh
ncdump /shared/build/GRIDMASK/GRIDMASK_STATES_12US1.nc | grep NY
```

Output

```csh
    float NY(TSTEP, LAY, ROW, COL) ;
        NY:long_name = "NY              " ;
        NY:units = "fraction        " ;
        NY:var_desc = "NY fractional area per grid cell
```

### Run CMAQ using DESID

```{note}
The CMAQ run script has been configured to run on 192 cores (3 compute nodes of hpc7g with 64 cores/node)
```


1. **Change directories to the run script location**

```csh
cd /shared/build/openmpi_gcc/CMAQ_v54+/CCTM/scripts
```

2. **Submit the Run script to the SLURM queue**
```csh
sbatch run_cctm_2018_12US1_v54_cb6r5_ae6.20171222.3x64.ncclassic.DESID_RED_NY.csh
```

3. **Check the status of the job**

```csh
squeue
```

Output

```
             JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
                 1   compute     CMAQ   ec2-user CF       0:30      3 compute-dy-hpc7g-[1-3]
```

Wait for the status to change from CF to R

4. **Login to the compute node, install  and run htop**

```csh
ssh -Y compute-dy-hpc7g-1
sudo yum install -y htop
htop
```

![ec2-user](/static/images/2-run-cmaq-htop.png)

Htop should show that 64 processes are running and that 80.2G out of 124 G of memory is being used.
~                                                                                                                

### Review Log file from DESID run

```{note}
The CMAQ run script has been configured to run on 192 cores (3 compute nodes of hpc7g with 64 cores/node)
```


1. **Review the Emissions Scaling Report Section in the CTM_LOG File to verify that for the NY region, the EGU emissions were scaled by 75%**

```csh
cd output_v54+_cb6r5_ae7_aq_WR413_MYR_gcc_2018_12US1_3x64_classic_DESID_REDUCE
grep -A 20 'Stream Type: "Point Emissions File   2' CTM_LOG_001*
```

Output:

```csh
     Stream Type: "Point Emissions File   2" | Sector Label: PT_EGU (04)

        Table of Aerosol Size Distributions Available for Use Sector-Wide.
        Note that Mode 1 is reserved for gas-phase species and emission variable.
          Number  Em. Var.  Mode  Reference Mode (see AERO_DATA.F)
          ------  --------------  --------------------------------
          2       FINE                        FINE_REF
          3       COARSE                    COARSE_REF

        CMAQ Species     Phase/Mode  Em. Var.          Region             Op ScaleFac Basis FinalFac
        ------------     ----------  ---------         ------             -- -------- ----- --------
          NO2              GAS        NO2              EVERYWHERE         a   1.000    UNIT   1.000
                                                       NY                 o   0.750    UNIT   0.750
          NO               GAS        NO               EVERYWHERE         a   1.000    UNIT   1.000
                                                       NY                 o   0.750    UNIT   0.750
          HONO             GAS        HONO             EVERYWHERE         a   1.000    UNIT   1.000
                                                       NY                 o   0.750    UNIT   0.750
          SO2              GAS        SO2              EVERYWHERE         a   1.000    UNIT   1.000
                                                       NY                 o   0.750    UNIT   0.750
          SULF             GAS        SULF             EVERYWHERE         a   0.000    UNIT   0.000
                                                       NY                 o   0.750    UNIT   0.750
```

