#Required libraries.
library(ncdf4)
#install.packages("/home/kfoley/tools/Rcode/R-packages/M3", repos = NULL, type="source")
#library("M3")
source("/proj/ie/proj/CMAS/CMAQ/CMAQv5.5_testing/CMAQ_v5.5/POST/rscripts/M3_functions.r")
library(fields)
library(rlang)
library(viridis)

setwd("/proj/ie/proj/CMAS/CMAQ/CMAQv5.5_testing/CMAQ_v5.5/POST/rscripts")

####################################################
#> Get environment variables set in unit_test.csh.
#> To run this script directly in R, rather than 
#> submitting the code through a run script, simply
#> define the following 7 variables. 


#> Location of R scripts for post processing and evaluation.
 r.source <- Sys.getenv('UNIT_AQ_BASE')

#> Date for model run

plotdate <- Sys.getenv('DATE')

#> List of species to be plotted.  Can also use "ALL".
plot.spec.list <- unlist(strsplit(Sys.getenv('SPEC'), ","))

#> Set location where plots will be saved.
outdir <- Sys.getenv('OUTDIR')

#> Application name to use for plot titles, e.g. Code version, compiler, gridname, emissions, etc.
appl1 <- Sys.getenv('APPL1')

#> Main CMAQ output you want to evaluate, e.g. a new test or sensitivity simulation.
cctm.file1 <- Sys.getenv('CCTM_FILE_1')

#> (Optional)  A different set of output you would like to compare against cctm.file1, e.g. a base simulation.
cctm.file2 <- Sys.getenv('CCTM_FILE_2')

#> Application name for the second model run. (Optional)
appl2 <- Sys.getenv('APPL2')

#> Which model run to use to normalize the percent difference. Options are: FILE_1, FILE_2 (default)
normalize.by.cctm.file <- Sys.getenv('CCTM_NORMALIZE')


#> Summary statistic to apply to hourly data.  Options are: MEAN (default), MEDIAN, SUM, MAX, MIN. (Not case sensitive.)
stat.fun <- Sys.getenv('STAT')


####################################################
#> Check to make sure that summary statistic provided by the user is supported.
#> If no stat.fun is provided, default = mean.
if(stat.fun=="") stat.fun <- "mean"	
#> Make all lower case for use in apply function.
stat.fun <- tolower(stat.fun)
#> If user specified something other than mean, median, sum, min, max, then print a warning and reset to mean.
if(!stat.fun %in% c("mean","median","sum","min","max")){
 print(paste("WARNING summary statistics", stat.fun," is not supported.  MEAN will be used instead."))
 stat.fun <- "mean"
}



####################################################
#> Open the CCTM file and extract grid info.
cctm1.in <- nc_open(cctm.file1)

#> Create a list of variables and units in  cctm.file1. TFLAG will always be the first variable listed in an I/O API file.
cctm1.spec <- unlist(lapply(cctm1.in$var, function(var)var$name))[-1]
#> Use gsub to strip out extra spaces.
cctm1.unit <- gsub("  ","",unlist(lapply(cctm1.in$var, function(var)var$units))[-1])


#> Pull out the time steps and the grid coordinates associated with the data.
#> These M3 functions are wrappers for functions in the ncdf4 package.
datetime <- get.datetime.seq(cctm.file1)
#> Lambert projected coordinates (unit=km)
x.proj.coord <- get.coord.for.dimension(cctm.file1,"col")$coords
y.proj.coord <- get.coord.for.dimension(cctm.file1,"row")$coords
#> Map lon/lat sequence to projected coordinates (to annotate spatial maps).
lonlat.range <- project.M3.to.lonlat(range(x.proj.coord),range(y.proj.coord),cctm.file1,"km")$coords
lon.range <- floor(lonlat.range[,1])
lat.range <- floor(lonlat.range[,2])
lon.seq <- seq(lon.range[1],lon.range[2]+1,by=2)
lat.seq <- seq(lat.range[1],lat.range[2]+1,by=2)
x.plot.seq <- project.lonlat.to.M3(lon.seq,rep(30,length=length(lon.seq)),cctm.file1,"km")$coords[,1]
y.plot.seq <- project.lonlat.to.M3(rep(-90,length=length(lat.seq)),lat.seq,cctm.file1,"km")$coords[,2]
#> US, Canada, Mexico map lines in Lambert projected coordinates.
map.lines <- get.map.lines.M3.proj(cctm.file1,database="canusamex")$coords


####################################################
#> Check the species list that was provided through the SPEC variable.
#> If "ALL" is used, will plot all the species in the file. 
#> Note that this check is not case sensitive (i.e. can use "all","All", etc).
#> If a list is provided, make sure the species names match the names in the cctm.file1

if(length(grep("ALL", plot.spec.list, ignore.case=T, value=T))>0){
  
  plot.spec.list <- cctm1.spec 
  plot.unit.list <- cctm1.unit

  }else{
 
  if(sum(!plot.spec.list%in%cctm1.spec)>0){
    missing.spec <- plot.spec.list[!plot.spec.list%in%cctm1.spec]
    print(paste("WARNING",do.call("paste",c(as.list(missing.spec),sep=",")),"are not in file",cctm.file1,"and will be ignored."))
    plot.spec.list <- plot.spec.list[plot.spec.list%in%cctm1.spec]  
  }
  #Get the units associated with the species list to be plotted.
  find.unit.fun <- function(x)cctm1.unit[which(cctm1.spec==x)]
  plot.unit.list <- gsub("  ","",unlist(lapply(as.list(plot.spec.list),find.unit.fun)))

}

####################################################
#> Source file containing color palettes (my.colors, my.col.cool, my.col.warm),
#> function for setting up zlim and color scale for concentration maps (find.zlim)
#> and function for setting up zlim and color scale for maps of differences or % differences (find.diff.zlim)
source(paste(r.source,"/find_zlim.R",sep=""))



####################################################
#> Function: plot.spat.avg
#> Purpose: For a given species, average all time steps and create a map of the average.
#> Annotate the map with the median, mean and max concentrations.
#> Input:
#> - spec.name: species to be plotted, e.g. "O3"
#> - spec.unit: units of species to be plotted, e.g. "ppbV"
#> Returns a map of the mean (or other summary statistic) concentration.

plot.spat.avg <- function(spec.name,spec.unit){
 #Extract species
 spec.array <- ncvar_get(cctm1.in,var=spec.name) 
 #Average over all time steps.
 spec.avg <- apply(spec.array,c(1,2),stat.fun)
 
 #Set up zlim and color bar.
 zlim.list <- find.zlim(spec.avg)
 my.zlim <- zlim.list$my.zlim
 my.col <- zlim.list$my.col
 my.at <- zlim.list$my.at
 my.labels <- zlim.list$my.labels
 spec.avg.plot <- spec.avg
 spec.avg.plot[spec.avg>max(my.zlim)] <- max(my.zlim)
 
 #Map average species concentrations across all time steps.
 plot(1,xlim=range(x.proj.coord),ylim=range(y.proj.coord),axes=F,xlab="",ylab="",type="n",main=paste(appl1,": ",spec.name,sep=""))
 axis(1,at=x.plot.seq,labels=lon.seq)	#Add longitude to x axis.
 axis(2,at=y.plot.seq,labels=lat.seq)	#Add latitude to y axis.
 mtext(cex=1,side=1,line=2.5,text=paste("Domain size: ",length(y.proj.coord),"x",length(x.proj.coord)," | Max = ",signif(max(spec.avg),2),
	" at (", which(apply(spec.avg,2,max)==max(spec.avg)),", ",which(apply(spec.avg,1,max)==max(spec.avg)),")",sep="")) #Add domain size, max.
 mtext(cex=1,side=1,line=3.5,text=paste("Mean: ",signif(mean(spec.avg),2)," |  Median: ",signif(median(spec.avg),2),sep="")) #Add mean/median.
 image(cex=1,x.proj.coord,y.proj.coord,spec.avg.plot,add=T,zlim=my.zlim,col=my.col)  #Add color image.
 image.plot(legend.only=T,legend.args=list(text=paste(spec.unit),cex=1),axis.args=list(at=my.at,labels=my.labels,cex=1),zlim=my.zlim,col=my.col,legend.width=1, cex=1)  #Add legend bar.
 lines(map.lines)	#Add state lines.
 box()

}


####################################################
#> Set up size of jpeg plot. This is based of aspect_ratio_plot.R developed by J. Swall.
#> mai = a numerical vector of the form c(bottom, left, top, right) which gives the margin size specified in inches.
my.mai <- c(1.4, 0.0, 0.4, 0.0)
#> Width of jpeg plots (in inches). 
my.width <- 6.2
#> Determine height of plots based on the aspect ratio of the model domain.
prop.y.to.x <- (max(y.proj.coord)-min(y.proj.coord)) / (max(x.proj.coord)-min(x.proj.coord))
plot.width <- my.width - my.mai[2] - my.mai[4]
plot.height <- plot.width * prop.y.to.x
my.height <- plot.height + my.mai[1] + my.mai[3]

#> Check if a cctm.file2 was provided. It there is no second file for comparison, proceed with plots of cctm.file1 and then stop the script.
if(cctm.file2==""){ 

  #> Create average (or other summary statistic) concentration map of every species in plot.spec.list. Save a .jpeg.
  print(paste("Creating",toupper(stat.fun),"maps for:",do.call("paste",c(as.list(plot.spec.list),sep=","))))
  for(i in 1:length(plot.spec.list)){
    png(paste0(outdir,"/",plot.spec.list[i],"_",toupper(stat.fun),"_map_",appl1,"_",plotdate,".png"),height=my.height,width=my.width,units="in",res=400)
    par(mai=my.mai)
    plot.spat.avg(plot.spec.list[i],plot.unit.list[i])
    dev.off()
  }

  #> Script completed without error. 
  stop("CCTM_FILE_2 not provided.  spatial_diff.R complete.")
}

#######################################################
#> If a cctm.file2 is provided make spatial maps of the average for cctm.file1 and cctm.file2, difference plots and percent differences.

#> Check with model run will be used to normalize the % difference in the two runs. Default is Model 2.
#> If the user does not select FILE_1, then force this to be FILE_2.  
#> In the case where this environment variable was not set or was set incorrectly it will default back to FILE_2.
if(!normalize.by.cctm.file%in%c("FILE_1","FILE_2")) normalize.by.cctm.file <- "FILE_2"

#> Open the second CCTM file.
cctm2.in <- nc_open(cctm.file2)
cctm2.spec <- unlist(lapply(cctm2.in$var, function(var)var$name))[-1]

#> Make sure that the second file has the species in plot.species.list.
if(sum(!plot.spec.list%in%cctm2.spec)>0){
    missing.spec <- plot.spec.list[!plot.spec.list%in%cctm2.spec]
    print(paste("WARNING",do.call("paste",c(as.list(missing.spec),sep=",")),"are not in file",cctm.file2,"and will be ignored."))
    plot.spec.list <- plot.spec.list[plot.spec.list%in%cctm2.spec]  
  }


####################################################
#> Function: plot.spat.diff
#> Purpose: For a given species, average all time steps and create a map of the average 
#> for new and base model simulation.  Also plot maps of differences and % differences.
#> Annotate the map with the median, mean and max concentrations of spatial field.
#> Input:
#> - spec.name: species to be plotted, e.g. "O3"
#> - spec.unit: units of species to be plotted.
#> Returns a 2 x 2 panel plot with 4 maps:
#> (1) temporal mean (or other summary statistic) of new simulation
#> (2) temporal mean (or other summary statistic) of base simulation
#> (3) New - Base 
#> (4) (New - Base)/Base x 100%

plot.spat.diff <- function(spec.name,spec.unit){
 
 #Calcualte averages for each model run, Model 1 - Model 2 difference and (Model 1 - Model 2)/(Model 2)x100 relative difference.
 spec.array.new <- ncvar_get(cctm1.in,var=spec.name) 
 spec.avg.new <- apply(spec.array.new,c(1,2),stat.fun)
 spec.array.base <- ncvar_get(cctm2.in,var=spec.name) 
 spec.avg.base <- apply(spec.array.base,c(1,2),stat.fun) 
 spec.avg.diff <- spec.avg.new-spec.avg.base
 if(normalize.by.cctm.file == "FILE_2"){
   spec.rel.diff <- (spec.avg.new-spec.avg.base)/spec.avg.base*100} else {
   spec.rel.diff <- (spec.avg.new-spec.avg.base)/spec.avg.new*100}

 #Relplace NA's created by dividing by zero with 0s when the difference is also 0.  Otherwise leave it as missing. 
 spec.rel.diff[(spec.avg.new-spec.avg.base)==0] <- 0

 #Set up zlim and color bar for concentration maps of cctm.file1 (new simulation) and cctm.file2 (base simulation).
 zlim.list <- find.zlim(c(spec.avg.new,spec.avg.base))
 my.zlim <- zlim.list$my.zlim
 my.col <- zlim.list$my.col
 my.at <- zlim.list$my.at
 my.labels <- zlim.list$my.labels
 spec.avg.new.plot <- spec.avg.new
 spec.avg.new.plot[spec.avg.new>max(my.zlim)] <- max(my.zlim)
 spec.avg.base.plot <- spec.avg.base
 spec.avg.base.plot[spec.avg.base>max(my.zlim)] <- max(my.zlim)
 
 #Map average species concentrations across all time steps for for cctm.file1 (new simulation).
 plot(1,xlim=range(x.proj.coord),ylim=range(y.proj.coord),axes=F,xlab="",ylab="",type="n",main=paste("Date: (",plotdate,"), Model 1 (",appl1,"): ",spec.name,sep=""))
 axis(1,at=x.plot.seq,labels=lon.seq)	#Add longitude to x axis.
 axis(2,at=y.plot.seq,labels=lat.seq)	#Add latitude to y axis.
 mtext(cex=1,side=1,line=2.5,text=paste("Domain size: ",length(y.proj.coord),"x",length(x.proj.coord)," | Max = ",signif(max(spec.avg.new),2),
	" at (", which(apply(spec.avg.new,2,max)==max(spec.avg.new)),", ",which(apply(spec.avg.new,1,max)==max(spec.avg.new)),")",sep="")) #Add domain size, max.
 mtext(cex=1,side=1,line=3.5,text=paste("Mean: ",signif(mean(spec.avg.new),2)," |  Median: ",signif(median(spec.avg.new),2),sep="")) #Add mean/median.
 image(cex=1,x.proj.coord,y.proj.coord,spec.avg.new.plot,add=T,zlim=my.zlim,col=my.col)  #Add color image.
 image.plot(legend.only=T,legend.args=list(text=paste(spec.unit),cex=1),axis.args=list(at=my.at,labels=my.labels,cex=1),zlim=my.zlim,col=my.col,legend.width=.6, cex=1)  #Add legend bar.
 lines(map.lines)	#Add state lines.
 box()

 #Map average species concentrations across all time steps for for cctm.file2 (base simulation).
 plot(1,xlim=range(x.proj.coord),ylim=range(y.proj.coord),axes=F,xlab="",ylab="",type="n",main=paste("Date: (",plotdate,"), Model 2 (",appl2,"): ",spec.name,sep=""))
 axis(1,at=x.plot.seq,labels=lon.seq)	#Add longitude to x axis.
 axis(2,at=y.plot.seq,labels=lat.seq)	#Add latitude to y axis.
 mtext(cex=1,side=1,line=2.5,text=paste("Domain size: ",length(y.proj.coord),"x",length(x.proj.coord)," | Max = ",signif(max(spec.avg.base),2),
	" at (", which(apply(spec.avg.base,2,max)==max(spec.avg.base)),", ",which(apply(spec.avg.base,1,max)==max(spec.avg.base)),")",sep="")) #Add domain size, max.
 mtext(cex=1,side=1,line=3.5,text=paste("Mean: ",signif(mean(spec.avg.base),2)," |  Median: ",signif(median(spec.avg.base),2),sep="")) #Add mean/median.
 image(cex=1,x.proj.coord,y.proj.coord,spec.avg.base.plot,add=T,zlim=my.zlim,col=my.col)  #Add color image.
 image.plot(legend.only=T,legend.args=list(text=paste(spec.unit),cex=1),axis.args=list(at=my.at,labels=my.labels,cex=1),zlim=my.zlim,col=my.col,legend.width=.6, cex=1)  #Add legend bar.
 lines(map.lines)	#Add state lines.
 box()


 #Set up zlim and color bar for difference plots.
 diff.zlim.list <- find.diff.zlim(c(spec.avg.diff))
 my.diff.zlim <- diff.zlim.list$my.diff.zlim
 my.diff.col <- diff.zlim.list$my.diff.col
 my.diff.at <- diff.zlim.list$my.diff.at
 my.diff.labels <- diff.zlim.list$my.diff.labels
 spec.avg.diff.plot <- spec.avg.diff
 spec.avg.diff.plot[spec.avg.diff>max(my.diff.zlim)] <- max(my.diff.zlim)
 spec.avg.diff.plot[spec.avg.diff<min(my.diff.zlim)] <- min(my.diff.zlim)

 #Map difference Model 1 (new) - Model 2 (base)
 plot(1,xlim=range(x.proj.coord),ylim=range(y.proj.coord),axes=F,xlab="",ylab="",type="n",main=paste("Model 1 - Model 2: ",spec.name,sep=""))
 #axis(1,at=x.plot.seq,labels=lon.seq)	#Add longitude to x axis.
 #axis(2,at=y.plot.seq,labels=lat.seq)	#Add latitude to y axis.
 mtext(cex=1,side=1,line=2.5,text=paste("Min = ",signif(min(spec.avg.diff),3)," | Max = ",signif(max(spec.avg.diff),3),sep="")) #min/max diff.
 mtext(cex=1,side=1,line=3.5,text=paste("Mean: ",signif(mean(spec.avg.diff),3)," |  Median: ",signif(median(spec.avg.diff),3),sep="")) #Add mean/median diff.
 image(cex=1,x.proj.coord,y.proj.coord,spec.avg.diff.plot,add=T,zlim=my.diff.zlim,col=my.diff.col)  #Add color image.
 image.plot(legend.only=T,legend.args=list(text=paste(spec.unit),cex=1),axis.args=list(at=my.diff.at,labels=my.diff.labels,cex=1),zlim=my.diff.zlim,col=my.diff.col,legend.width=.6, cex=1)  #Add legend bar.
 lines(map.lines)	#Add state lines.
 box()


 #Set up zlim and color bar for % difference plots.
 rel.diff.zlim.list <- find.diff.zlim(c(spec.rel.diff))
 my.rel.diff.zlim <- rel.diff.zlim.list$my.diff.zlim
 my.rel.diff.col <- rel.diff.zlim.list$my.diff.col
 my.rel.diff.at <- rel.diff.zlim.list$my.diff.at
 my.rel.diff.labels <- rel.diff.zlim.list$my.diff.labels
 spec.rel.diff.plot <- spec.rel.diff
 spec.rel.diff.plot[spec.rel.diff>max(my.rel.diff.zlim)] <- max(my.rel.diff.zlim)
 spec.rel.diff.plot[spec.rel.diff<min(my.rel.diff.zlim)] <- min(my.rel.diff.zlim)

 #Map % difference (Model 1 - Model 2)/(Model 2) x 100%  OR  (Model 1 - Model 2)/(Model 1) x 100% 
 if(normalize.by.cctm.file == "FILE_2"){
   my.main <- paste("(Model 1 - Model 2)/(Model 2)x100%: ",spec.name,sep="") } else {
   my.main <- paste("(Model 1 - Model 2)/(Model 1)x100%: ",spec.name,sep="") }
 plot(1,xlim=range(x.proj.coord),ylim=range(y.proj.coord),axes=F,xlab="",ylab="",type="n",main=my.main)
 #axis(1,at=x.plot.seq,labels=lon.seq)	#Add longitude to x axis.
 #axis(2,at=y.plot.seq,labels=lat.seq)	#Add latitude to y axis.
 mtext(cex=1,side=1,line=2.5,text=paste("Min = ",round(min(spec.rel.diff),1)," | Max = ",round(max(spec.rel.diff),1),sep="")) #min/max diff.
 mtext(cex=1,side=1,line=3.5,text=paste("Mean: ",signif(mean(spec.rel.diff),1)," |  Median: ",signif(median(spec.rel.diff),1),sep="")) #Add mean/median diff.
 image(cex=1,x.proj.coord,y.proj.coord,spec.rel.diff.plot,add=T,zlim=my.rel.diff.zlim,col=(my.rel.diff.col))  #Add color image.
 image.plot(legend.only=T,legend.args=list(text="%",cex=1),axis.args=list(at=my.rel.diff.at,labels=my.rel.diff.labels,labels.cex=1),zlim=my.rel.diff.zlim,col=my.rel.diff.col,legend.width=.6, cex=1)  #Add legend bar.
 lines(map.lines)	#Add state lines.
 box()

}


####################################################
#> Create average (or other summary statistic) concentration, difference and % difference maps of every species in plot.spec.list. Save a .jpeg.

print(paste0("Begin creating DIFF_",toupper(stat.fun)," maps for: ",do.call("paste",c(as.list(plot.spec.list),sep=","))))

for(i in 1:length(plot.spec.list)){
 print(paste0("Creating DIFF_",toupper(stat.fun)," maps for: ",plot.spec.list[i]))
 png(paste0(outdir,"/",plot.spec.list[i],"_M2M_spatial_DIFF_",toupper(stat.fun),"_",appl1,"-",appl2,"_",plotdate,".png"),height=my.height*1.5,width=my.width*1.7,units="in",res=400)
 par(mai=c(1.1, 0.4, 0.4, 1.3),mfrow=c(2,2))
 plot.spat.diff(plot.spec.list[i],plot.unit.list[i])
 dev.off()
}

#> Script completed without error. 
print("spatial_diff.R complete.")



