# Script modified to work with all processors
# Script author: Jesse Bash
# Affiliation: US EPA Office of Research and Development
# This script assumes that the log files are located in ./CCTM/scripts as output by the CMAQ run script 
# These are the single output files, not the CTM_LOG files found in the $OUTDIR/LOGS directory
library(RColorBrewer)
library(stringr)

sens.dir  <- '/proj/ie/proj/CMAS/CMAQ/cyclecloud-cmaq/run_scripts/CycleCloud_HB120v3_lustre3_250/'
base.dir  <- '/proj/ie/proj/CMAS/CMAQ/pcluster-cmaq/run_scripts/hpc6a/logs/'
#files   <- dir(sens.dir, pattern ='run_cctmv5.3.3_Bench_2016_12US2.hpc6a.48xlarge.96.1x96.12x8pe.2day.pcluster.pin.codemod.log')
files <-c('run_cctmv5.3.3_Bench_2016_12US2.96.12x8pe.2day.cyclecloud.lustre3.codemod.pin.precision.log','run_cctmv5.3.3_Bench_2016_12US2.2x96.192.16x12pe.2day.cyclecloud.lustre3.codemod.pin.precision.log', 'run_cctmv5.3.3_Bench_2016_12US2.288.16x18pe.2day.cyclecloud.lustre3.codemod.pin.precision.log', 'run_cctmv5.3.3_Bench_2016_12US2.384.24x16pe.2day.cyclecloud.lustre3.codemod.pin.precision.log', 'run_cctmv5.3.3_Bench_2016_12US2.480.24x20pe.2day.cyclecloud.lustre3.codemod.pin.precision.log','run_cctmv5.3.3_Bench_2016_12US2.576.24x24pe.2day.cyclecloud.lustre3.codemod.pin.precision.log')
#b.files <- dir(base.dir,pattern='run_cctmv5.3.3_Bench_2016_12US2.576.24x24pe.2day.cyclecloud.data.codemod.nopin.redo.log')
#b.files <- dir(base.dir,pattern='run_cctmv5.3.3_Bench_2016_12US2.*.2day.cyclecloud.data.codemod.pin.log')
b.files <- c('run_cctmv5.3.3_Bench_2016_12US2.hpc6a.48xlarge.96.1x96.12x8pe.2day.pcluster.pin.codemod.log','run_cctmv5.3.3_Bench_2016_12US2.hpc6a.48xlarge.192.2x96.16x12pe.2day.pcluster.pin.codemod.log','run_cctmv5.3.3_Bench_2016_12US2.hpc6a.48xlarge.288.3x96.16x18pe.2day.pcluster.pin.codemod.log','run_cctmv5.3.3_Bench_2016_12US2.hpc6a.48xlarge.384.4x96.24x16pe.2day.pcluster.pin.codemod.log','run_cctmv5.3.3_Bench_2016_12US2.hpc6a.48xlarge.480.5x96.24x20pe.2day.pcluster.pin.log','run_cctmv5.3.3_Bench_2016_12US2.hpc6a.48xlarge.576.6x96.24x24pe.2day.pcluster.pin.log')
#Compilers <- c('intel','gcc','pgi')
Compilers <- c('')
# name of the base case timing. I am using the current master branch from the CMAQ_Dev repository.
# The project directory name is used for the sensitivity case.
base.name <- c('96','192','288','384','480','576')
#base.name <- c('data_pin')
sens.name <- c('96','192','288','384','480','576')

# Simulation parameters




# ------------- Do not change below unless modifying for a different workflow ---------------------
# compilers being considered
#Compilers <- c('intel','gcc','pgi')
#Compilers <- c('intel')
# parse directory and file information
#sens.name <- strsplit(files,'/')
#n.lev     <- length(sens.name[[1]])
#sens.name <- sens.name[[1]][n.lev]
all.names <- NULL
for(i in 1:length(files)){
   all.names <- append(all.names,sens.name)
}
files <- paste(sens.dir,files,sep="")
for(i in 1:length(files)){
   all.names <- append(all.names,base.name)
}
files <- append(files,paste(base.dir,b.files,sep=''))
for( comp in Compilers) {
   bar.data <- NULL
   b.names <- NULL
   for(i in 1:length(files)){
# ignore debug simulations and get compiler information
#      if(i%in%grep('debug',files)==F & i%in%grep(comp,files)){
         file <- files[i]
         b.names <- append(b.names,paste(all.names[i]))
         data.in  <- scan(file,what='character',sep='\n')
# get timing info
         Timing <-  as.numeric(substr(data.in[grep('completed...',data.in)],36,42))

        # master_timing <- as.numeric(substr(data.in[grep('Processing completed...',data.in)],36,42))
         dataout_timing <- as.numeric(substr(data.in[grep('Data Output completed...',data.in)],36,45))
         Process <- substr(data.in[grep('completed...',data.in)],12,22)
        # Timing_sum <-sum(master_timing)
        #dataio_sum <-sum(dataout_timing)
         
         Timing_direct <-  as.numeric(substr(data.in[grep('Total Time =',data.in)],18,26))
        # Timing_missing <- Timing_direct - Timing_sum 
         
         n.proc <- unique(Process)
         n.proc <- n.proc[grep('Proc',n.proc,invert=T)]
 

	       # Aggregate data
         tmp.data <- NULL
         for(i in n.proc){
           valid <- which(i==Process)
           tmp.data <- append(tmp.data,sum(Timing[valid]))
         }
         Timing_sum <- sum(tmp.data)
         Timing_missing <- Timing_direct - Timing_sum
          
         tmp.data <- append(tmp.data,Timing_missing)
         bar.data <- cbind(bar.data,tmp.data)
   #   }
   }

   n.proc.plot <- append(n.proc, "OTHER")
   
   #remove all leading whitespace
   n.proc.plot <- str_trim(n.proc.plot, "left")
   
   # plot data
   my.colors <- brewer.pal(12, "Paired")
   #my.colors <- terrain.colors(length(n.proc))
   xmax <- dim(bar.data)[2]*1.5
   png(file = paste('cyclecloud_vs_aws_lustre_1-6nodes_',comp,'_all',sens.name,'_',base.name,'.png',sep=''), width = 1024, height = 768, bg='white')
  # png(file = paste(comp,'_',sens.name,'.png',sep=''), width = 1024, height = 768, bg='white')
   barplot(bar.data, main = 'CMAQv5.3.3 Process Timing on CycleCloud(HB120v3) versus AWS(HPC6a) on /lustre using 1-6 nodes with 96 cpus/node',names.arg = b.names,ylab='seconds', col = my.colors, legend = n.proc.plot, xlim = c(0.,xmax),ylim = c(0.,6000.))
   box()
   dev.off()
 
  totals <- apply(bar.data,c(2),sum)
# print total runtime data to the screen
   for(i in 1:length(b.names)){
     print(paste('Run time for', b.names[i], ':',totals[i],'seconds'))
   }
}
