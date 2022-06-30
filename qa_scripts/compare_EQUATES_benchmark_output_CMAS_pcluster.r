library(ncdf4)
library(fields)
library(M3)

# Script author: Kristen Foley
# Affiliation: US EPA Office of Research and Development
# Revisions: Christos Efstathiou, UNC


#Some 'nice' color palettes.
my.colors <- colorRampPalette(c("white",grey(.9),"#56B4E9","#0072B2","#009E73","#F0E442","#E69F00","#D55E00","#CC79A7"))
my.col.cool1 <- colorRampPalette(c("darkorchid4","purple","#002FFF","#0072B2","#009E73","palegreen3",grey(.95)))
my.col.warm1<- colorRampPalette(c(grey(.95),"#F0E442","orange","#E69F00","#D55E00","red","#A52A2A"))
my.diff.col <- function(n)c(my.col.cool1(n/2),my.col.warm1(n/2))

#Directory to save output .pdf file with plots. 
output.dir <- "/shared/pcluster-cmaq/qa_scripts/qa_plots/"

#Directory, file name, and label for first model simulation (sim1)
sim1.label <- "CMAQv533 12x9pe"
sim1.dir <- "/fsx/data/output/output_CCTM_v533_gcc_2016_CONUS_12x9pe/"
sim1.file <- paste0(sim1.dir,"CCTM_ACONC_v533_gcc_2016_CONUS_12x9pe_20151222.nc")

#Directory, file name, and label for second model simulation (sim2)
sim2.label <- "CMAQv533 6x18pe"
sim2.dir <- "/fsx/data/output/output_CCTM_v533_gcc_2016_CONUS_6x18pe/"
sim2.file <- paste0(sim2.dir,"CCTM_ACONC_v533_gcc_2016_CONUS_6x18pe_20151222.nc")

#Remove spaces and special characters (parentheses and backslash) from simulation 1 and 2 labels
#so that they can be used in the .pdf and .jpeg file names.
sim1.label.simple <- gsub(" |\\(|\\)|/","",sim1.label)
sim2.label.simple <- gsub(" |\\(|\\)|/","",sim2.label)

#Flags for toggling on or off different comparsions.
#SAVE.DIFFERENCES: Data frame with max difference between sim1 and sim2 across all 
#				   timesteps/grids for each species, saved as a .csv file in the output directory. 
#MAKE.BOXPLOTS: Boxplots of differences for each hour, saved as a .jpeg in the output directory.
#MAKE.SPATIAL.PLOTS: Maps of the differencs for each hour saved, as a .pdf in the ouput directory.
SAVE.DIFFERENCES <- TRUE  
MAKE.BOXPLOTS <- TRUE
MAKE.SPATIAL.PLOTS <- TRUE

#List of what species to compare.  If this is set to NULL, the code will compare all 
#species that are common between the sim1 and sim2 files. Note this can be quite slow!
#Just compare a few species
my.species.compare.list <- c("O3","CO","ANO3J","AOTHRJ","NH3","SO2","NO2","OH")
#my.species.compare.list <- NULL

#######################################
#!Do not have to edit below this line!#

#Unique x and y lambert projected coordinates of the CMAQ grid
x.proj.coord <- get.coord.for.dimension(sim1.file,"col")$coords
y.proj.coord <- get.coord.for.dimension(sim1.file,"row")$coords

#US/CAN/MX country lines and US state lines
map.lines <- get.map.lines.M3.proj(sim1.file,database="canusamex")$coords


#Get the timesteps in sim1 and sim2 files.  These do not have to match exactly.  
sim1.date.seq <- get.datetime.seq(sim1.file)
sim2.date.seq <- get.datetime.seq(sim2.file)

#Find the timesteps that are in both sim1 and sim2 files.
sim1.date.seq.overlap <- sim1.date.seq %in% sim2.date.seq
sim2.date.seq.overlap <- sim2.date.seq %in% sim1.date.seq
date.seq.overlap.format <- format.Date(sim1.date.seq[sim1.date.seq.overlap],"%m/%d/%Y %H:%M")

#Check to see if sim1 and sim2 have overlapping timesteps.
if(length(date.seq.overlap.format)==0){
  print("ERROR:  Simulation 1 and Simulation 2 files do not have any overlapping timesteps.")
}


#Open sim1 and sim2 files.
sim1.file.in <- nc_open(sim1.file)
sim2.file.in <- nc_open(sim2.file)


#Create a list of all of the species and their units in the sim1 file. 
sim1.spec.names <- unlist(lapply(sim1.file.in$var, function(var)var$name))[-1]
sim1.species.units <- gsub(" ","",unlist(lapply(sim1.file.in$var, function(var)var$units))[-1])
sim2.spec.names <- unlist(lapply(sim2.file.in$var, function(var)var$name))[-1]
sim2.species.units <- gsub(" ","",unlist(lapply(sim2.file.in$var, function(var)var$units))[-1])

#Find the list of species that are in both sim1 and sim2 files and have the same units.
sim1.species.units.overlap <- sim1.species.units[sim1.spec.names %in% sim2.spec.names]
sim2.species.units.overlap <- sim2.species.units[sim2.spec.names %in% sim1.spec.names]

sim1.spec.names.overlap <- sim1.spec.names[(sim1.spec.names %in% sim2.spec.names)]
spec.names.overlap <- sim1.spec.names.overlap[(sim1.species.units.overlap == sim2.species.units.overlap)] 
species.units.overlap <- sim1.species.units.overlap[(sim1.species.units.overlap == sim2.species.units.overlap)] 

#Check to see if sim1 and sim2 have overlapping species.
if(length(spec.names.overlap)==0){
  print("ERROR:  Simulation 1 and Simulation 2 files do not have any common species (with matching units) to compare.")
}


#If a species list was not selected above, compare all species that are in both sim1 and sim2 files.
if(is.null(my.species.compare.list)){ species.compare.list <- spec.names.overlap }

#If a species list was selected, check to make sure all of the species names are in the spec.names.overlap list.
if(!is.null(my.species.compare.list)){
 missing.species <- my.species.compare.list[!my.species.compare.list%in%spec.names.overlap]
 if(length(missing.species)>0) print(paste("Warning:",missing.species,"is not in sim1 and sim2 files and will be ignored"))
 species.compare.list <- my.species.compare.list[my.species.compare.list%in%spec.names.overlap]
 if(length(species.compare.list)==0) print("Warening: None of the speices selected are in sim1 and sim2.  No plots will be made.")
}


max.differences.df <- NULL

for(species.name in species.compare.list){

  print(species.name)

  #Get species unit
  species.units <- species.units.overlap[which(spec.names.overlap==species.name)]
  print(species.units)
  
  #Read in the species from file 1.  Subset to the timesteps that are in both files.
  sim1.spec <- ncvar_get(sim1.file.in,var=species.name)[,,sim1.date.seq.overlap]
  #Read in the species from file 2.  Subset to the timesteps that are in both files.
  sim2.spec <- ncvar_get(sim2.file.in,var=species.name)[,,sim2.date.seq.overlap]
  
  #Check to make sure the dimensions of sim1 and sim2 match and are non-zero.
  if(min(dim(sim1.spec),dim(sim1.spec))== 0 | sum(dim(sim1.spec)!=dim(sim2.spec))>0){
    print("ERROR: No overlapping timesteps OR grid dimensions of Simulation 1 and Simulation 2 do not match.")
	break
  }
  
  #Array dimensions of data (n.x X n.y X n.t)
  spec.dim <- dim(sim1.spec)
  n.grid <- spec.dim[1]*spec.dim[2]
  n.time <- spec.dim[3]

  if(SAVE.DIFFERENCES){
  #Find max difference (and max % difference) across all timestep and grid cells.
  #Save the max differences in a data frame (max.differences.df)
  max.abs.diff <- max(abs(sim1.spec-sim2.spec))
  abs.perc.diff <- abs((sim1.spec-sim2.spec)/sim2.spec)*100
  abs.perc.diff[sim1.spec==0] <- NA
  max.abs.perc.diff <- max(abs.perc.diff,na.rm=T)
  max.differences.df <- rbind(max.differences.df,data.frame(species.name,max.abs.diff,species.units, max.abs.perc.diff))
  print(paste("Max Abs Diff =",max.abs.diff))
  print(paste("Max Abs % Diff =",max.abs.perc.diff))
  }
  
  if(MAKE.BOXPLOTS){
  #Boxplots of hourly differnces.
  boxplot.diff.matrix <- matrix(sim1.spec-sim2.spec,c(n.grid,n.time))
  ylim.range <- c(-max(abs(boxplot.diff.matrix)),max(abs(boxplot.diff.matrix)))
  
  #Remove spaces and special characters (parentheses and backslash) from simulation 1 and 2 labels 
  #so that they can be used in the .pdf and .jpeg file names.
  #sim1.label.simple <- gsub(" |\\(|\\)|/","",sim1.label)
  #sim2.label.simple <- gsub(" |\\(|\\)|/","",sim2.label)
  
  jpeg(paste0(output.dir,species.name,"_BOXPLOT_",sim1.label.simple,"_vs_",sim2.label.simple,".jpeg"))
  par(mfrow=c(1,1))
  par(mar=c(8,4,4,1))
  boxplot(boxplot.diff.matrix,ylim=ylim.range,xaxt="n",
    ylab=paste0("Differences in ",species.name," (",species.units,")"),
    main=paste(species.name,":",sim1.label,"-",sim2.label))
  axis(1,at=1:ncol(boxplot.diff.matrix),labels=date.seq.overlap.format,las=2)
  dev.off()
  }

  if(MAKE.SPATIAL.PLOTS){
  #Spatial plots of hourly difference
  plot.diff.matrix <- sim1.spec-sim2.spec
  zlim.range <- c(-max(abs(plot.diff.matrix)),max(abs(plot.diff.matrix)))
  
  #Plot 24 timesteps at a time, with the color bar in the top left panel.
  pdf(paste0(output.dir,species.name,"_MAPS_",sim1.label.simple,"_vs_",sim2.label.simple,".pdf"),pointsize=1,height=7.5,width=11)  
  par(mfrow=c(5,5))
  plotting.seq <- seq(1,n.time,by=24)
  for(t in plotting.seq){
    par(mar=c(.1,.1,2,8))
    plot(1,1,axes=F,type="n",xlab="",ylab="")
    image.plot(legend.only=T,zlim=zlim.range,legend.width=4,col=my.diff.col(100))
	legend("center",bty="n",text.font=2,cex=1.5,legend=paste0(species.name," (",species.units,"): ",sim1.label," - ","\n",sim2.label))
    for(i in t:(t+23)){
	  if(n.time < i) break
      par(mar=c(1,1,1,1))
      plot.diff.i <- plot.diff.matrix[,,i]
      #When difference is exactly 0, replace with NA so that it will show up as white space.
      plot.diff.i[plot.diff.i==0] <- NA
      image(x.proj.coord,y.proj.coord,plot.diff.i,zlim=zlim.range,
      main=paste(date.seq.overlap.format[i],species.name),
      axes=F,xlab="",ylab="",col=my.diff.col(100))
      lines(map.lines,lwd=.5,col=grey(.3)) 
      box()
    }
	}
  dev.off()
  }
}

#Save the dataframe with max differences.
if(SAVE.DIFFERENCES){
  write.table(paste0(output.dir,"Max_Differences_",sim1.label.simple,"_vs_",sim2.label.simple,".csv"),
				sep=",",row.names=F,col.names=T,quote=F)
}
