#> Set up color scales for maps.
my.colors <- colorRampPalette(c(grey(.99),"#E6E6E6","#999999","#56B4E9","#0072B2","#009E73","#F0E442","#E69F00","#D55E00","#CC79A7"))

#If you prefer to see if differences close to zero are positive or negative use these colors:
#my.col.cool <- colorRampPalette(c("darkorchid4","purple","#002FFF","#0072B2","#009E73","palegreen3"))
#my.col.warm <- colorRampPalette(c("#F0E442","#E69F00","#D55E00","#CC79A7","red","#A52A2A"))

#If you prefer for differences close to 0 (small positive and small negative) to be grey:
my.col.cool <- colorRampPalette(c("darkorchid4","purple","#002FFF","#0072B2","#009E73","palegreen3",grey(.99)))
my.col.warm <- colorRampPalette(c(grey(.99),"#F0E442","#E69F00","#D55E00","#CC79A7","red","#A52A2A"))


####################################################
#> Function: find.zlim
#> Purpose: Set up zlim and color scale for concentration maps. 
#> Input:
#> - data: data to be plotted.
#> Returns a list containing:
#> - my.col: vector of colors
#> - my.zlim: range for zlim argument in image.plot
#> - my.at: location of zlim labels on z-scale (used in axis.args argument of image.plot) 
#> - my.labels: zlim labels (used in axis.args argument of image.plot) 

find.zlim <- function(data){
 #Select an intitial color bar with n colors.
 pretty.seq <- pretty(data,n=50)
 #Set up zlim and colors for plotting.
 my.zlim <- range(pretty.seq)
 my.col.n <- length(pretty.seq)-1
 my.col <- my.colors(my.col.n)
 my.at <- pretty(seq(my.zlim[1],my.zlim[2],length=my.col.n+1),n=8)
 my.labels <- my.at
 #Fix color scale in the case where there are a handful of very large values that could skew the range.
 #Cap rule of thumb 1: Cap if top .01% of the values are more than 50% greater than the rest of the spatial field.
 cap.scale <- quantile(data,.999,na.rm=T)
 check.cap <- max(data) > 1.5*cap.scale
 #For Ben: Cap rule of thumb 2: Cap at 3 x SD + mean of spatial field.
 #cap.scale <- 3*sd(data)+mean(data)
 #check.cap <- max(data) > cap.scale
 if(check.cap){
   new.range <- pretty(data[data<= cap.scale],n=50)
   my.zlim <- c(min(new.range), max(new.range)+(new.range[2]-new.range[1]))  
   my.col <- c(my.col,"brown")
   my.col.n <- length(my.col)
   breaks.init <- pretty(seq(my.zlim[1],my.zlim[2],length=my.col.n+1),n=8)
   n.breaks <- length(breaks.init)
   my.at <- c(breaks.init[-n.breaks],my.zlim[2])
 #  my.labels <- c(my.at[-n.breaks],"")
   my.labels <- c(my.at[1:(n.breaks-2)],paste(">",my.at[(n.breaks-1)]),"")
 }
 list(my.col=my.col,my.zlim=my.zlim,my.at=my.at,my.labels=my.labels)
}


####################################################
#> Function: find.diff.zlim
#> Purpose: Set up zlim and color scale for maps of differences (concentration or %).  
#> Input:
#> - data: data to be plotted.
#> Returns a list containing:
#> - my.diff.col: vector of colors
#> - my.diff.zlim: range for zlim argument in image.plot
#> - my.diff.at: location of zlim labels on z-scale (used in axis.args argument of image.plot) 
#> - my.diff.labels: zlim labels (used in axis.args argument of image.plot) 

find.diff.zlim <- function(diff.data){
 #Select color bar for difference plots.
 diff.pretty.seq <- pretty(diff.data,n=50)
 my.diff.zlim <- range(diff.pretty.seq)
 my.col.cool.n <- sum(diff.pretty.seq < 0)
 my.col.warm.n <- max(0,(sum(diff.pretty.seq >= 0)-1))
 my.diff.col <- c(my.col.cool(my.col.cool.n),my.col.warm(my.col.warm.n))
 my.diff.col.n <- length(my.diff.col)
 my.diff.breaks <- seq(my.diff.zlim[1],my.diff.zlim[2],length=(my.diff.col.n+1))
 my.diff.breaks1 <- seq(my.diff.zlim[1],my.diff.zlim[2],by=(my.diff.zlim[2]-my.diff.zlim[1])/(my.diff.col.n))
 my.diff.at <- pretty(my.diff.breaks,n=8)
 my.diff.labels <- my.diff.at
 #Fix color scale for difference plots in the case where there are a handful of very large values that could skew the range.
 #Cap rule of thumb 1: Cap if top .01% of the values are more than 100% greater than the rest of the spatial field.
 cap.diff.scale <- quantile(abs(diff.data),.999,na.rm=T)
 check.diff.cap <- max(abs(diff.data),na.rm=T) > 2*cap.diff.scale
 if(check.diff.cap){
    new.diff.range <- pretty(c(diff.data[diff.data <= cap.diff.scale & diff.data >= -cap.diff.scale]),n=50)
    my.diff.zlim <- c(min(new.diff.range)-(new.diff.range[2]-new.diff.range[1]), max(new.diff.range)+(new.diff.range[2]-new.diff.range[1]))  
    my.col.cool.n <- sum(new.diff.range < 0) 
    my.col.warm.n <- max(0,sum(new.diff.range >= 0)-1) 
    my.diff.col <- c("darkorchid4",my.col.cool(my.col.cool.n),my.col.warm(my.col.warm.n),"brown")    
    my.diff.col.n <- length(my.diff.col)
    my.diff.breaks <- seq(my.diff.zlim[1],my.diff.zlim[2],length=my.diff.col.n+1)
    breaks.init <- pretty(my.diff.breaks,n=6)
    n.diff.breaks.init <- length(breaks.init)
    my.diff.at <- c(my.diff.zlim[1],breaks.init[-c(1,n.diff.breaks.init)],my.diff.zlim[2])
    my.diff.labels <- c("",paste("<",my.diff.at[2]),my.diff.at[3:(n.diff.breaks.init-2)],paste(">",my.diff.at[(n.diff.breaks.init-1)]),"")
}
 list(my.diff.col=my.diff.col,my.diff.zlim=my.diff.zlim,my.diff.breaks=my.diff.breaks,my.diff.at=my.diff.at,my.diff.labels=my.diff.labels)
}

