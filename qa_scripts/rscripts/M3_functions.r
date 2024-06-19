####################################################################################
# Information on package ‘M3’
# 
# Description:
# 
# Package:            M3
# Type:               Package
# Title:              Reading M3 files
# Version:            0.3
# Date:               2012-01-14
# Author:             Jenise Swall <jswall@vcu.edu>
# Maintainer:         Jenise Swall <jswall@vcu.edu>
# Depends:            ncdf4,rgdal,maps,mapdata
# Description:        This package contains functions to read in and manipulate air
#                     quality model output from Models3-formatted files.  This format is
#                    used by the Community Multiscale Air Quaility (CMAQ) model.
# License:            Unlimited
# LazyLoad:           yes
# Packaged:           2012-05-16 16:38:17 UTC; jenise
# Repository:         CRAN
# Date/Publication:   2012-05-16 17:07:10
# Built:              R 4.3.0; ; 2024-05-29 18:19:50 UTC; unix

# Index:
# 
# M3-package              Functions to read in and manipulate air quality
#                         model output from files in Models3 format
# combine.date.and.time   Combine date and time to obtain date-time in
#                         POSIX format
# decipher.M3.date        Decipher Models3 date format (YYYYDDD) into R's
#                         Date class.
# decipher.M3.time        Decipher Models3 time format (HHMMSS) into
#                         hours, minutes, and seconds.
# get.M3.var              Read in variable values from Models3-formatted
#                         files
# get.canusamex.bds       Obtain map boundaries for Canada, USA, and
#                         Mexico
# get.coord.for.dimension
#                         Get the grid coordinates for the grid rows or
#                         columns.
# get.datetime.seq        Read in a sequence of date-time steps from a
#                         Models3-formatted file.
# get.grid.info.M3        Get information about the grid used by the air
#                         quality model
# get.map.lines.M3.proj   Get map lines in the model projection units
# get.matrix.all.grid.cell.ctrs
#                         Obtain a matrix giving the locations of the
#                         grid cell centers
# get.proj.info.M3        Obtain information about the projection used in
#                         the Models3 file
# project.M3.1.to.M3.2    Project coordinates based on projection in the
#                         first file to the projection given in the
#                         second
# project.M3.to.lonlat    Project coordinates from model units to
#                         longitude/latitude
# project.lonlat.to.M3    Project coordinates from longitude/latitude to
#                         model units.
# var.subset              Subset the array resulting from a call to
#                         'get.M3.var'.
####################################################################################

library(rgdal)
library(ncdf4)
library(mapdata)
library(maps)

## ###########################################################
## PURPOSE: Combine date and time to obtain date-time in POSIX format.
##
## INPUTS:
##   date: Date in Date format or as character string in format "YYYY-MM-DD".
##   time: Time as list with hrs, mins, and secs components or as
##      character string in "HH:MM:SS" (with hours 00-23).
##
## RETURNS: A date-time in POSIX format.
##
## ASSUMES: This code assumes that the time is not negative.  (For
##   instance, the Models3 I/OAPI does allow for negative time steps,
##   but these negative time steps will NOT be handled properly by
##   this function.)
##
##
## REVISION HISTORY:
##   Original release: Jenise Swall, 2011-05-19
## ###########################################################
combine.date.and.time <- function(date, time){

  ## Check whether time is a list like that returned by the
  ## decipher.M3.time() function.
  if (is.list(time))  
    datetime <- strptime(paste(as.character(date), " ", time$hrs, ":",
                               time$mins, ":", time$secs, sep=""),
                         format="%Y-%m-%d %H:%M:%S", tz="GMT")

  ## Otherwise, assume time is a character string of form HH:MM:SS.
  else
    datetime <- strptime(paste(as.character(date), " ", time, sep=""),
                         format="%Y-%m-%d %H:%M:%S", tz="GMT")

  return(datetime)
}


## ###########################################################
## PURPOSE: Decipher Models3 date format (YYYYDDD) into R's Date
##   class.
##
## INPUT: Models3 date (numeric) in the format YYYYDDD, where DDD is
##   a Julian day (since the beginning of YYYY).
##
## RETURNS: Starting date YYYYDDD in R's Date class.
##
##
## NOTE: The Models3 date is an integer, so we can't just extract the
##   first 4 characters, next 3 characters, etc.
##
##
## REVISION HISTORY:
##   Original release: Jenise Swall, 2011-05-19
## ###########################################################
decipher.M3.date <- function(M3.date){

  ## Find the year.
  yr <- trunc(M3.date/1000)

  ## Find number of minutes.
  julian.day <- M3.date %% 1000

  ## The first day of this year is our base date.
  jan1.yr <- as.Date(paste(yr, "-01-01", sep=""), format="%Y-%m-%d")

  ## Pass to as.Date function the number of days since the "origin"
  ## date.  Our origin date is Jan. 1, YYYY, which is stored as a Date
  ## object in jan1.yr.  Note that Jan. 1, YYYY is Julian day 001.
  my.date <- as.Date(julian.day-1, origin=jan1.yr) 

  return(my.date)
}

## ###########################################################
## PURPOSE: Decipher Models3 time format (HHMMSS) into hours, minutes,
##   and seconds.
##
## INPUT: Models3 time (numeric) in the format HHMMSS
##
## RETURNS: List with hrs (hours), mins (minutes), and secs (seconds)
##   components.
##
## ASSUMES: This code assumes that the time is not negative.  (For
##   instance, the Models3 I/OAPI does allow for negative time steps,
##   but these negative time steps will NOT be handled properly by
##   this function.)
##
## NOTE: The Models3 time is an integer, so we can't just extract the
##   first 2 characters, next 2 characters, etc.  If the time step is
##   one hour, then the time we extract will be 100, not 000100.
##
##
## RELEASE HISTORY:
##   Original release: Jenise Swall, 2011-05-19
## ###########################################################
decipher.M3.time <- function(M3.time){

  ## Find number of hours.
  hrs <- trunc(M3.time/10000)

  ## Find number of minutes.
  mins <- trunc( (M3.time - (hrs * 10000)) / 100 )

  ## Find number of seconds
  secs <- M3.time - (hrs*10000) - (mins * 100)

  return(list(hrs=hrs, mins=mins, secs=secs))
}

## ###########################################################
## PURPOSE: Obtain outlines of Canada, USA, and Mexico, including
## state lines.
##
##
## INPUT: No input arguments.
##
## 
## RETURNS: A list containing two elements "coords" and "units", The
##   element "coords" contains a matrix with the map lines in the
##   projection coordinates.  The element "units" contains the units
##   of the coordinates ("km" or "m").
##
##
## ASSUMES:
##   Availability of R packages maps and mapdata.
##
##
## REVISION HISTORY:
##   Original release: Jenise Swall, 2012-05-15
## ###########################################################
get.canusamex.bds <- function(){

  ## Get maps of Canada, USA, Mexico in high-resolution from mapdata
  ## package.
  canusamex.natl <- map("worldHires", regions=c("Canada", "USA", "Mexico"),
                   exact=FALSE, resolution=0, plot=FALSE)
  canusamex.natl.lonlat <- cbind(canusamex.natl$x, canusamex.natl$y)
  rm(canusamex.natl)


  ## Get map of state borders, without including the outer boundaries.
  ## These outer boundaries are provided by the the high-resolution
  ## national maps created in the previous step.
  state <- map("state", exact=F, boundary=FALSE, resolution=0, plot=FALSE)
  state.lonlat <- cbind(state$x, state$y)
  rm(state)


  ## Put it national and state boundaries together.
  canusamex <- rbind(canusamex.natl.lonlat, matrix(NA, ncol=2), state.lonlat)
  rm(canusamex.natl.lonlat, state.lonlat)


  ## Return the boundaries to the calling program/function.
  return(canusamex)
}

## ###########################################################
## PURPOSE: For either the rows or the columns, return the coordinates
##   of the centers or the edges of the grid cells.
##
## INPUT:
##   file: File name of Models3-formatted file of interest.
##   dimension: User chooses to get information for either rows
##     ("row") or columns ("column" or "col").
##   position: User chooses whether to get center (default), lower
##     edge, or upper edge coordinates of each row or each column.
##   units: "m" (meters), "km" (kilometers), or "deg" (degrees).  If
##     unspecified, the default is "deg" if the file has a
##     longitude/latitude based grid, and "km" otherwise.
##
## RETURNS: A list containing two elements, "coords" and "units".  If
##   dimension is "row", return as element "coords" a vector
##   containing the y-coordinate of the center, left ("lower"), or
##   right ("upper") edge of each row, depending on the value of
##   argument "position".  If dimension is "column" or "col", return as 
##   element "coords" a vector containing the x-coordinate of the center,
##   left ("lower"), or right ("upper") edge of each row, depending on
##   the value of argument "position".  In both cases, return as element
##   "units" the units of the coordinates (can be "km", "m", or "deg").
##
## ASSUMES:
##   Availability of function get.grid.info.M3().
##
##
## REVISION HISTORY:
##   Original release: Jenise Swall, 2011-05-20
## ###########################################################
get.coord.for.dimension <- function(file, dimension, position="ctr",
                                    units){

  ## Get info about the grid.
  grid.info <- get.grid.info.M3(file)


  ## Depending on whether we want the center, lower edge, or upper
  ## edge for each cell, we set the offset appropriately.
  if (position=="ctr")
    offset <- 0.5
  else if (position=="lower")
    offset <- 0.0
  else if (position=="upper")
    offset <- 1.0
  else
    stop('Position parameter must be either "lower", "ctr", or "upper".')


  ## Take different actions depending on whether user chooses "row" or
  ## "column" for dimenstions.
  if (dimension=="row")
    coords <- seq(from=grid.info$y.orig+(offset*grid.info$y.cell.width), by=grid.info$y.cell.width, length=grid.info$nrows)
  else if ( (dimension=="column") || (dimension=="col") )
    coords <- seq(from=grid.info$x.orig+(offset*grid.info$x.cell.width), by=grid.info$x.cell.width, length=grid.info$ncols)
  else
    stop('Parameter dimension must be either "row" or "column".')


  ## ##########################
  ## Compare the units returned by get.grid.info.M3() to the
  ## desired units specified by the user.  Convert from m to km, if
  ## necessary.  If the user does not specify desired units, then use
  ## "deg" if the file is based on longitude/latitude and "km"
  ## otherwise.  Warn the user if the units they specified are degrees
  ## ("deg") when the file has meters ("m"), or vice-versa.  If user
  ## specifies an option other than "km", "m", or "deg" for parameter
  ## units, give message and exit function.


  ## If user does not specify units, we look at the units specified in
  ## the object returned by the call to get.grid.info.M3().  If it
  ## it is"deg", we return "deg".  Otherwise we return "km".  
  if (missing(units)){
    if (grid.info$hz.units=="deg")
      units <- "deg"
    else{
      coords <- coords/1000
      units <- "km"
    }
  }

  ## If user specifies "km" we either need to
  ## (1) transform from m, or
  ## (2) warn the user and keep degrees, if grid is in degrees long/lat
  else if (units=="km"){
    if (grid.info$hz.units=="m")  ## Divide by 1000 to go from m to km.
      coords <- coords/1000
    else if (grid.info$hz.units=="deg"){
      warning(paste("Grid specified in file ", file, " is in degrees long/lat; returning degrees.", sep=""))
      units <- "deg"
    }
  }

  ## If the user specifies "m" we just need to make sure the grid is
  ## not in degrees long/lat.  If it is, warn user and keep degrees.
  else if (units=="m"){
    if (grid.info$hz.units=="deg"){
      warning(paste("Grid specified in file ", file, " is in degrees long/lat; returning degrees.", sep=""))
      units <- "deg"
    }
  }

  ## If the user specifies "degrees" we just need to make sure the
  ## grid is specified in degrees long/lat.  If not, we warn user and
  ## return "km".
  else if (units=="deg"){
    if (grid.info$hz.units=="m"){
      warning(paste("Grid specified in file ", file, " is on a projection other than degrees long/lat; returning kilometers.", sep=""))
      coords <- coords/1000
      units <- "km"
    }
  }

  ## If the user specifies something other than "m", "km", or "deg",
  ## we stop and print an error message.
  else
    stop(paste(units, " is not a valid option.for 'units'.", sep=""))
  ## ##########################


  ## Return a list, with the coords in the first position and the
  ## units of those coords in the second.
  x <- list(coords=coords, units=units)
  return(x)
}

## ###########################################################
## PURPOSE: Read the date-time steps in the Models3-formatted file.
##   Put these into datetime format.
##
## INPUT:
##   file: File name of Models3-formatted file of interest.
##
## RETURNS: List of datetimes included in the Models3-formatted file.
##
## ASSUMES: This code assumes that the time step is not negative.
##   (For instance, the Models3 I/OAPI does allow for negative time
##   steps, but these negative time steps will NOT be handled properly
##   by this function.)
##
##
## REVISION HISTORY:
##   Original release: Jenise Swall, 2011-06-02
## ###########################################################
get.datetime.seq <- function(file){

  ## Open netCDF file which has the projection we want to use.
  nc <- nc_open(file)


  ## Get information about the time step increment.
  tstep.incr <- ncatt_get(nc, varid=0, attname="TSTEP")$value

  ## Test to see whether the file is time-independent (in which case,
  ## the time increment will be 0).
  if (tstep.incr==0){
    ## Close the Models3 file, issue warning, and exit the function.
    nc <- nc_close(nc)
    warning("Time step increment is zero.  This appears to be a time-independent file.")
    return(NULL)
  }

  
  ## If the time increment is not zero, then we assume there are time
  ## steps for the variables in the file.

  ## Find the starting date and time.
  M3.start.date <- ncatt_get(nc, varid=0, attname="SDATE")$value
  start.date <- decipher.M3.date(M3.start.date)
  M3.start.time <- ncatt_get(nc, varid=0, attname="STIME")$value
  start.time <- decipher.M3.time(M3.start.time)

  ## Combine the starting date and time to form datetime object (POSIX
  ## class).
  start.datetime <- combine.date.and.time(date=start.date, time=start.time)

  
  ## Find the increment separating the time steps.
  tstep.incr.list <- decipher.M3.time(tstep.incr)
  ## To find the increment of the time step in seconds.
  tstep.in.secs <- (tstep.incr.list$hrs*60*60) + (tstep.incr.list$mins*60) + tstep.incr.list$secs

  
  ## How many datetimes are there?  (What is the length of the time
  ## dimension?)
  num.time.steps <- nc$dim$TSTEP$len

  
  ## Now get a sequence.
  datetime.seq <- seq.POSIXt(from=start.datetime, by=tstep.in.secs,
                             length.out=num.time.steps)

  
  ## Close the Models3 file.
  nc <- nc_close(nc)
  rm(nc)


  ## Return the date-time sequence we've developed.
  return(datetime.seq)
}


## ###########################################################
## PURPOSE: Pull information about the grid used from the
##   Models3-formatted file.  This includes information such as the
##   origin of the grid (lower left corner coordinates in grid units).
##
## INPUT:
##   file: File name of Models3-formatted file whose projection we
##     want to use.
##
## RETURNS: List containing information about the grid, including the
##   origin point of the grid (lower left coordinates in grid units),
##   projection, grid cell spacing, etc.
##
## 
## NOTES:
##   Information about grid cell size, extent of grid, etc. is stored
##   in global attributes of the Models3-formatted file.
##
##
## REVISION HISTORY:
##   Original release: Jenise Swall, 2011-06-02
## ###########################################################
get.grid.info.M3 <- function(file){

  ## Open netCDF file which has the projection we want to use..
  nc <- nc_open(file)


  ## Find out if the file is indexed according to longitude/latitude
  ## (GDTYP=1).  If so, the horizontal units are degrees ("deg").  If
  ## not, then the units are meters ("m") by default.
  grid.type <- ncatt_get(nc, varid=0, attname="GDTYP")$value
  if (grid.type==1)
    hz.units <- "deg"
  else
    hz.units <- "m"


  ## Get information about the origin (lower left coordinates in grid
  ## units).
  x.orig <- ncatt_get(nc, varid=0, attname="XORIG")$value
  y.orig <- ncatt_get(nc, varid=0, attname="YORIG")$value

  ## Get information about the horizontal grid cell size (meters).
  x.cell.width <- ncatt_get(nc, varid=0, attname="XCELL")$value
  y.cell.width <- ncatt_get(nc, varid=0, attname="YCELL")$value

  ## Number of rows and columns tells us the extent of the grid.
  ncols <- ncatt_get(nc, varid=0, attname="NCOLS")$value
  nrows <- ncatt_get(nc, varid=0, attname="NROWS")$value
  ## Get number of vertical layers.
  nlays <- ncatt_get(nc, varid=0, attname="NLAYS")$value

  ## Now form a list to hold this information about the grid.
  grid.info.list <- list(x.orig=x.orig, y.orig=y.orig,
                         x.cell.width=x.cell.width,
                         y.cell.width=y.cell.width,
                         hz.units=hz.units,
                         ncols=ncols, nrows=nrows, nlays=nlays)


  ## Close the Models3 file.
  nc <- nc_close(nc)
  rm(nc)

  ## Return the string which can be passed to project() and other
  ## functions in R package rgdal.
  return(grid.info.list)
}

## ###########################################################
## PURPOSE: Read in variable values from Models3-formatted files.
##
## INPUT:
##   file: name of Models3-formatted file to be read
##   var: name (character string) or number (positive integer) of
##     variable whose values are to be read
##   lcol, ucol: Lower and upper column bounds (positive integers) to
##     be read.  The default is to read all columns.
##   lrow, urow: Lower and upper row bounds (positive integers) to be
##     read.  The default is to read all rows.
##   llay, ulay: Lower and upper layer bounds (positive integers) to
##     be read.  The default is to read the first layer only.
##   ldatetime, udatetime: Starting and ending date-times (either Date
##     or POSIX class) in GMT.  The default is to read all date-times.
##     If the file is time-independent, the one available time step
##     will be read and user input for ldatetime and udatetime will be
##     disregarded.
##   hz.units: Units associated with grid cell horizontal dimensions.
##     Default is degrees ("deg") if the data is indexed according to
##     longitude/latitude and kilometers ("km") otherwise.  If the
##     file is not indexed according to longitude/latitude, the user
##     could specify meters ("m").
##
##
## RETURNS: List with several elements.
##   Element "data" holds the actual variable values in a 4D (or 3D,
##     in the case of time-independent files) array.  Dimensions are
##     columns, rows, layers, date-time steps.
##   Element "data.units" holds the units associated with "data".
##   Elements "x.cell.ctr" and "y.cell.ctr" give the coordinates of the
##     centers of the grid cells in units given by "hz.units".
##   Element "hz.units" gives the units associated with the
##     horizontal dimensions of the grid cells (km, m, or deg).
##   Element "rows" gives the row numbers extracted.
##   Element "cols" gives the column numbers extracted.
##   Element "layers" gives the layer numbers extracted.
##   Element "datetime" gives the date-time steps associated with the
##     variable, if the file is not time-independent.  For
##     time-independent files, element datetime is set to NULL.
##
## ASSUMES: The Models3-formatted file is either time-independent or
##   time-stepped.  It cannot be of type circular-buffer.
##
##
## REVISION HISTORY:
##   Original release: Jenise Swall, 2011-06-02
## ###########################################################
get.M3.var <- function(file, var, lcol, ucol, lrow, urow,
                            llay, ulay, ldatetime, udatetime,
                            hz.units){

  ## Open netCDF file which has the projection we want to use..
  nc <- nc_open(file)


  ## ##########################
  ## MAKE SURE THE VARIABLE SPECIFIED IN PARAMETER var IS VALID.

  ## Get list of variable names.  Check that the variable name
  ## provided is on the list.  If a variable number is provided, make
  ## sure that there is a variable with that number.
  all.varnames <-  names(nc$var)
  

  ## Check to make sure the user specified a variable to read.  If
  ## not, close file, print error message, and exit.
  if (missing(var)){
    nc <- nc_close(nc)
    stop( paste("Specify the name or number of the variable to be read.  Variable names are: ", paste(all.varnames, collapse=", "), sep="") )
  }


  ## If var is a character string, its name must be on the list of
  ## variable names.
  if ( is.character(var) && !(var %in% all.varnames) ){
    nc <- nc_close(nc)
    stop( paste("File ", file, " does not contain variable named ", var, sep="") )
  }


  ## If var is numeric, it must be an integer between 1 and the number
  ## of variables.
  if (is.numeric(var)){

    ## Specified variable number must be an integer.
    if ( !(trunc(var) == var) ){
      nc <- nc_close(nc)
      stop( paste("Parameter var must be a whole number between 1-", length(all.varnames), sep="") )
    }

    ## Specified variable number cannot be less than 1 or more than
    ## the number of variables.    
    if ( (var < 1) || (var > length(all.varnames)) ){
      nc <- nc_close(nc)
      stop( paste("File ", file, " contains variables numbered 1-", length(all.varnames), sep="") )
    }
  }


  ## Parameter var must be either numeric or a character string.
  if ( !is.numeric(var) && !is.character(var) ){
    nc <- nc_close(nc)
    stop( "Parameter var must give either the name or number of the variable to be read." )
  }
  ## ##########################


  ## ##########################
  ## MAKE SURE THE INPUT FOR WHICH ROWS, COLUMNS, AND LAYERS TO READ
  ## MAKES SENSE.

  ## Find out the dimensions of the chosen variable.  I assume that
  ## these are listed in terms of number of columns, number of rows,
  ## number of layers, number of date-time steps.
  dimens <- nc[["var"]][[var]][["size"]]
  if (length(dimens) < 4){
    nc <- nc_close(nc)
    stop( "There are less than 4 dimensions in this file.")
  }


  ## If lower/upper column limits are missing, then make them the
  ## minimum/maximum available in the file.
  if (missing(lcol))
    lcol <- 1
  if (missing(ucol))
    ucol <- dimens[1]
  ## Check to make sure that the upper column limit is greater than or
  ## equal to the lower column limit.
  if (ucol < lcol){
    nc <- nc_close(nc)
    stop(paste("Upper column limit, ", ucol, ", is less than lower column limit, ", lcol, sep=""))
  }

  
  ## If lower/upper row limits are missing, then make them the
  ## minimum/maximum available in the file.
  if (missing(lrow))
    lrow <- 1
  if (missing(urow))
    urow <- dimens[2]
  ## Check to make sure that the upper row limit is greater than or
  ## equal to the lower row limit.
  if (urow < lrow){
    nc <- nc_close(nc)
    stop(paste("Upper row limit, ", urow, ", is less than lower column limit, ", lrow, sep=""))
  }

  
  ## If lower/upper row limits are missing, then make them the
  ## minimum/maximum available in the file.
  if (missing(llay))
    llay <- 1
  if (missing(ulay))
    ulay <- dimens[3]
  ## Check to make sure that the upper layer limit is greater than or
  ## equal to the lower layer limit.
  if (ulay < llay){
    nc <- nc_close(nc)
    stop( paste("Upper layer limit, ", ulay, ", is less than lower layer limit, ", llay, sep="") )
  }


  ## Check to make sure row, column, and layer limits are positive numbers.
  if ( (lcol <= 0) && (ucol <= 0) && (lrow <= 0) && (urow <= 0) && (llay <= 0) && (ulay <= 0)){
    nc <- nc_close(nc)
    stop("Upper and lower row, column, and layer boundaries must be positive.")
  }


  ## Find the proper subset of columns.
  col.seq <- 1:dimens[1]
  which.col <- which( (lcol <= col.seq) & (col.seq <= ucol) )
  start.col <- min(which.col)
  count.col <- max(which.col) - min(which.col) + 1
  
  ## Find the proper subset of rows.
  row.seq <- 1:dimens[2]
  which.row <- which( (lrow <= row.seq) & (row.seq <= urow) )
  start.row <- min(which.row)
  count.row <- max(which.row) - min(which.row) + 1
  
  ## Find the proper subset of layers.
  lay.seq <- 1:dimens[3]
  which.lay <- which( (llay <= lay.seq) & (lay.seq <= ulay) )
  start.lay <- min(which.lay)
  count.lay <- max(which.lay) - min(which.lay) + 1
  ## ##########################


  ## ##########################
  ## SUBSET THE DATE-TIMES (parameters ldatetime, udatetime).

  ## Check whether the file is time independent.  It is time
  ## independent if the time step increment is zero.
  tstep.incr <- ncatt_get(nc, varid=0, attname="TSTEP")$value


  ## If the time step is not 0, ensure we get the correct range of
  ## time steps.
  if (tstep.incr != 0){

    ## Form a sequence of all the datetimes included in the Models3 file.
    datetime.seq <- get.datetime.seq(file)


    ## If ldatetime is missing, assign it the earliest date-time; if
    ## udatetime is missing assign it the latest date-time.
    if (missing(ldatetime))
      ldatetime <- min(datetime.seq)
    if (missing(udatetime))
      udatetime <- max(datetime.seq)
  

    ## Check to see if the date-time limits are in Date format.  If so,
    ## make them into a POSIX format date.  For the lower limit, this
    ## would mean a time stamp at midnight (beginning of the given
    ## date).  For the upper limit, this would mean a time stamp at 23:59:59
    ## (last part of the given date).
    if ("Date" %in% class(ldatetime))
      ldatetime <- combine.date.and.time(date=ldatetime, time="00:00:00")
    if ("Date" %in% class(udatetime))
      udatetime <- combine.date.and.time(date=udatetime, time="23:59:59")


    ## Check to make sure lower bound on datetime is same as or earlier
    ## than the upper bound.
    if (udatetime < ldatetime){
      nc <- nc_close(nc)
      stop(paste("Upper date-time bound, ", udatetime, ", is before lower date-time bound, ", ldatetime, sep=""))
    }


    ## Find the dates in the sequence which fall in the specified range.
    which.datetime <- which( (ldatetime <= datetime.seq) & (datetime.seq <= udatetime) )
    start.datetime <- min(which.datetime)
    count.datetime <- max(which.datetime) - min(which.datetime) + 1
  }


  ## For a time indep. file, can only read the one time step available.
  else{
    message("Time independent file - reading only time step available.")
    start.datetime <- 1
    count.datetime <- 1
  }
  ## ##########################


  ## ##########################
  ## ACTUALLY EXTRACT THE DATA FOR THIS VARIABLE (parameter var).

  extracted.data <- ncvar_get( nc, varid=var, start=c(start.col, start.row, start.lay, start.datetime), count=c(count.col, count.row, count.lay, count.datetime) )

  ## If the time step is not 0, then there are presumably meaningful
  ## time steps in this file.  If the time step is 0, then the file is
  ## time-independent, and we allow the array to be a 3D array.
  
  ## Force this matrix/array into a 4D array, so that all dimensions
  ## are represented, even if some dimensions are of length 1.  Then,
  ## we pass the units for each dimension.
  if (tstep.incr != 0)
    dim(extracted.data) <- c(count.col, count.row, count.lay,
                           count.datetime)
  else
    dim(extracted.data) <- c(count.col, count.row, count.lay)


  ## If units for this data given, store them.  Otherwise, mark the
  ## data units as missing.
  info.data.units <-  ncatt_get(nc, varid=var, attname="units")
  if (info.data.units$hasatt)
    data.units <- info.data.units$value
  else
    data.units <- NA
  rm(info.data.units)
  ## ##########################

  
  ## ##########################
  ## FIND THE UNITS ASSOCIATED WITH X- AND Y- COORDINATES (IN MODEL
  ## UNITS) OF THE CENTER OF THE GRID CELLS.  IF USER HAS SPECIFIED
  ## THE DESIRED UNITS, WE PASS THAT ALONG TO
  ## get.coord.for.dimension(); OTHERWISE, WE TAKE DEFAULT UNITS
  ## RETURNED BY get.coord.for.dimension().  WE ALREADY HAVE THE
  ## DATETIME SEQUENCE FROM THE CALCULATIONS ABOVE.
  if (missing(hz.units)){
    all.x.coord <- get.coord.for.dimension(file, dimension="col",
                                       position="ctr")
    all.y.coord <- get.coord.for.dimension(file, dimension="row",
                                       position="ctr")
  }
  else{
    all.x.coord <- get.coord.for.dimension(file, dimension="col",
                                       position="ctr", units=hz.units)
    all.y.coord <- get.coord.for.dimension(file, dimension="row",
                                       position="ctr", units=hz.units)
  }

  ## The units for the x and y-coordinates should be the same.  If
  ## not, something very strange has happened.
  if (!identical(all.x.coord$units, all.y.coord$units))
    stop(paste("Error: Units for x-coordinates and y-coordinates differ.  For x, units are ", all.x.coord$units, "; for y, ", all.y.coord$units, ".", sep=""))
  else
    hz.units <- all.x.coord$units
  

  ## If the user has specified only a certain subset of rows and
  ## columns to be returned, we subset the coordinates appropriately.
  x.coord <- all.x.coord$coords[which.col]
  y.coord <- all.y.coord$coords[which.row]
  rm(all.x.coord, all.y.coord)
  ## ##########################


  ## ##########################
  ## PUT DATA AND UNITS TOGETHER IN A LIST TO RETURN TO USER.

  ## If not a time-independent file, then include date-time steps.
  if (tstep.incr != 0)
    extracted.list <- list(data=extracted.data, data.units=data.units,
                           x.cell.ctr=x.coord, y.cell.ctr=y.coord,
                           hz.units=hz.units,
                           rows=row.seq[which.row],
                           cols=col.seq[which.col],
                           layers=lay.seq[which.lay],
                           datetime=datetime.seq[which.datetime])
  else
    extracted.list <- list(data=extracted.data, data.units=data.units,
                           x.cell.ctr=x.coord, y.cell.ctr=y.coord,
                           hz.units=hz.units,
                           rows=row.seq[which.row],
                           cols=col.seq[which.col],
                           layers=lay.seq[which.lay],
                           datetime=NULL)
  ## ##########################

  
  ## Close netCDF file.
  nc <- nc_close(nc)
  
  ## Return list of extracted information about variable var.
  return(extracted.list)
}

## ###########################################################
## PURPOSE: Get map lines in the model projection units.
## 
## INPUT:
##   file: File name of Models3-formatted file providing the model
##     projection.
##   database: Geogrpaphical database to use.  Choices are "world",
##     "canusamex", "worldHires", "usa", "state", and "county".
##     Default is "state".
##   units:  Units to be used for the projected coordinates; that is,
##     either "m" (meters) or "km" (kilometers). The option "deg" does
##     not make sense because we would not need to project coordinates
##     from a long/lat reference system to a Models3-formatted file
##     which was also gridded by long/lat.  If unspecified, the default
##     is "km".
##   ...: Other arguments to pass to get.proj.info.M3 function.
##     In this case, the only relevant argument would be the earth
##     radius to use when doing the projections.
##
##
## RETURNS: A list containing two elements "coords" and "units", The
##   element "coords" contains a matrix with the map lines in the
##   projection coordinates.  The element "units" contains the units
##   of the coordinates ("km" or "m").
##
## 
## ASSUMES:
##   Availability of R packages maps, mapdata, ncdf4, and rgdal.  Also
##   uses function get.canusamex.bds in this package.
##
##
## NOTE: The model projection units are of the sort derived in the
##       function proj.lonlat.to.M3().
##
##
## REVISION HISTORY:
##   Original release: Jenise Swall, 2011-06-02
##   
##   2012-01-11 (JLS): Added additional option of "canmex" for
##     database argument.  Changed argument "region" to argument named
##     "database" for compatibility with the map() function in the "maps"
##     package.
##
##   2012-05-15 (JLS): Changed option "canmex" to "canusmex" and added
##     option "WorldHires".  Both of these use the high-resolution
##     database in package "mapdata" to get better national boundardies
##     (and natural features like coastlines).  The old option "canmex"
##     only used the the relative low-resolution world maps for Canada
##     and Mexico, and was a bit more primitive.
## ###########################################################
get.map.lines.M3.proj <- function(file, database="state", units, ...){

  ## Form projection string describing the projection in the given
  ## Models3 file.
  proj.string <- get.proj.info.M3(file, ...)


  ## Return an error if the Models3 file given is already referenced
  ## by long/lat.  If it is, then we don't need to project the given
  ## coordinates, since they're already on the long/lat system.
  if ( substring(proj.string, first=7, last=13)=="longlat" )
    stop(paste("No need to project, since file ", file,
               " is gridded on long/lat system.", sep=""))


  ## Get the coords of the boundary lines in lat/lon.  If the user
  ## chooses a database like "state", "world", "usa", etc., then we
  ## can get the boundary lines using map() in the "maps" package.  If
  ## the user chooses "canmex", which is not an option for map(), we
  ## call a separate piece of code.
  if (database == "canusamex")
    map.lonlat <- get.canusamex.bds()
  else{
    raw.map.lonlat <- map(database, plot=FALSE, resolution=0)
    map.lonlat <- cbind(raw.map.lonlat$x, raw.map.lonlat$y)
    rm(raw.map.lonlat)
  }


  ## We want to re-project these map boundaries onto the projection that
  ## provided by the specified Models3 file.
  map.CMAQ <- project(map.lonlat, proj=proj.string)
  colnames(map.CMAQ) <- c("x", "y")
  rm(map.lonlat)


  ## ##########################
  ## If the user does not specify desired units, then use "km".  If
  ## user specifies an option other than "km" or "m", give message and
  ## exit function.

  if (missing(units)){
    map.CMAQ <- map.CMAQ/1000
    units <- "km"
  }
  else if (units=="km"){
    map.CMAQ <- map.CMAQ/1000
    units <- "km"
  }
  else if (units=="m")
    units <- "m"
  else
    stop(paste(units, " is not a valid option.", sep=""))
  ## ##########################


  ## Return a list, with the coords in the first position and the
  ## units of those coords in the second.
  x <- list(coords=map.CMAQ, units=units)
  return(x)
}

## ###########################################################
## PURPOSE: Find the locations of the grid cell centers in grid
##   units.
##
## INPUT:
##   file: File name of Models3-formatted file of interest.
##   units: "m" (meters), "km" (kilometers), or "deg" (degrees).  If
##     unspecified, the default is "deg" if the file has a
##     longitude/latitude based grid, and "km" otherwise.
##
## RETURNS: A list containing two elements "coords" and "units".  The
##   element "coords" contains a matrix with number of rows equal to the
##   number of grid cells and two columns.  The first column contains the
##   x-coordinate of the grid cell centers; the second column contains
##   the y-coordinate of the grid cell centers.  The points are
##   listed in order such that the x-coordinates are changing faster
##   than the y-coordinates.  The element "units" contains the units of
##   the coordinates (can be "km", "m", or "deg").
##
##
## REVISION HISTORY:
##   Original release: Jenise Swall, 2011-05-19
## ###########################################################
get.matrix.all.grid.cell.ctrs <- function(file, units){

  ## If user specifies the desired units, pass those on to the
  ## function get.coord.for.dimension().
  if (!missing(units)){
    x.coord <- get.coord.for.dimension(file, dimension="column",
                                       position="ctr", units=units)
    y.coord <- get.coord.for.dimension(file, dimension="row",
                                       position="ctr", units=units)
  }
  ## If user doesn't specify units, don't try to pass them.  The
  ## function get.coord.for.dimension() will return "deg" if the file
  ## is long/lat, and "km" otherwise.
  else{
    x.coord <- get.coord.for.dimension(file, dimension="column",position="ctr")
    y.coord <- get.coord.for.dimension(file, dimension="row", position="ctr")
  }
    
  ## The units for the x and y-coordinates should be the same.  If
  ## not, something very strange has happened.
  if (!identical(x.coord$units, y.coord$units))
    stop(paste("Error: Units for x-coordinates and y-coordinates differ.  For x, units are ", x.coord$units, "; for y, ", y.coord$units, ".", sep=""))


  ## Return a list with the first element a matrix with all combinations
  ## of these x- and y-coordinates and the units as the second element.
  all.ctrs <- as.matrix(expand.grid(x.coord$coords, y.coord$coords))
  colnames(all.ctrs) <- c("x", "y")
  
  return(list(coords=all.ctrs, units=x.coord$units))
}

## ###########################################################
## PURPOSE: Pull information about the projection used from a
##   Models3-formatted file.  Build a string describing the projection
##   which can be used by the R package rgdal.
##
## INPUT:
##   file: File name of Models3-formatted file whose projection we
##     want to use.
##   earth.radius: Assumes a spherical earth, but note that radius may
##     differ in different versions of the Models3 I/O API.  The
##     default is set to the current value (6 370 000 m) in I/O API.
##     An example of another choice is 6 370 997 m, which was the
##     radius used in previous versions of the Models3 I/O API and
##     in previous R packages supplied by Battelle.
##
## RETURNS: String describing model projection, which can be utilized
##   by the rgdal package in R (for projections to and from
##   longitude/latitude, for example).
##
## ASSUMES:
##   1. Your Models3-formatted file uses a Lambert conic conformal or
##      polar stereographic projection, or is gridded in
##      longitude/latitude coordinates.
##   2. Availability of R package ncdf4.
##
## 
## NOTES:
##   1. The R package rgdal depends on the PROJ.4 cartographic
##      projections library (http://trac.osgeo.org/proj/).  The format
##      of the string must therefore be in a style acceptable to
##      PROJ.4.  (See http://www.remotesensing.org/geotiff/proj_list.)
##   2. See information about the meaning of IOAPI projection
##      arguments at
##      http://www.baronams.com/products/ioapi/GRIDS.html.
##   3. Projection info is stored in global attributes of the
##      Models3-formatted file.
##
##
## REVISION HISTORY:
##   Original release: Jenise Swall, 2011-06-02
## ###########################################################
get.proj.info.M3 <- function(file, earth.radius=6370000){

  ## Open netCDF file which has the projection we want to use..
  nc <- nc_open(file)


  ## ##############################################
  ## Check the validity of earth.radius parameter.  The two most
  ## common entries would probably be 6370000 m (the default) or
  ## 6370997 m (the old Models3 value, as used in the R packages
  ## provided by Battelle).  One could also imagine these values
  ## being entered in kilometers, so we check for that.

  ## Test to see if earth.radius may have been accidentally listed in
  ## kilometers.  If so, it woulld probably be within these bounds.
  if ( (earth.radius > 6360) && (earth.radius < 6380) ){
    warning(paste("Assuming that the given radius, ", earth.radius,
                  ", is in kilomters.  Will use ", earth.radius*1000,
                  "m", sep=""))
    earth.radius <- earth.radius*1000
  }
  else if ((earth.radius < 6360000) || (earth.radius > 6380000))
    warning(paste("Using given radius, ", earth.radius,
                  ", but user should check that this radius is realistic."))
  ## ##############################################
  

  ## ##############################################
  ## FIND OUT THE PROJECTION AND PARAMETERS GOVERNING IT.
  
  ## Find out what projection the grid is on.
  grid.type <- ncatt_get(nc, varid=0, attname="GDTYP")$value

  ## Depending on the type of grid, we extract the information we need
  ## to govern that type of projection.  The projection info is found
  ## in the global attributes.  (To get global attributes, rather than
  ## variable attributes, give 0 as the variable ID.)

   ## Latitude/longitude (if GDTYP==1)
  if (grid.type==1){

    ## Lat/lon projection does not use parameters proj_alpha,
    ## proj_beta, and proj_gamma.
    proj.string <- paste("+proj=longlat", " +a=", earth.radius, " +b=",
                         earth.radius, sep="")
  }


  ## Lambert conic conformal (if GDTYP==2)
  else if (grid.type==2){
    ## Standard parallel 1 is given by P_ALP.
    p.alp <- ncatt_get(nc, varid=0, attname="P_ALP")$value
    ## Standard parallel 2 is given by P_BET.
    p.bet <- ncatt_get(nc, varid=0, attname="P_BET")$value
    ## Central meridian is given by P_GAM.
    p.gam <- ncatt_get(nc, varid=0, attname="P_GAM")$value
    ## Latitude of the center of the Cartesian coordinate system given
    ## by YCENT.
    ycent <- ncatt_get(nc, varid=0, attname="YCENT")$value

    ## Form string based on the projection information.
    proj.string <- paste("+proj=lcc +lat_1=", p.alp, " +lat_2=", p.bet,
                         " +lat_0=", ycent,
                         " +lon_0=", p.gam,
                         " +a=", earth.radius, " +b=", earth.radius, sep="")
  }


  ## Polar stereographic (if GDTYP==6)
  else if (grid.type==6){

    ## P_ALP identifies pole:  north (1) or south (-1)
    p.alp <- ncatt_get(nc, varid=0, attname="P_ALP")$value
    if (p.alp==1.0)
      proj4.lat0 <- 90.0  ##Latitude for North Pole for PROJ.4
    else if (p.alp==-1.0)
      proj4.lat0 <- -90.0  ##Latitude for South Pole for PROJ.4
    else{
      nc <- nc_close(nc)
      stop(paste("For polar stereographic projections (GDTYP=6), P_ALP is ",
                 p.alp, "; it should be either 1 or -1.", sep=""))
    }

    ## P_BET identifies the "secant latitude" (latitude of the true scale).
    p.bet <- ncatt_get(nc, varid=0, attname="P_BET")$value
    ## Central meridian is given by P_GAM.
    p.gam <- ncatt_get(nc, varid=0, attname="P_GAM")$value

    ## Form string based on the projection information.
    proj.string <- paste("+proj=stere +lat_ts=", p.bet,
                         " +lat_0=", proj4.lat0,
                         " +lon_0=", p.gam,
                         " +a=", earth.radius, " +b=", earth.radius, sep="")
  }


  ## Function will be exited with a warning if the grid type is not
  ## one of those listed above.
  else{
    ## Close the Models3 file and exit the function.
    nc <- nc_close(nc)
    stop(paste("Grid type ", grid.type, " cannot be handled by this function.", sep=""))
  }
  ## ##############################################

  
  ## Close the Models3 file.
  nc <- nc_close(nc)
  rm(nc)


  ## Return the string which can be passed to project() and other
  ## functions in R package rgdal.
  return(proj.string)
}

## ###########################################################
## PURPOSE: Project coordinates from longitude/latitude to model units.
##
## INPUTS:
##   longitude: vector of longitudes for the points to be projected
##   latitude: vector of latitudes for the points to be projected
##   file: File name of Models3-formatted file giving the desired model
##     projection.
##   units: Units to be used for the projected coordinates; that is,
##     either "m" (meters) or "km" (kilometers). The option "deg" does
##     not make sense because we would not need to project coordinates
##     from a long/lat reference system to a Models3-formatted file
##     which was also gridded by long/lat.  If unspecified, the default
##     is "km".
##   ...: Other arguments to pass to get.proj.info.M3 function.
##     In this case, the only relevant argument would be the earth
##     radius to use when doing the projections.
##
## RETURNS: A list containing two elements "coords" and "units".  The
##   element "coords" contains a matrix with the projected coordinates.
##   The element "units" contains the units of the coordinates ("km" or "m").
##
##
## REVISION HISTORY:
##   Original release: Jenise Swall, 2011-05-19
## ###########################################################
project.lonlat.to.M3 <- function(longitude, latitude, file,
                                      units, ...){

  ## Form projection string describing the projection in the given
  ## Models3-formatted file.
  proj.string <- get.proj.info.M3(file, ...)


  ## Return an error if the Models3-formatted file given is already
  ## referenced by long/lat.  If it is, then we don't need to project
  ## the given coordinates, since they're already on the long/lat system.
  if ( substring(proj.string, first=7, last=13)=="longlat" )
    stop(paste("No need to project, since file ", file,
               " is gridded on long/lat system.", sep=""))


  ## Project locations from longitude and latitude onto CMAQ units (by
  ## default, this is done in meters).
  coords.proj <- project(cbind(longitude, latitude), proj=proj.string)
  colnames(coords.proj) <- c("x", "y")


  ## ##########################
  ## If the user does not specify desired units, then use "km".  If
  ## user specifies an option other than "km" or "m", give message and
  ## exit function.

  if (missing(units)){
    coords.proj <- coords.proj/1000
    units <- "km"
    }
  else if (units=="km"){
    coords.proj <- coords.proj/1000
    units <- "km"
  }
  else if (units=="m")
    units <- "m"
  else
    stop(paste(units, " is not a valid option for 'units'.", sep=""))
  ## ##########################


  ## Return a list, with the coords in the first position and the
  ## units of those coords in the second.
  x <- list(coords=coords.proj, units=units)
  return(x)
}

## ###########################################################
## PURPOSE: Project coordinates based on projection in first
##   Models3-formatted file to the projection given in second
##   Models3-formatted file.
##
## INPUTS:
##   x: x-coordinates in model units from projection in from.file
##   y: y-coordinates in model units from projection in from.file
##   from.file: Name of Models3-formatted file with the model
##     projection underlying "x" and "y"
##   to.file: Name of Models3-formatted file with the model
##     projection to which you want "x" and "y" to be projected.
##   units: Units of "x" and "y".  The coordinates returned will also
##     be in these units.
##   ...: Other arguments to pass to get.proj.info.M3 function.
##     In this case, the only relevant argument would be the earth
##     radius to use when doing the projections.
##
## RETURNS: A list containing two elements "coords" and "units".  The
##   element "coords" contains a matrix of coordinates using projection
##   in to.file.  The element "units" contains the units of the
##   coordinates, which are the same as those specified for input "x"
##   and "y".
##
## ASSUMES:
##   1. Availability of R packages ncdf4 and rgdal.
##   2. Projections are lambert conic conformal or polar stereographic.
##
##
## REVISION HISTORY:
##   Original release: Jenise Swall, 2011-06-02
## ###########################################################
project.M3.1.to.M3.2 <- function(x, y, from.file, to.file, units, ...){

  ## Form projection string describing the projection in the given
  ## Models3-formatted file.
  from.proj.string <- get.proj.info.M3(from.file, ...)
  to.proj.string <- get.proj.info.M3(to.file, ...)



  ## ##########################
  ## If both files have the same projection, then we don't need to do any
  ## projections.  Exit, and tell user this.
  
  ## Return an error if both files are already on the same projection.
  if ( identical(from.proj.string, to.proj.string) )
    stop(paste("No need to project, since file ", from.file,
               " and file ", to.file, " use the same projection.", sep=""))
  ## ##########################



  ## ########################## 
  ## Take different course if one of the projections is long/lat.
  
  ## (1) If "from" projection is long/lat, then we need function
  ## project.lonlat.to.M3.  Warn user that this funciton is
  ## being called.
  if ( substring(from.proj.string, first=7, last=13)=="longlat" ){
    warning(paste('The specified "from" projection in file,', from.file, ' is longitude/latitude.  Using function project.lonlat.to.M3...', sep=""))
    return(project.lonlat.to.M3(longitude=x, latitude=y, file=to.file,
                                units=units, ...))
  }

  
  ## (2) If "to" projection is long/lat, then we need function
  ## project.M3.to.lonlat(). Warn user that this funciton is
  ## being called.
  if ( substring(to.proj.string, first=7, last=13)=="longlat" ){
    warning(paste('The specified "to" projection in file,', to.file, ' is longitude/latitude.  Using function project.M3.to.lonlat.', sep=""))
    return(project.M3.to.lonlat(x=x, y=y, file=from.file, units=units, ...))
  }

  
  ## (3) If neither project is long/lat, proceed with the remainder of
  ## this function.

  ## ##########
  ## Put the given coordinates into "Spatial Points" form for use
  ## with spTransform function.  Make sure we adjust properly for
  ## units (must be either "km" or "m".)
  
  if (missing(units))
    stop('User must specify units of "x" and "y".')
  else if (units=="km")
    from.coords <- data.frame(x=1000*x, y=1000*y)
  else if (units=="m")
    from.coords <- data.frame(x=x, y=y)
  else
    stop(paste(units, " is not a valid option for 'units'.", sep=""))
  ## ##########


  ## ##########
  ## Make into a SpatialPoints object.
  coordinates(from.coords) <- c("x", "y")
  proj4string(from.coords) <- CRS(from.proj.string)
  
  ## Project locations from CMAQ units to longitude and latitude.
  to.coords <- spTransform(from.coords, CRS(to.proj.string))
  
  ## Return the coordinates, adjusting units appropriately 
  if (units=="km")
    return(list(coords=coordinates(to.coords)/1000, units=units))
  else
    return(list(coords=coordinates(to.coords), units=units))
  ## ##########
  
  ## ##########################
}

## ###########################################################
## PURPOSE: Project coordinates from model units to longitude/latitude.
##
## INPUTS:
##   x: x-coordinates of points in model units from project in "file"
##   y: y-coordinates of points in model units from project in "file"
##   file: File name of Models3-formatted file which contains
##         information about the projection (used for "x" and "y").
##   units: Units which x and y are given in.  Options are kilomters ("km")
##     or meters ("m").  The value "deg" does not make sense here, because
##     we would not need to project coordinates from a long/lat reference
##     system to a long/lat reference system.
##   ...:  Other arguments to pass to get.proj.info.M3 function.
##     In this case, the only relevant argument would be the earth
##     radius to use for the projection in "file".
##
## RETURNS: A list containing the elements "coords" and "units".  The
##   element "coords" contains a matrix of coordinates in
##   longitude/latitude.  The element "units" contains the string "deg"
##   to designate that "coords" is in degrees of longitude/latitude.
##
## ASSUMES:
##   1. Availability of R packages ncdf4 and rgdal.
##   2. Projection is lambert conic conformal or polar stereographic. 
##
##
## REVISION HISTORY:
##   Original release: 2011-06-02
## ###########################################################
project.M3.to.lonlat <- function(x, y, file, units, ...){
  
  ## Form projection string describing the projection in the given
  ## Models3-formatted file.

  proj.string <- get.proj.info.M3(file, ...)


  ## Return an error if the Models3-formatted file given is already
  ## referenced by long/lat.  If it is, then we don't need to project
  ## the given coordinates, since they're already on the long/lat system.
  if ( substring(proj.string, first=7, last=13)=="longlat" )
    stop(paste("No need to project, since file ", file,
               " is gridded on long/lat system.", sep=""))

  
  ## ##########################
  ## To avoid errors, the user must specify the units x and y are in.
  ## This must be either "km" or "m".

  if (missing(units))
    stop('User must specify whether units are "km" or "m".')
  else if (units=="km")
    coords.lonlat <- project(1000*cbind(x, y), proj=proj.string, inv=TRUE)
  else if (units=="m")
    coords.lonlat <- project(cbind(x, y), proj=proj.string, inv=TRUE)
  else
    stop(paste(units, " is not a valid option.", sep=""))
  ## ##########################


  ## Name columns appropriately.
  colnames(coords.lonlat) <- c("longitude", "latitude")

  return(list(coords=coords.lonlat, units="deg"))
}

## ###########################################################
## PURPOSE: Subset the list resulting from a get.M3.var()
##   function call.
##
## INPUT:
##   var.info: list given by function get.M3.var().
##   llx, urx: Lower and upper x-coordinate bounds for the subsetted
##     grid in units appropriate to the model projection.  Defaults
##     are the current boundaries of the x range.
##   lly, ury: Lower and upper y-coordinate bounds for the subsetted
##     grid in units appropriate to the model projection.  Defaults
##     are the current boundaries of the y range.
##   ldatetime, udatetime: Starting and ending date-times (either Date
##     or POSIX class).  Defaults are the current boundaries of the
##     date-time range.
##   hz.strict: If TRUE (default), to be allowed in the subset,
##     the whole grid cell must fit within the bounds given by llx, urx,
##     lly, and ury.  If FALSE, grid cells will be included in the
##     subset if any portion of the grid cell's area falls within the
##     given bounds.
##
## RETURNS: Subsetted list, with appropriate elements altered to
##   reflect the subsetting that has taken place.
##
##
## NOTE: If the user wants to subset the variable by row, column,
##   layer, or time step number, this can be accomplished easily
##   using standard R methods for subsetting the array of variable
##   values.  This function was written to help the user who does not
##   know the row, column, or time step numbers, but who wants to subset
##   according to human-readable dates and times or according to
##   projection units.
##
##
## REVISION HISTORY:
##   Original release: Jenise Swall, 2011-05-20
## ###########################################################
var.subset <- function(var.info, llx, urx, lly, ury,
                       ldatetime, udatetime, hz.strict=TRUE){

  ## #############
  ## DEAL WITH COLUMNS FIRST.

  ## How many columns are there?
  num.columns <- length(var.info$x.cell.ctr)

  if (num.columns > 1){

    ## Want to find the left and right bounds (cell edges) for each
    ## column.  For this, we need the cell width.
    cell.width <- var.info$x.cell.ctr[2] - var.info$x.cell.ctr[1]
    lbd <- var.info$x.cell.ctr - (cell.width/2.0)
    ubd <- var.info$x.cell.ctr + (cell.width/2.0)
    rm(cell.width)

    ## If llx/urx is missing, set to preserve current boundaries.
    if (missing(llx))
      llx <- min(lbd)
    if (missing(urx))
      urx <- max(ubd)

    ## Check to make sure left limit is not greater than right limit.
    if (llx > urx)
      stop("Lower limit in the x direction is greater than upper limit.")

    ## If hz.strict=TRUE, find the columns for which both the
    ## left and right sides fit inside the specified x range. If
    ## hz.strict=FALSE, then only some portion of the column needs
    ## to fall within the bounds.
    if (hz.strict)
      which.columns <- which( (lbd >= llx) & (ubd <= urx) )
    else
      which.columns <- which( (ubd > llx) & (lbd < urx) )
  }

  else{
    which.columns <- 1
    if ( (!missing(llx)) || (!missing(urx)) )
      message("Only one column for this variable, llx and urx input ignored.")
  }
  ## #############


  ## #############
  ## DEAL WITH ROWS.

  ## How many rows are there?
  num.rows <- length(var.info$y.cell.ctr)

  if (num.rows > 1){

    ## Want to find the bottom and top bounds (cell edges) for each
    ## row.  For this, we need the cell width.
    cell.width <- var.info$y.cell.ctr[2] - var.info$y.cell.ctr[1]
    lbd <- var.info$y.cell.ctr - (cell.width/2.0)
    ubd <- var.info$y.cell.ctr + (cell.width/2.0)
    rm(cell.width)

    ## If lly/ury is missing, set to preserve current boundaries.
    if (missing(lly))
      lly <- min(lbd)
    if (missing(ury))
      ury <- max(ubd)

    ## Check to make sure left limit is not greater than right limit.
    if (lly > ury)
      stop("Lower limit in the y direction is greater than upper limit.")
    
    ## If hz.strict=TRUE, find the rows for which both the
    ## bottom and top sides fit inside the specified y range. If
    ## hz.strict=FALSE, then only some portion of the row needs
    ## to fall within the bounds.
    if (hz.strict)
      which.rows <- which( (lbd >= lly) & (ubd <= ury) )
    else
      which.rows <- which( (ubd > lly) & (lbd < ury) )
  }

  else{
    which.rows <- 1
    if ( (!missing(lly)) || (!missing(ury)) )
      message("Only one row for this variable, lly and ury input ignored.")
  }
  ## #############


  ## #############
  ## DEAL WITH DATE-TIMES.

  ## How many date-time steps are there?
  num.datetimes <- length(var.info$datetime)
  ## If this length is 0, then var.info$datetime is NULL.  This means
  ## that the file is time-independent, and we cannot subset the
  ## date-time steps.
  if (num.datetimes == 0)
    time.indep <- TRUE
  else
    time.indep <- FALSE


  if (num.datetimes > 1){

    ## If date-time limits are missing, set to preserve current boundaries.
    if (missing(ldatetime))
      ldatetime <- min(var.info$datetime)
    if (missing(udatetime))
      udatetime <- max(var.info$datetime)


    ## Check to see if the date-time limits are in Date format.  If so,
    ## make them into a POSIX format date.  For the lower limit, this
    ## would mean a time stamp at midnight (beginning of the given
    ## date).  For the upper limit, this would mean a time stamp at 23:59:59
    ## (last part of the given date).
    if ("Date" %in% class(ldatetime))
      ldatetime <- combine.date.and.time(date=ldatetime, time="00:00:00")
    if ("Date" %in% class(udatetime))
      udatetime <- combine.date.and.time(date=udatetime, time="23:59:59")


    ## Check to make sure upper limit is not less than lower limit.
    if (ldatetime > udatetime)
      stop("Lower date-time limit is greater than upper date-time limit.")


    ## Find the columns for which both the left and right sides fit
    ## inside the specified x range.
    which.datetimes <- which( (ldatetime <= var.info$datetime)
                             & (var.info$datetime <= udatetime) )
  }

  
  else if (!time.indep){
    which.datetimes <- 1
    if ( (!missing(ldatetime)) || (!missing(udatetime)) )
      message("Only one date-time step for this variable, ldatetime and udatetime input ignored.")
  }


  else{
    if ( (!missing(ldatetime)) || (!missing(udatetime)) )
      message("Variable is time-independent, ldatetime and udatetime input ignored.")
  }
  ## #############


  ## #############
  ## SUBSET THE VARIOUS ELEMENTS OF THE INPUT VARIABLE INFO LIST, AND
  ## RETURN THE SUBSETTED INFO.
  
  ## Subset the array first, recognizing that time-independent files
  ## cannot be subsetted on the basis of date-time.
  if (!time.indep){
    subset.data <- var.info$data[which.columns, which.rows, , which.datetimes]
    dim(subset.data) <- c(length(which.columns), length(which.rows), dim(var.info$data)[3], length(which.datetimes))
  }
  else{
    subset.data <- var.info$data[which.columns, which.rows, ]
    dim(subset.data) <- c(length(which.columns), length(which.rows), dim(var.info$data)[3])
  }


  ## Subset the x.cell.ctr and y.cell.ctr list elements.
  subset.x.cell.ctr <- var.info$x.cell.ctr[which.columns]
  subset.y.cell.ctr <- var.info$y.cell.ctr[which.rows]
  ## Subset the rows and columns list elements.
  subset.cols <- var.info$cols[which.columns]
  subset.rows <- var.info$rows[which.rows]
  ## If not time-independent, subset the datetime element.
  if (!time.indep)
    subset.datetime <- var.info$datetime[which.datetimes]

  
  ## Form the list for the subsetted variable info.
  if (!time.indep)
    subset.list <- list(data=subset.data, data.units=var.info$data.units,
                        x.cell.ctr=subset.x.cell.ctr,
                        y.cell.ctr=subset.y.cell.ctr,
                        hz.units=var.info$hz.units,
                        rows=subset.rows, cols=subset.cols,
                        layers=var.info$layers,
                        datetime=subset.datetime)
  else
    subset.list <- list(data=subset.data, data.units=var.info$data.units,
                        x.cell.ctr=subset.x.cell.ctr,
                        y.cell.ctr=subset.y.cell.ctr,
                        hz.units=var.info$hz.units,
                        rows=subset.rows, cols=subset.cols,
                        layers=var.info$layers)
  ## #############


  ## Return subsetted variable info to user.
  return(subset.list)
}
