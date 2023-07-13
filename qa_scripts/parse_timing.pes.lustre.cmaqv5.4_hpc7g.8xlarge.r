# Script author: Jesse Bash
# Affiliation: US EPA Office of Research and Development
# This script assumes that the log files are located in ./CCTM/scripts as output by the CMAQ run script
# These are the single output files, not the CTM_LOG files found in the $OUTDIR/LOGS directory
library(RColorBrewer)
sens.dir  <- '/shared/pcluster-cmaq/run_scripts/hpc7g.16xlarge/logs/'
base.dir  <- '/shared/pcluster-cmaq/run_scripts/hpc7g.16xlarge/logs/'
files   <- dir(sens.dir, pattern ='run_cctm5.4p_Bench_2018_12US1_cb6r5_ae6_20200131_MYR.32.4x8pe.2day.20171222start.1x32.log')
b.files <- c('run_cctm5.4p_Bench_2018_12US1_cb6r5_ae6_20200131_MYR.64.8x8pe.2day.20171222start.2x32.log','run_cctm5.4p_Bench_2018_12US1_cb6r5_ae6_20200131_MYR.96.12x8pe.2day.20171222start.3x32.log','run_cctm5.4p_Bench_2018_12US1_cb6r5_ae6_20200131_MYR.128.16x8pe.2day.20171222start.4x32.log')
#Compilers <- c('intel','gcc','pgi')
Compilers <- c('')
# name of the base case timing. I am using the current master branch from the CMAQ_Dev repository.
# The project directory name is used for the sensitivity case.
base.name <- c('64','96','128')
#base.name <- c('data_pin')
sens.name <- c('32')

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
         b.names <- append(b.names,paste(comp,all.names[i]))
         data.in  <- scan(file,what='character',sep='\n')
# get timing info
         Timing <-  as.numeric(substr(data.in[grep('completed...',data.in)],42,48))
         Process <- substr(data.in[grep('completed...',data.in)],12,22)
         n.proc <- unique(Process)
         n.proc <- n.proc[grep('Proc',n.proc,invert=T)]
# Aggrigate data
         tmp.data <- NULL
         for(i in n.proc){
           valid <- which(i==Process)
           tmp.data <- append(tmp.data,sum(Timing[valid]))
         }
         bar.data <- cbind(bar.data,tmp.data)
   #   }
   }
# plot data
   my.colors <- brewer.pal(11, "Paired")
   #my.colors <- terrain.colors(length(n.proc))
   xmax <- dim(bar.data)[2]*1.5
   png(file = paste('HPC7g.8xlarge','pes_',sens.name,'_',base.name,'.png',sep=''), width = 1024, height = 768, bg='white')
  # png(file = paste(comp,'_',sens.name,'.png',sep=''), width = 1024, height = 768, bg='white')
   barplot(bar.data, main = 'CMAQv5.4+ Process Timing on /lustre using 32 cpus/node on HPC7g.8xlarge',names.arg = b.names,xlab='PEs',ylab='seconds', col = my.colors, legend = n.proc, xlim = c(0.,xmax),ylim = c(0.,13000.))
   box()
   dev.off()
   totals <- apply(bar.data,c(2),sum)
# print total runtime data to the screen
   for(i in 1:length(base.name)){
     print(paste('Run time for', base.name[i], ':',totals[i],'seconds'))
   }
}

