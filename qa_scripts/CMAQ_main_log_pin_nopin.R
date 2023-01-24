# Script modified to work with all processors
# Script author: Jesse Bash
# Affiliation: US EPA Office of Research and Development
# This script assumes that the log files are located in ./CCTM/scripts as output by the CMAQ run script 
# These are the single output files, not the CTM_LOG files found in the $OUTDIR/LOGS directory
library(RColorBrewer)
library(stringr)

sens.dir  <- '/shared/pcluster-cmaq/run_scripts/hpc6a/logs/'
base.dir  <- '/shared/pcluster-cmaq/run_scripts/hpc6a_shared/'
files   <- dir(sens.dir, pattern ='run_cctmv5.3.3_Bench_2016_12US2.hpc6a.48xlarge.576.6x96.24x24pe.2day.pcluster.log')
#b.files <- dir(base.dir,pattern='run_cctmv5.3.3_Bench_2016_12US2.576.24x24pe.2day.cyclecloud.shared.codemod.nopin.redo.log')
b.files <- dir(base.dir,pattern='run_cctmv5.3.3_Bench_2016_12US2.hpc6a.48xlarge.576.6x96.24x24pe.2day.pcluster.fsx.pin.codemod.3.log')
#Compilers <- c('intel','gcc','pgi')
Compilers <- c('gcc')
# name of the base case timing. I am using the current master branch from the CMAQ_Dev repository.
# The project directory name is used for the sensitivity case.
#base.name <- c('data_pin','lustre_pin','shared_pin')
base.name <- c('lustre_pin')
sens.name <- c('lustre_nopin')

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
   png(file = paste('hpc6a_6nodes_576pe_',comp,'_all',sens.name,'_',base.name,'.png',sep=''), width = 1024, height = 768, bg='white')
  # png(file = paste(comp,'_',sens.name,'.png',sep=''), width = 1024, height = 768, bg='white')
   barplot(bar.data, main = 'Process Timing on /lustre using 6 nodes with 96 cpus/node on HPC6a without and with pinning',names.arg = b.names,ylab='seconds', col = my.colors, legend = n.proc.plot, xlim = c(0.,xmax),ylim = c(0.,2500.))
   box()
   dev.off()
 
  totals <- apply(bar.data,c(2),sum)
# print total runtime data to the screen
   for(i in 1:length(b.names)){
     print(paste('Run time for', b.names[i], ':',totals[i],'seconds'))
   }
}
