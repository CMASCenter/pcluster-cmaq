#   Makefile generated for parallel execution using program bldmake
#
#   Generation date [02/23/2022  00:04:02]
#   Configuration file [/shared/build/openmpi_gcc/CMAQ_v533/CCTM/scripts/BLD_CCTM_v533_gcc/CCTM_v533.cfg.bld]
#   Using GIT repository [/shared/build/CMAQ_REPO_v533/CCTM/src]
#   With mechanism [cb6r3_ae7_aq]
#   Full Compiler Paths when Makefile was Built:
#       FC = /opt/amazon/openmpi/bin/mpifort
#       CC = /usr/bin/gcc
#   Library Paths:
#      $(LIB)/ioapi/include_files -> /shared/build/ioapi-3.2//ioapi/fixed_src
#      $(LIB)/ioapi/lib -> /shared/build/ioapi-3.2//Linux2_x86_64gfort
#      $(LIB)/mpi -> /opt/amazon/openmpi/lib
#      $(LIB)/netcdf -> /shared/build/netcdf/lib
#      $(LIB)/netcdff -> /shared/build/netcdf/lib
#
#   Command-Line Options:      
#      DEBUG = TRUE or true -- turn on debug flags 
#  OR  debug = true or TRUE -- turn on debug flags 
#  Can set either variable by using the setenv command for
#  a debugging session with multiple compilations
#
#------------------------------------------------- 

 EXEC = CCTM_v533.exe

 FC = mpifort
 CC = gcc

 LIB = /shared/build/openmpi_gcc/CMAQ_v533/lib/x86_64/gcc
 include_path = -I $(LIB)/ioapi/lib \
                -I $(LIB)/ioapi/include_files \
                -I $(LIB)/mpi -I.

 WARN = 
 FSTD = -O3 -funroll-loops -finit-character=32 -Wtabs -Wsurprising -ftree-vectorize  -ftree-loop-if-convert -finline-limit=512
 DBG  = -Wall -O0 -g -fcheck=all -ffpe-trap=invalid,zero,overflow -fbacktrace

 ifneq (,$(filter $(debug), TRUE true True T ))
     DEBUG = TRUE
 endif

 ifneq (,$(filter $(DEBUG), TRUE true ))
     f_FLAGS   = -ffixed-form -ffixed-line-length-132 -funroll-loops -finit-character=32 $(DBG) $(include_path)
     f90_FLAGS = -ffree-form -ffree-line-length-none -funroll-loops -finit-character=32 $(DBG) $(include_path)
 else
     f_FLAGS   = -ffixed-form -ffixed-line-length-132 -funroll-loops -finit-character=32 $(FSTD) $(include_path)
     f90_FLAGS = -ffree-form -ffree-line-length-none -funroll-loops -finit-character=32 $(FSTD) $(include_path)
 endif

 F_FLAGS   = $(f_FLAGS)
 F90_FLAGS = $(f90_FLAGS)
 C_FLAGS   = -O2 -DFLDMN -I$(LIB)/mpi/include -I.

 LINKER     = $(FC)
 LINK_FLAGS = -fopenmp

 REPOROOT = /shared/build/CMAQ_REPO_v533/CCTM/src

 CPP = $(FC)
 cpp_flags = \
  -Dparallel \
  -Dm3dry_opt \
  -DSUBST_BARRIER=SE_BARRIER \
  -DSUBST_GLOBAL_MAX=SE_GLOBAL_MAX \
  -DSUBST_GLOBAL_MIN=SE_GLOBAL_MIN \
  -DSUBST_GLOBAL_MIN_DATA=SE_GLOBAL_MIN_DATA \
  -DSUBST_GLOBAL_TO_LOCAL_COORD=SE_GLOBAL_TO_LOCAL_COORD \
  -DSUBST_GLOBAL_SUM=SE_GLOBAL_SUM \
  -DSUBST_GLOBAL_LOGICAL=SE_GLOBAL_LOGICAL \
  -DSUBST_LOOP_INDEX=SE_LOOP_INDEX \
  -DSUBST_SUBGRID_INDEX=SE_SUBGRID_INDEX \
  -DSUBST_HI_LO_BND_PE=SE_HI_LO_BND_PE \
  -DSUBST_SUM_CHK=SE_SUM_CHK \
  -DSUBST_SE_INIT=SE_INIT \
  -DSUBST_INIT_ARRAY=SE_INIT_ARRAY \
  -DSUBST_COMM=SE_COMM \
  -DSUBST_MY_REGION=SE_MY_REGION \
  -DSUBST_SLICE=SE_SLICE \
  -DSUBST_GATHER=SE_GATHER \
  -DSUBST_DATA_COPY=SE_DATA_COPY \
  -DSUBST_IN_SYN=SE_IN_SYN

 ifneq (,$(filter $(isam), TRUE true True T ))
     CPP_FLAGS   = -Disam $(cpp_flags)
 else
     CPP_FLAGS   = $(cpp_flags)
 endif

 IOAPI  = -L$(LIB)/ioapi/lib -lioapi
 NETCDF = -L$(LIB)/netcdff/lib -lnetcdff -L$(LIB)/netcdf/lib -lnetcdf
 MPICH  = -L$(LIB)/mpi/lib -lmpi
 LIBRARIES = $(IOAPI) $(NETCDF) $(MPICH)

 BASE_INC = .
 MPI_INC  = $(LIB)/mpi/include

 INCLUDES =  \
  -DSUBST_PE_COMM=\"$(BASE_INC)/PE_COMM.EXT\" \
  -DSUBST_CONST=\"$(BASE_INC)/CONST.EXT\" \
  -DSUBST_FILES_ID=\"$(BASE_INC)/FILES_CTM.EXT\" \
  -DSUBST_EMISPRM=\"$(BASE_INC)/EMISPRM.EXT\" \
  -DSUBST_MPI=\"$(MPI_INC)/mpif.h\"


GLOBAL_MODULES = \
  RXNS_DATA_MODULE.o \
  get_env_mod.o \
  UTILIO_DEFN.o \
  RUNTIME_VARS.o \
  HGRD_DEFN.o \
  PA_DEFN.o \
  VGRD_DEFN.o \
  STM_VARS.o \
  DEPVVARS.o \
  VDIFF_DATA.o \
  GRID_CONF.o \
  LSM_MOD.o \
  depv_data_module.o \
  CGRID_SPCS.o \
  BIDI_MOD.o \
  UDTYPES.o \
  stack_group_data_module.o \
  em_param_module.o \
  biog_emis_param_module.o \
  lus_data_module.o \
  AEROMET_DATA.o \
  crop_data_module.o \
  STK_PRMS.o \
  centralized_io_util_module.o \
  PTBILIN.o \
  AERO_DATA.o \
  EMIS_VARS.o \
  centralized_io_module.o \
  STK_EMIS.o \
  LUS_DEFN.o \
  LTNG_DEFN.o \
  BIOG_EMIS.o \
  PCGRID_DEFN.o \
  BEIS_DEFN.o \
  ASX_DATA_MOD.o \
  SSEMIS.o \
  PTMET.o \
  AVG_CONC.o \
  CSQY_DATA.o \
  CLOUD_OPTICS.o \
  complex_number_module.o \
  twoway_rrtmg_aero_optics.o \
  SOA_DEFN.o \
  AERO_PHOTDATA.o \
  WVEL_DEFN.o \
  RXNS_FUNC_MODULE.o \
  PRECURSOR_DATA.o \
  AEROSOL_CHEMISTRY.o \
  AERO_BUDGET.o \
  DEPV_DEFN.o \
  PT3D_DEFN.o \
  SA_DEFN.o \
  PHOT_MOD.o \
  PAGRD_DEFN.o \
  PA_IRR_CTL.o \
  PA_IRR_module.o \
  PISAM_DEFN.o \
  MGEMIS.o \
  SA_IRR_DEFN.o \
  VDIFF_MAP.o \
  DUST_EMIS.o \
  STD_CONC.o \
  vertext_module.o \
  STM_MODULE.o \
  HGSIM.o \
  AERO_EMIS.o \
  EMIS_DEFN.o

STENEX = \
  se_bndy_copy_info_ext.o \
  se_pe_info_ext.o \
  se_comm_info_ext.o \
  se_data_send_module.o \
  se_domain_info_ext.o \
  se_internal_util_module.o \
  se_data_recv_module.o \
  se_disp_info_ext.o \
  se_subgrid_info_ext.o \
  se_global_sum_module.o \
  se_global_max_module.o \
  se_global_min_module.o \
  se_slice_module.o \
  se_init_module.o \
  se_bndy_copy_module.o \
  se_comm_module.o \
  se_reconfig_grid_info_ext.o \
  se_reconfig_grid_module.o \
  se_gather_module.o \
  se_data_copy_module.o \
  se_term_module.o \
  se_twoway_comm_module.o \
  se_util_module.o \
  se_modules.o

PARIO = \
  alloc_data_mod.o \
  parutilio.o \
  piomaps_mod.o \
  get_write_map.o \
  pio_init.o \
  pm3err.o \
  pm3exit.o \
  pm3warn.o \
  pshut3.o \
  ptrwrite3.o \
  pwrgrdd.o \
  pwrite3.o \
  subdmap.o \
  wrsubdmap.o

PAR = \
  distr_env.o \
  mpcomm_init.o

DRIVER = \
  advstep.o \
  cmaq_main.o \
  driver.o \
  hveloc.o \
  sciproc.o \
  wr_aconc.o \
  wr_cgrid.o \
  wr_conc.o \
  wr_init.o

INIT = \
  diffmsg.o \
  flcheck.o \
  grdcheck.o \
  initscen.o \
  load_cgrid.o \
  opaconc.o \
  opconc.o

COUPLE = \
  couplewrf.o

HADV = \
  advbc_map.o \
  hadvppm.o \
  hcontvel.o \
  hppm.o \
  rdbcon.o \
  x_ppm.o \
  y_ppm.o \
  zfdbc.o

VADV = \
  vppm.o \
  zadvppmwrf.o

HDIFF = \
  deform.o \
  hcdiff3d.o \
  hdiff.o \
  rho_j.o

VDIFF = \
  VDIFF_DIAG.o \
  SEDIMENTATION.o \
  aero_depv.o \
  aero_sedv.o \
  conv_cgrid.o \
  eddyx.o \
  matrix1.o \
  opddep.o \
  rddepv.o \
  tri.o \
  vdiffacmx.o \
  vdiffproc.o

DEPV = \
  ABFLUX_MOD.o \
  cgrid_depv.o \
  gas_depv_map.o \
  m3dry.o \
  opdepv_diag.o

EMIS = \
  cropcal.o \
  opemis.o \
  tfabove.o \
  tfbelow.o

BIOG = \
  beis3.o \
  checkmem.o \
  chkgrid.o \
  czangle.o \
  getfline.o \
  getparb.o \
  hrno.o \
  parsline.o \
  tmpbeis.o \
  wrdaymsg.o

PLRISE = \
  delta_zs.o \
  fire_plmris.o \
  openlayout.o \
  oppt3d_diag.o \
  plmris.o \
  plsprd.o \
  preplm.o \
  write3_distr.o

PHOT = \
  PHOTOLYSIS_ALBEDO.o \
  PHOT_MET_DATA.o \
  SEAS_STRAT_O3_MIN.o \
  concld_prop_acm.o \
  o3totcol.o \
  opphot.o \
  phot.o

GAS = \
  DEGRADE_SETUP_TOX.o \
  hrdata_mod.o \
  degrade.o \
  degrade_data.o \
  final_degrade.o \
  find_degraded.o \
  hrdriver.o \
  hrg1.o \
  hrg2.o \
  hrg3.o \
  hrg4.o \
  hrinit.o \
  hrprodloss.o \
  hrrates.o \
  hrsolver.o \
  init_degrade.o

AERO = \
  PMDIAG_DATA.o \
  aero_driver.o \
  aero_subs.o \
  coags.o \
  getpar.o \
  isocom.o \
  isofwd.o \
  isorev.o \
  opapmdiag.o \
  oppmdiag.o

CLOUD = \
  AQ_DATA.o \
  acmcld.o \
  aq_map.o \
  aqchem.o \
  cldproc_acm.o \
  convcld_acm.o \
  getalpha.o \
  hlconst.o \
  indexn.o \
  opwdep.o \
  rescld.o \
  scavwdep.o

PROCAN = \
  PA_GLOBAL.o \
  PA_IPRDEF.o \
  PA_VARS.o \
  PA_PARSE.o \
  PA_IPRVARS.o \
  pa_compmech.o \
  pa_datagen.o \
  pa_errcheck.o \
  pa_getcoef.o \
  pa_getcycle.o \
  pa_getdesc.o \
  pa_getfamily.o \
  pa_getiprout.o \
  pa_getirrout.o \
  pa_getrxns.o \
  pa_getrxnsum.o \
  pa_init.o \
  pa_mkhdr.o \
  pa_molcloss.o \
  pa_molcprod.o \
  pa_output.o \
  pa_read.o \
  pa_report.o \
  pa_setup_ipr.o \
  pa_setup_irr.o \
  pa_update.o \
  pa_wrtpadefn.o

ISAM = \
  SA_WRAP_AE.o \
  op_sa.o \
  sa_array_init.o \
  sa_dim.o \
  sa_matrix1.o \
  sa_opwddep.o \
  sa_tri.o \
  wr_avg_sa.o \
  wr_sa.o \
  wr_sa_cgrid.o

UTIL = \
  log_header.o \
  cksummer.o \
  findex.o \
  lstepf.o \
  setup_logdev.o \
  subhdomain.o \
  subhfile.o

OBJS = \
  $(STENEX) \
  $(PARIO) \
  $(GLOBAL_MODULES) \
  $(PAR) \
  $(DRIVER) \
  $(INIT) \
  $(COUPLE) \
  $(HADV) \
  $(VADV) \
  $(HDIFF) \
  $(VDIFF) \
  $(DEPV) \
  $(EMIS) \
  $(BIOG) \
  $(PLRISE) \
  $(PHOT) \
  $(GAS) \
  $(AERO) \
  $(CLOUD) \
  $(PROCAN) \
  $(ISAM) \
  $(UTIL)

.SUFFIXES: .F .f .c .F90 .f90

$(EXEC): $(OBJS)
	$(LINKER) $(LINK_FLAGS) $(OBJS) $(LIBRARIES) -o $@

.F.o:
	$(FC) -c $(F_FLAGS) $(CPP_FLAGS) $(INCLUDES) $<

.f.o:
	$(FC) -c $(F_FLAGS) $<

.F90.o:
	$(FC) -c $(F90_FLAGS) $(CPP_FLAGS) $(INCLUDES) $<

.f90.o:
	$(FC) -c $(F90_FLAGS) $<

.c.o:
	$(CC) -c $(C_FLAGS) $<

clean:
	rm -f $(OBJS) *.mod


# dependencies

se_bndy_copy_module.o:	se_bndy_copy_info_ext.o se_internal_util_module.o \
		se_data_send_module.o se_data_recv_module.o se_pe_info_ext.o \
		se_domain_info_ext.o
se_comm_module.o:	se_comm_info_ext.o se_internal_util_module.o \
		se_data_send_module.o se_data_recv_module.o se_pe_info_ext.o \
		se_domain_info_ext.o
se_data_copy_module.o:	se_subgrid_info_ext.o se_pe_info_ext.o \
		se_data_send_module.o se_data_recv_module.o se_domain_info_ext.o
se_data_recv_module.o:	se_pe_info_ext.o
se_data_send_module.o:	se_pe_info_ext.o
se_gather_module.o:	se_pe_info_ext.o se_slice_module.o se_global_sum_module.o
se_global_max_module.o:	se_pe_info_ext.o
se_global_min_module.o:	se_pe_info_ext.o
se_global_sum_module.o:	se_pe_info_ext.o
se_init_module.o:	se_pe_info_ext.o se_domain_info_ext.o se_comm_info_ext.o \
		se_disp_info_ext.o se_bndy_copy_info_ext.o se_internal_util_module.o
se_internal_util_module.o:	se_pe_info_ext.o
se_modules.o:	se_init_module.o se_term_module.o se_util_module.o \
		se_comm_module.o se_slice_module.o se_data_copy_module.o se_gather_module.o \
		se_reconfig_grid_module.o se_bndy_copy_module.o se_global_max_module.o \
		se_global_min_module.o se_global_sum_module.o se_twoway_comm_module.o
se_reconfig_grid_module.o:	se_reconfig_grid_info_ext.o se_pe_info_ext.o \
		se_data_send_module.o se_data_recv_module.o se_domain_info_ext.o
se_slice_module.o:	se_pe_info_ext.o
se_term_module.o:	se_pe_info_ext.o se_domain_info_ext.o se_reconfig_grid_info_ext.o \
		se_subgrid_info_ext.o
se_twoway_comm_module.o:	se_comm_info_ext.o
se_util_module.o:	se_comm_info_ext.o se_domain_info_ext.o se_pe_info_ext.o \
		se_subgrid_info_ext.o se_internal_util_module.o
get_write_map.o:	piomaps_mod.o
pio_init.o:	piomaps_mod.o
pm3err.o:	RUNTIME_VARS.o
pm3exit.o:	RUNTIME_VARS.o
pshut3.o:	piomaps_mod.o
ptrwrite3.o:	RUNTIME_VARS.o piomaps_mod.o
pwrgrdd.o:	piomaps_mod.o alloc_data_mod.o
pwrite3.o:	piomaps_mod.o RUNTIME_VARS.o
mpcomm_init.o:	UTILIO_DEFN.o
AVG_CONC.o:	RUNTIME_VARS.o GRID_CONF.o CGRID_SPCS.o UTILIO_DEFN.o
STD_CONC.o:	RUNTIME_VARS.o HGRD_DEFN.o VGRD_DEFN.o CGRID_SPCS.o \
		UTILIO_DEFN.o
WVEL_DEFN.o:	GRID_CONF.o UTILIO_DEFN.o centralized_io_module.o \
		$(BASE_INC)/FILES_CTM.EXT
advstep.o:	GRID_CONF.o UTILIO_DEFN.o se_modules.o centralized_io_module.o \
		$(BASE_INC)/CONST.EXT $(BASE_INC)/FILES_CTM.EXT
cmaq_main.o:	RUNTIME_VARS.o UTILIO_DEFN.o
driver.o:	RXNS_DATA_MODULE.o CGRID_SPCS.o HGRD_DEFN.o VGRD_DEFN.o \
		get_env_mod.o LUS_DEFN.o AERO_DATA.o PCGRID_DEFN.o STD_CONC.o \
		AVG_CONC.o WVEL_DEFN.o PA_DEFN.o PAGRD_DEFN.o UTILIO_DEFN.o \
		RUNTIME_VARS.o ASX_DATA_MOD.o LSM_MOD.o BIDI_MOD.o SA_DEFN.o \
		PISAM_DEFN.o vertext_module.o centralized_io_module.o lus_data_module.o \
		se_modules.o $(BASE_INC)/FILES_CTM.EXT
hveloc.o:	GRID_CONF.o UTILIO_DEFN.o se_modules.o centralized_io_module.o \
		$(BASE_INC)/PE_COMM.EXT $(BASE_INC)/CONST.EXT $(BASE_INC)/FILES_CTM.EXT
sciproc.o:	UTILIO_DEFN.o RUNTIME_VARS.o se_modules.o PA_DEFN.o \
		SA_DEFN.o GRID_CONF.o CGRID_SPCS.o STM_MODULE.o
wr_aconc.o:	GRID_CONF.o AVG_CONC.o UTILIO_DEFN.o RUNTIME_VARS.o \
		se_modules.o $(BASE_INC)/FILES_CTM.EXT
wr_cgrid.o:	GRID_CONF.o CGRID_SPCS.o UTILIO_DEFN.o se_modules.o \
		$(BASE_INC)/FILES_CTM.EXT
wr_conc.o:	GRID_CONF.o STD_CONC.o WVEL_DEFN.o UTILIO_DEFN.o ASX_DATA_MOD.o \
		centralized_io_module.o $(BASE_INC)/FILES_CTM.EXT
wr_init.o:	GRID_CONF.o WVEL_DEFN.o STD_CONC.o UTILIO_DEFN.o se_modules.o \
		centralized_io_module.o $(BASE_INC)/FILES_CTM.EXT
GRID_CONF.o:	HGRD_DEFN.o VGRD_DEFN.o
HGRD_DEFN.o:	RUNTIME_VARS.o UTILIO_DEFN.o
PAGRD_DEFN.o:	RUNTIME_VARS.o GRID_CONF.o UTILIO_DEFN.o se_modules.o \
		PA_DEFN.o
PCGRID_DEFN.o:	GRID_CONF.o CGRID_SPCS.o UTILIO_DEFN.o
VGRD_DEFN.o:	RUNTIME_VARS.o UTILIO_DEFN.o
diffmsg.o:	UTILIO_DEFN.o
flcheck.o:	UTILIO_DEFN.o RUNTIME_VARS.o $(BASE_INC)/FILES_CTM.EXT
grdcheck.o:	GRID_CONF.o UTILIO_DEFN.o $(BASE_INC)/FILES_CTM.EXT
initscen.o:	RUNTIME_VARS.o HGRD_DEFN.o CGRID_SPCS.o UTILIO_DEFN.o \
		se_modules.o vertext_module.o SA_DEFN.o VGRD_DEFN.o $(BASE_INC)/FILES_CTM.EXT
load_cgrid.o:	GRID_CONF.o CGRID_SPCS.o UTILIO_DEFN.o RXNS_DATA_MODULE.o \
		AERO_DATA.o centralized_io_module.o $(BASE_INC)/CONST.EXT $(BASE_INC)/FILES_CTM.EXT
opaconc.o:	GRID_CONF.o AVG_CONC.o UTILIO_DEFN.o se_modules.o $(BASE_INC)/FILES_CTM.EXT
opconc.o:	GRID_CONF.o WVEL_DEFN.o STD_CONC.o UTILIO_DEFN.o se_modules.o \
		$(BASE_INC)/FILES_CTM.EXT
couplewrf.o:	GRID_CONF.o CGRID_SPCS.o UTILIO_DEFN.o centralized_io_module.o \
		SA_DEFN.o $(BASE_INC)/FILES_CTM.EXT
advbc_map.o:	CGRID_SPCS.o UTILIO_DEFN.o centralized_io_module.o \
		$(BASE_INC)/FILES_CTM.EXT
hadvppm.o:	GRID_CONF.o CGRID_SPCS.o UTILIO_DEFN.o se_modules.o \
		$(BASE_INC)/PE_COMM.EXT $(BASE_INC)/FILES_CTM.EXT
hcontvel.o:	GRID_CONF.o UTILIO_DEFN.o se_modules.o centralized_io_module.o \
		$(BASE_INC)/PE_COMM.EXT $(BASE_INC)/FILES_CTM.EXT
hppm.o:	HGRD_DEFN.o UTILIO_DEFN.o se_modules.o
rdbcon.o:	GRID_CONF.o CGRID_SPCS.o UTILIO_DEFN.o RXNS_DATA_MODULE.o \
		AERO_DATA.o centralized_io_module.o $(BASE_INC)/CONST.EXT $(BASE_INC)/FILES_CTM.EXT
x_ppm.o:	HGRD_DEFN.o CGRID_SPCS.o UTILIO_DEFN.o se_modules.o SA_DEFN.o \
		$(BASE_INC)/PE_COMM.EXT $(BASE_INC)/CONST.EXT
y_ppm.o:	HGRD_DEFN.o CGRID_SPCS.o UTILIO_DEFN.o se_modules.o SA_DEFN.o \
		$(BASE_INC)/PE_COMM.EXT $(BASE_INC)/CONST.EXT
vppm.o:	CGRID_SPCS.o UTILIO_DEFN.o SA_DEFN.o
zadvppmwrf.o:	GRID_CONF.o CGRID_SPCS.o WVEL_DEFN.o UTILIO_DEFN.o \
		SA_DEFN.o se_modules.o centralized_io_module.o $(BASE_INC)/FILES_CTM.EXT
deform.o:	GRID_CONF.o UTILIO_DEFN.o se_modules.o centralized_io_module.o \
		$(BASE_INC)/PE_COMM.EXT $(BASE_INC)/CONST.EXT $(BASE_INC)/FILES_CTM.EXT
hcdiff3d.o:	GRID_CONF.o UTILIO_DEFN.o centralized_io_module.o \
		se_modules.o $(BASE_INC)/PE_COMM.EXT $(BASE_INC)/CONST.EXT $(BASE_INC)/FILES_CTM.EXT
hdiff.o:	GRID_CONF.o CGRID_SPCS.o UTILIO_DEFN.o se_modules.o SA_DEFN.o \
		$(BASE_INC)/PE_COMM.EXT $(BASE_INC)/CONST.EXT
rho_j.o:	GRID_CONF.o UTILIO_DEFN.o centralized_io_module.o $(BASE_INC)/FILES_CTM.EXT
ASX_DATA_MOD.o:	RUNTIME_VARS.o GRID_CONF.o LSM_MOD.o DEPVVARS.o \
		centralized_io_module.o UTILIO_DEFN.o se_modules.o $(BASE_INC)/PE_COMM.EXT \
		$(BASE_INC)/CONST.EXT $(BASE_INC)/FILES_CTM.EXT
SEDIMENTATION.o:	CGRID_SPCS.o GRID_CONF.o ASX_DATA_MOD.o VDIFF_MAP.o \
		UTILIO_DEFN.o VDIFF_DIAG.o $(BASE_INC)/CONST.EXT $(BASE_INC)/FILES_CTM.EXT
VDIFF_DIAG.o:	RUNTIME_VARS.o UTILIO_DEFN.o GRID_CONF.o CGRID_SPCS.o \
		se_modules.o $(BASE_INC)/FILES_CTM.EXT
VDIFF_MAP.o:	VDIFF_DATA.o CGRID_SPCS.o UTILIO_DEFN.o DEPV_DEFN.o \
		$(BASE_INC)/EMISPRM.EXT
aero_depv.o:	GRID_CONF.o RXNS_DATA_MODULE.o CGRID_SPCS.o UTILIO_DEFN.o \
		AERO_DATA.o AEROMET_DATA.o ASX_DATA_MOD.o $(BASE_INC)/FILES_CTM.EXT
aero_sedv.o:	GRID_CONF.o CGRID_SPCS.o UTILIO_DEFN.o ASX_DATA_MOD.o \
		AERO_DATA.o AEROMET_DATA.o
conv_cgrid.o:	GRID_CONF.o CGRID_SPCS.o UTILIO_DEFN.o VDIFF_MAP.o \
		centralized_io_module.o SA_DEFN.o $(BASE_INC)/CONST.EXT $(BASE_INC)/FILES_CTM.EXT
eddyx.o:	GRID_CONF.o ASX_DATA_MOD.o UTILIO_DEFN.o
matrix1.o:	VGRD_DEFN.o CGRID_SPCS.o UTILIO_DEFN.o
opddep.o:	RUNTIME_VARS.o GRID_CONF.o CGRID_SPCS.o UTILIO_DEFN.o \
		$(BASE_INC)/FILES_CTM.EXT
rddepv.o:	HGRD_DEFN.o RXNS_DATA_MODULE.o CGRID_SPCS.o UTILIO_DEFN.o \
		centralized_io_module.o $(BASE_INC)/FILES_CTM.EXT
tri.o:	VGRD_DEFN.o CGRID_SPCS.o
vdiffacmx.o:	CGRID_SPCS.o GRID_CONF.o EMIS_VARS.o em_param_module.o \
		DEPV_DEFN.o ASX_DATA_MOD.o VDIFF_MAP.o UTILIO_DEFN.o VDIFF_DIAG.o \
		HGRD_DEFN.o SA_DEFN.o $(BASE_INC)/FILES_CTM.EXT
vdiffproc.o:	CGRID_SPCS.o GRID_CONF.o EMIS_VARS.o EMIS_DEFN.o \
		DEPV_DEFN.o ASX_DATA_MOD.o VDIFF_MAP.o UTILIO_DEFN.o BIDI_MOD.o \
		HGSIM.o SEDIMENTATION.o VDIFF_DIAG.o PA_DEFN.o SA_DEFN.o $(BASE_INC)/FILES_CTM.EXT
ABFLUX_MOD.o:	HGRD_DEFN.o UTILIO_DEFN.o BIDI_MOD.o depv_data_module.o \
		ASX_DATA_MOD.o LSM_MOD.o $(BASE_INC)/CONST.EXT $(BASE_INC)/FILES_CTM.EXT
BIDI_MOD.o:	RUNTIME_VARS.o GRID_CONF.o CGRID_SPCS.o UTILIO_DEFN.o \
		$(BASE_INC)/FILES_CTM.EXT
DEPV_DEFN.o:	RUNTIME_VARS.o HGRD_DEFN.o RXNS_DATA_MODULE.o CGRID_SPCS.o \
		DEPVVARS.o UTILIO_DEFN.o LSM_MOD.o BIDI_MOD.o ASX_DATA_MOD.o \
		$(BASE_INC)/CONST.EXT $(BASE_INC)/FILES_CTM.EXT
HGSIM.o:	HGRD_DEFN.o UTILIO_DEFN.o ASX_DATA_MOD.o LSM_MOD.o BIDI_MOD.o \
		DEPVVARS.o $(BASE_INC)/CONST.EXT $(BASE_INC)/FILES_CTM.EXT
LSM_MOD.o:	HGRD_DEFN.o UTILIO_DEFN.o RUNTIME_VARS.o $(BASE_INC)/FILES_CTM.EXT
cgrid_depv.o:	CGRID_SPCS.o HGRD_DEFN.o UTILIO_DEFN.o
gas_depv_map.o:	CGRID_SPCS.o DEPVVARS.o UTILIO_DEFN.o
m3dry.o:	RUNTIME_VARS.o HGRD_DEFN.o DEPVVARS.o VGRD_DEFN.o UTILIO_DEFN.o \
		se_modules.o ABFLUX_MOD.o ASX_DATA_MOD.o BIDI_MOD.o HGSIM.o \
		centralized_io_module.o $(BASE_INC)/PE_COMM.EXT $(BASE_INC)/FILES_CTM.EXT
opdepv_diag.o:	GRID_CONF.o DEPVVARS.o UTILIO_DEFN.o $(BASE_INC)/FILES_CTM.EXT
BEIS_DEFN.o:	RUNTIME_VARS.o HGRD_DEFN.o CGRID_SPCS.o BIOG_EMIS.o \
		UTILIO_DEFN.o EMIS_VARS.o $(BASE_INC)/CONST.EXT
BIOG_EMIS.o:	RUNTIME_VARS.o EMIS_VARS.o biog_emis_param_module.o \
		RXNS_DATA_MODULE.o UTILIO_DEFN.o CGRID_SPCS.o
DUST_EMIS.o:	LUS_DEFN.o AERO_DATA.o EMIS_VARS.o HGRD_DEFN.o ASX_DATA_MOD.o \
		UTILIO_DEFN.o lus_data_module.o centralized_io_module.o GRID_CONF.o \
		$(BASE_INC)/CONST.EXT $(BASE_INC)/FILES_CTM.EXT
EMIS_DEFN.o:	RUNTIME_VARS.o GRID_CONF.o EMIS_VARS.o VDIFF_MAP.o \
		UTILIO_DEFN.o CGRID_SPCS.o BEIS_DEFN.o MGEMIS.o LTNG_DEFN.o \
		PT3D_DEFN.o AERO_EMIS.o AERO_DATA.o SA_DEFN.o BIOG_EMIS.o SSEMIS.o \
		DUST_EMIS.o HGRD_DEFN.o ASX_DATA_MOD.o RXNS_DATA_MODULE.o centralized_io_module.o \
		UDTYPES.o $(BASE_INC)/CONST.EXT $(BASE_INC)/FILES_CTM.EXT
EMIS_VARS.o:	RUNTIME_VARS.o em_param_module.o UTILIO_DEFN.o AERO_DATA.o
LTNG_DEFN.o:	RUNTIME_VARS.o EMIS_VARS.o GRID_CONF.o CGRID_SPCS.o \
		UTILIO_DEFN.o centralized_io_module.o $(BASE_INC)/CONST.EXT \
		$(BASE_INC)/FILES_CTM.EXT
LUS_DEFN.o:	HGRD_DEFN.o UTILIO_DEFN.o lus_data_module.o $(BASE_INC)/FILES_CTM.EXT
MGEMIS.o:	RUNTIME_VARS.o HGRD_DEFN.o EMIS_VARS.o UTILIO_DEFN.o \
		CGRID_SPCS.o RXNS_DATA_MODULE.o centralized_io_module.o GRID_CONF.o \
		AEROMET_DATA.o ASX_DATA_MOD.o PCGRID_DEFN.o $(BASE_INC)/CONST.EXT \
		$(BASE_INC)/FILES_CTM.EXT
PT3D_DEFN.o:	UDTYPES.o GRID_CONF.o STK_PRMS.o STK_EMIS.o PTMET.o \
		PTBILIN.o UTILIO_DEFN.o RUNTIME_VARS.o EMIS_VARS.o stack_group_data_module.o \
		centralized_io_module.o PRECURSOR_DATA.o VGRD_DEFN.o $(BASE_INC)/CONST.EXT \
		$(BASE_INC)/FILES_CTM.EXT
PTBILIN.o:	RUNTIME_VARS.o
PTMET.o:	RUNTIME_VARS.o UDTYPES.o EMIS_VARS.o STK_PRMS.o stack_group_data_module.o \
		centralized_io_module.o HGRD_DEFN.o VGRD_DEFN.o
SSEMIS.o:	RUNTIME_VARS.o HGRD_DEFN.o AERO_DATA.o EMIS_VARS.o UTILIO_DEFN.o \
		se_modules.o GRID_CONF.o AEROMET_DATA.o ASX_DATA_MOD.o $(BASE_INC)/FILES_CTM.EXT
STK_EMIS.o:	UDTYPES.o EMIS_VARS.o UTILIO_DEFN.o AERO_DATA.o
STK_PRMS.o:	UDTYPES.o HGRD_DEFN.o UTILIO_DEFN.o stack_group_data_module.o
cropcal.o:	HGRD_DEFN.o UTILIO_DEFN.o crop_data_module.o
opemis.o:	RUNTIME_VARS.o VGRD_DEFN.o CGRID_SPCS.o UTILIO_DEFN.o \
		EMIS_VARS.o EMIS_DEFN.o AERO_DATA.o VDIFF_MAP.o $(BASE_INC)/FILES_CTM.EXT
stack_group_data_module.o:	UDTYPES.o
tfabove.o:	HGRD_DEFN.o ASX_DATA_MOD.o lus_data_module.o
tfbelow.o:	HGRD_DEFN.o lus_data_module.o UTILIO_DEFN.o
beis3.o:	BIOG_EMIS.o ASX_DATA_MOD.o
chkgrid.o:	UTILIO_DEFN.o
czangle.o:	UTILIO_DEFN.o ASX_DATA_MOD.o $(BASE_INC)/CONST.EXT
hrno.o:	RUNTIME_VARS.o HGRD_DEFN.o BIOG_EMIS.o ASX_DATA_MOD.o \
		UTILIO_DEFN.o se_modules.o centralized_io_module.o
parsline.o:	UTILIO_DEFN.o
tmpbeis.o:	GRID_CONF.o UTILIO_DEFN.o BIOG_EMIS.o centralized_io_module.o \
		se_modules.o
wrdaymsg.o:	UTILIO_DEFN.o
fire_plmris.o:	RUNTIME_VARS.o $(BASE_INC)/CONST.EXT
openlayout.o:	RUNTIME_VARS.o HGRD_DEFN.o UTILIO_DEFN.o
oppt3d_diag.o:	RUNTIME_VARS.o GRID_CONF.o UTILIO_DEFN.o EMIS_VARS.o
plmris.o:	RUNTIME_VARS.o $(BASE_INC)/CONST.EXT
preplm.o:	UTILIO_DEFN.o
write3_distr.o:	RUNTIME_VARS.o
CGRID_SPCS.o:	RUNTIME_VARS.o RXNS_DATA_MODULE.o UTILIO_DEFN.o \
		STM_VARS.o
AERO_PHOTDATA.o:	GRID_CONF.o UTILIO_DEFN.o AERO_DATA.o SOA_DEFN.o \
		AEROMET_DATA.o CSQY_DATA.o RXNS_DATA_MODULE.o CGRID_SPCS.o twoway_rrtmg_aero_optics.o \
		$(BASE_INC)/CONST.EXT
CLOUD_OPTICS.o:	VGRD_DEFN.o UTILIO_DEFN.o CSQY_DATA.o
CSQY_DATA.o:	RUNTIME_VARS.o UTILIO_DEFN.o RXNS_DATA_MODULE.o AERO_DATA.o \
		GRID_CONF.o
PHOTOLYSIS_ALBEDO.o:	UTILIO_DEFN.o se_modules.o PHOT_MOD.o PCGRID_DEFN.o \
		LSM_MOD.o centralized_io_module.o $(BASE_INC)/FILES_CTM.EXT
PHOT_MET_DATA.o:	GRID_CONF.o UTILIO_DEFN.o centralized_io_module.o \
		CLOUD_OPTICS.o $(BASE_INC)/CONST.EXT $(BASE_INC)/FILES_CTM.EXT
PHOT_MOD.o:	RUNTIME_VARS.o CSQY_DATA.o RXNS_DATA_MODULE.o GRID_CONF.o \
		UTILIO_DEFN.o CLOUD_OPTICS.o AERO_PHOTDATA.o $(BASE_INC)/CONST.EXT
SEAS_STRAT_O3_MIN.o:	GRID_CONF.o UTILIO_DEFN.o
concld_prop_acm.o:	GRID_CONF.o HGRD_DEFN.o UTILIO_DEFN.o PHOT_MET_DATA.o \
		ASX_DATA_MOD.o centralized_io_module.o $(BASE_INC)/CONST.EXT \
		$(BASE_INC)/FILES_CTM.EXT
o3totcol.o:	RUNTIME_VARS.o UTILIO_DEFN.o
opphot.o:	GRID_CONF.o RXNS_DATA_MODULE.o UTILIO_DEFN.o PHOT_MET_DATA.o \
		PHOT_MOD.o $(BASE_INC)/FILES_CTM.EXT
phot.o:	RXNS_DATA_MODULE.o GRID_CONF.o CGRID_SPCS.o UTILIO_DEFN.o \
		AERO_DATA.o PHOT_MOD.o AERO_PHOTDATA.o PHOTOLYSIS_ALBEDO.o PHOT_MET_DATA.o \
		CLOUD_OPTICS.o SEAS_STRAT_O3_MIN.o centralized_io_module.o se_modules.o \
		$(BASE_INC)/FILES_CTM.EXT
twoway_rrtmg_aero_optics.o:	complex_number_module.o
DEGRADE_SETUP_TOX.o:	CGRID_SPCS.o UTILIO_DEFN.o RXNS_DATA_MODULE.o \
		$(BASE_INC)/CONST.EXT
degrade.o:	RXNS_DATA_MODULE.o DEGRADE_SETUP_TOX.o
degrade_data.o:	RXNS_DATA_MODULE.o DEGRADE_SETUP_TOX.o
final_degrade.o:	DEGRADE_SETUP_TOX.o
find_degraded.o:	DEGRADE_SETUP_TOX.o
hrdriver.o:	HGRD_DEFN.o VGRD_DEFN.o CGRID_SPCS.o UTILIO_DEFN.o \
		RXNS_DATA_MODULE.o AEROSOL_CHEMISTRY.o RXNS_FUNC_MODULE.o SA_IRR_DEFN.o \
		SA_DEFN.o hrdata_mod.o PHOT_MOD.o PA_DEFN.o PA_IRR_CTL.o DEGRADE_SETUP_TOX.o \
		centralized_io_module.o $(BASE_INC)/CONST.EXT $(BASE_INC)/FILES_CTM.EXT \
		$(BASE_INC)/EMISPRM.EXT
hrg1.o:	hrdata_mod.o
hrg2.o:	hrdata_mod.o
hrg3.o:	hrdata_mod.o
hrg4.o:	hrdata_mod.o
hrinit.o:	UTILIO_DEFN.o hrdata_mod.o RXNS_DATA_MODULE.o RXNS_FUNC_MODULE.o \
		$(BASE_INC)/CONST.EXT
hrprodloss.o:	hrdata_mod.o
hrrates.o:	hrdata_mod.o
hrsolver.o:	RUNTIME_VARS.o UTILIO_DEFN.o RXNS_DATA_MODULE.o hrdata_mod.o \
		PA_IRR_module.o SA_IRR_DEFN.o CGRID_SPCS.o
init_degrade.o:	RUNTIME_VARS.o RXNS_DATA_MODULE.o DEGRADE_SETUP_TOX.o
RXNS_FUNC_MODULE.o:	RXNS_DATA_MODULE.o UTILIO_DEFN.o CGRID_SPCS.o
AEROMET_DATA.o:	$(BASE_INC)/CONST.EXT
AEROSOL_CHEMISTRY.o:	RUNTIME_VARS.o UTILIO_DEFN.o GRID_CONF.o \
		RXNS_DATA_MODULE.o AERO_DATA.o AEROMET_DATA.o PRECURSOR_DATA.o \
		SOA_DEFN.o $(BASE_INC)/CONST.EXT
AERO_DATA.o:	RUNTIME_VARS.o RXNS_DATA_MODULE.o CGRID_SPCS.o AEROMET_DATA.o \
		UTILIO_DEFN.o VDIFF_DATA.o
AERO_EMIS.o:	AERO_DATA.o EMIS_VARS.o GRID_CONF.o DUST_EMIS.o PRECURSOR_DATA.o \
		RUNTIME_VARS.o SSEMIS.o UTILIO_DEFN.o VDIFF_MAP.o AEROMET_DATA.o \
		ASX_DATA_MOD.o $(BASE_INC)/CONST.EXT $(BASE_INC)/FILES_CTM.EXT
PRECURSOR_DATA.o:	RXNS_DATA_MODULE.o AERO_DATA.o CGRID_SPCS.o \
		UTILIO_DEFN.o RUNTIME_VARS.o AEROMET_DATA.o
SOA_DEFN.o:	RXNS_DATA_MODULE.o AERO_DATA.o AEROMET_DATA.o CGRID_SPCS.o \
		RUNTIME_VARS.o UTILIO_DEFN.o $(BASE_INC)/CONST.EXT
aero_driver.o:	GRID_CONF.o RXNS_DATA_MODULE.o AERO_DATA.o PRECURSOR_DATA.o \
		SOA_DEFN.o AEROMET_DATA.o UTILIO_DEFN.o CGRID_SPCS.o AEROSOL_CHEMISTRY.o \
		PMDIAG_DATA.o RUNTIME_VARS.o AERO_BUDGET.o centralized_io_module.o \
		$(BASE_INC)/FILES_CTM.EXT
aero_subs.o:	AERO_DATA.o PRECURSOR_DATA.o SOA_DEFN.o AEROMET_DATA.o \
		UTILIO_DEFN.o AERO_BUDGET.o GRID_CONF.o $(BASE_INC)/CONST.EXT
getpar.o:	AERO_DATA.o AEROMET_DATA.o
opapmdiag.o:	GRID_CONF.o UTILIO_DEFN.o PMDIAG_DATA.o $(BASE_INC)/FILES_CTM.EXT
oppmdiag.o:	GRID_CONF.o UTILIO_DEFN.o RXNS_DATA_MODULE.o PMDIAG_DATA.o \
		$(BASE_INC)/FILES_CTM.EXT
AQ_DATA.o:	AERO_DATA.o RUNTIME_VARS.o CGRID_SPCS.o UTILIO_DEFN.o \
		PHOT_MOD.o $(BASE_INC)/CONST.EXT
aq_map.o:	CGRID_SPCS.o AERO_DATA.o AQ_DATA.o UTILIO_DEFN.o $(BASE_INC)/CONST.EXT
aqchem.o:	RXNS_DATA_MODULE.o AQ_DATA.o AERO_DATA.o UTILIO_DEFN.o \
		SA_DEFN.o $(BASE_INC)/CONST.EXT
cldproc_acm.o:	RUNTIME_VARS.o GRID_CONF.o CGRID_SPCS.o UTILIO_DEFN.o \
		centralized_io_module.o SA_DEFN.o $(BASE_INC)/CONST.EXT $(BASE_INC)/FILES_CTM.EXT
convcld_acm.o:	RUNTIME_VARS.o GRID_CONF.o CGRID_SPCS.o UTILIO_DEFN.o \
		AQ_DATA.o AERO_DATA.o PRECURSOR_DATA.o RXNS_DATA_MODULE.o ASX_DATA_MOD.o \
		PHOT_MOD.o centralized_io_module.o SA_DEFN.o $(BASE_INC)/CONST.EXT \
		$(BASE_INC)/FILES_CTM.EXT
getalpha.o:	AERO_DATA.o $(BASE_INC)/CONST.EXT
hlconst.o:	UTILIO_DEFN.o
opwdep.o:	GRID_CONF.o CGRID_SPCS.o UTILIO_DEFN.o $(BASE_INC)/CONST.EXT \
		$(BASE_INC)/FILES_CTM.EXT
rescld.o:	RUNTIME_VARS.o GRID_CONF.o CGRID_SPCS.o UTILIO_DEFN.o \
		AQ_DATA.o AERO_DATA.o PRECURSOR_DATA.o ASX_DATA_MOD.o PHOT_MOD.o \
		centralized_io_module.o SA_DEFN.o $(BASE_INC)/CONST.EXT $(BASE_INC)/FILES_CTM.EXT
scavwdep.o:	CGRID_SPCS.o UTILIO_DEFN.o $(BASE_INC)/CONST.EXT
PA_GLOBAL.o:	RXNS_DATA_MODULE.o
PA_IPRDEF.o:	PA_DEFN.o
PA_IPRVARS.o:	PA_GLOBAL.o PA_VARS.o
PA_IRR_CTL.o:	GRID_CONF.o CGRID_SPCS.o PA_DEFN.o PAGRD_DEFN.o
PA_IRR_module.o:	GRID_CONF.o RXNS_DATA_MODULE.o CGRID_SPCS.o PA_DEFN.o \
		UTILIO_DEFN.o
PA_PARSE.o:	UTILIO_DEFN.o
PA_VARS.o:	PA_GLOBAL.o CGRID_SPCS.o
pa_compmech.o:	UTILIO_DEFN.o PA_GLOBAL.o PA_VARS.o PA_PARSE.o
pa_datagen.o:	RUNTIME_VARS.o UTILIO_DEFN.o PA_VARS.o PA_DEFN.o
pa_errcheck.o:	UTILIO_DEFN.o PA_GLOBAL.o CGRID_SPCS.o PA_IPRVARS.o \
		PA_VARS.o PA_PARSE.o PA_IPRDEF.o PA_DEFN.o
pa_getcoef.o:	UTILIO_DEFN.o PA_GLOBAL.o PA_PARSE.o
pa_getcycle.o:	UTILIO_DEFN.o PA_VARS.o PA_PARSE.o
pa_getdesc.o:	UTILIO_DEFN.o PA_GLOBAL.o PA_VARS.o PA_DEFN.o PA_PARSE.o
pa_getfamily.o:	UTILIO_DEFN.o PA_VARS.o PA_PARSE.o
pa_getiprout.o:	UTILIO_DEFN.o PA_DEFN.o PA_IPRVARS.o PA_PARSE.o
pa_getirrout.o:	UTILIO_DEFN.o PA_GLOBAL.o PA_VARS.o PA_DEFN.o \
		PA_PARSE.o
pa_getrxns.o:	PA_GLOBAL.o PA_VARS.o PA_PARSE.o
pa_getrxnsum.o:	UTILIO_DEFN.o PA_GLOBAL.o PA_VARS.o PA_PARSE.o
pa_init.o:	GRID_CONF.o PAGRD_DEFN.o UTILIO_DEFN.o se_modules.o \
		PA_DEFN.o $(BASE_INC)/FILES_CTM.EXT
pa_mkhdr.o:	GRID_CONF.o CGRID_SPCS.o UTILIO_DEFN.o PA_DEFN.o PAGRD_DEFN.o
pa_molcloss.o:	PA_GLOBAL.o PA_VARS.o
pa_molcprod.o:	PA_GLOBAL.o PA_VARS.o
pa_output.o:	GRID_CONF.o PAGRD_DEFN.o UTILIO_DEFN.o se_modules.o \
		PA_DEFN.o $(BASE_INC)/FILES_CTM.EXT
pa_read.o:	UTILIO_DEFN.o PA_GLOBAL.o PA_VARS.o PA_DEFN.o PA_PARSE.o
pa_report.o:	UTILIO_DEFN.o PA_GLOBAL.o PA_VARS.o PA_IPRVARS.o \
		PA_DEFN.o PA_PARSE.o
pa_setup_ipr.o:	UTILIO_DEFN.o PA_GLOBAL.o PA_VARS.o PA_IPRVARS.o \
		PA_IPRDEF.o PA_DEFN.o PA_PARSE.o CGRID_SPCS.o
pa_setup_irr.o:	UTILIO_DEFN.o PA_GLOBAL.o PA_DEFN.o PA_VARS.o \
		PA_PARSE.o
pa_update.o:	GRID_CONF.o CGRID_SPCS.o VDIFF_MAP.o PA_DEFN.o PAGRD_DEFN.o \
		UTILIO_DEFN.o EMIS_VARS.o centralized_io_module.o se_modules.o \
		AERO_BUDGET.o $(BASE_INC)/CONST.EXT $(BASE_INC)/FILES_CTM.EXT \
		$(BASE_INC)/EMISPRM.EXT
pa_wrtpadefn.o:	UTILIO_DEFN.o PA_VARS.o PA_IPRVARS.o PA_PARSE.o \
		PA_DEFN.o
PISAM_DEFN.o:	GRID_CONF.o UTILIO_DEFN.o
SA_DEFN.o:	UTILIO_DEFN.o RUNTIME_VARS.o GRID_CONF.o CGRID_SPCS.o \
		RXNS_DATA_MODULE.o
SA_IRR_DEFN.o:	HGRD_DEFN.o VGRD_DEFN.o UTILIO_DEFN.o RXNS_DATA_MODULE.o \
		SA_DEFN.o GRID_CONF.o CGRID_SPCS.o $(BASE_INC)/CONST.EXT
SA_WRAP_AE.o:	GRID_CONF.o CGRID_SPCS.o SA_DEFN.o UTILIO_DEFN.o \
		AERO_BUDGET.o AERO_DATA.o centralized_io_module.o $(BASE_INC)/CONST.EXT \
		$(BASE_INC)/FILES_CTM.EXT
op_sa.o:	GRID_CONF.o SA_DEFN.o UTILIO_DEFN.o RXNS_DATA_MODULE.o \
		RUNTIME_VARS.o se_modules.o $(BASE_INC)/FILES_CTM.EXT
sa_array_init.o:	GRID_CONF.o UTILIO_DEFN.o CGRID_SPCS.o SA_DEFN.o \
		RUNTIME_VARS.o se_modules.o $(BASE_INC)/FILES_CTM.EXT
sa_dim.o:	UTILIO_DEFN.o SA_DEFN.o EMIS_VARS.o
sa_matrix1.o:	VGRD_DEFN.o SA_DEFN.o UTILIO_DEFN.o
sa_opwddep.o:	GRID_CONF.o UTILIO_DEFN.o SA_DEFN.o se_modules.o \
		$(BASE_INC)/FILES_CTM.EXT
sa_tri.o:	VGRD_DEFN.o SA_DEFN.o
wr_avg_sa.o:	GRID_CONF.o UTILIO_DEFN.o SA_DEFN.o RUNTIME_VARS.o \
		se_modules.o $(BASE_INC)/FILES_CTM.EXT
wr_sa.o:	GRID_CONF.o UTILIO_DEFN.o SA_DEFN.o RUNTIME_VARS.o se_modules.o \
		$(BASE_INC)/FILES_CTM.EXT
wr_sa_cgrid.o:	GRID_CONF.o UTILIO_DEFN.o SA_DEFN.o se_modules.o \
		$(BASE_INC)/FILES_CTM.EXT
RUNTIME_VARS.o:	get_env_mod.o RXNS_DATA_MODULE.o $(BASE_INC)/FILES_CTM.EXT
UTILIO_DEFN.o:	parutilio.o
cksummer.o:	GRID_CONF.o CGRID_SPCS.o RUNTIME_VARS.o UTILIO_DEFN.o \
		se_modules.o
lstepf.o:	UTILIO_DEFN.o $(BASE_INC)/FILES_CTM.EXT
setup_logdev.o:	RUNTIME_VARS.o UTILIO_DEFN.o log_header.o
subhdomain.o:	UTILIO_DEFN.o
subhfile.o:	GRID_CONF.o UTILIO_DEFN.o $(BASE_INC)/FILES_CTM.EXT
vertext_module.o:	STD_CONC.o GRID_CONF.o RUNTIME_VARS.o UTILIO_DEFN.o \
		se_modules.o piomaps_mod.o ASX_DATA_MOD.o WVEL_DEFN.o $(BASE_INC)/FILES_CTM.EXT
STM_MODULE.o:	GRID_CONF.o RUNTIME_VARS.o RXNS_DATA_MODULE.o AERO_BUDGET.o \
		AERO_DATA.o STM_VARS.o UTILIO_DEFN.o
centralized_io_module.o:	RUNTIME_VARS.o centralized_io_util_module.o \
		get_env_mod.o UTILIO_DEFN.o HGRD_DEFN.o VGRD_DEFN.o LSM_MOD.o \
		CGRID_SPCS.o STK_PRMS.o stack_group_data_module.o biog_emis_param_module.o \
		depv_data_module.o crop_data_module.o lus_data_module.o BIDI_MOD.o \
		GRID_CONF.o em_param_module.o $(BASE_INC)/FILES_CTM.EXT
