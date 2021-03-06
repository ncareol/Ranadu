#' @title TellAbout
#' @description Utility to show characteristics of a variable
#' @details Prints the variable type, dimensions, and summary.
#' @aliases tellAbout
#' @author William Cooper
#' @importFrom stats sd
#' @export TellAbout
#' @param V A variable that may be scalar, vector, data.frame
#' @return The summary, which is also printed by the function.
#' @examples 
#' TellAbout (RAFdata$TASX)
#' TellAbout (RAFdata)

TellAbout <- function (V) {
  print(c(sprintf("Variable class is %s, length = %d, dim = ", class(V), length(V)), dim(V)))
  if (is.vector(V)) {
    print(sprintf("Variable rms = %g", sd(V, na.rm=TRUE))) 
  }  
  print (summary(V))
}

#' @title ValueOf
#' @description Returns value of a variable at a specified time
#' @details In a dataframe, finds the index corresponding to
#' the specified time and returns the value of the specified
#' variable at that index.
#' @aliases valueOf
#' @author William Cooper
#' @export ValueOf
#' @param DataFrame A dataframe containing 'Variable' and also 'Time',
#' a POSIX-format time variable used for searching for the desired time.
#' @param Variable A variable in DataFrame. The variable can be in the 
#' form DataFrame$TASX or TASX, or "TASX".
#' @param HHMMSS A time in hour-minute-second format (e.g., 134513) 
#' @return A numeric containing the value of 'Variable' at the specified time.
#' @examples 
#' ValueOf (RAFdata, ATX, 201100)
#' ValueOf (RAFdata, "ATX", 201100)
#' ValueOf (RAFdata, RAFdata$ATX, 201100)

ValueOf <- function(DataFrame, Variable, HHMMSS) {
  ix <- getIndex (DataFrame, HHMMSS)
  Variable <- eval (substitute (Variable), DataFrame, parent.frame())
  if (is.character (Variable)) {
    rv <- DataFrame[ix, Variable]
  } else {
    rv <- Variable[ix]
  }
  return (rv)
}

#' @title ValueOfAll
#' @description See/Get values of dataframe variables at specified time. 
#' @details Returns and prints values of all variables in a specified
#' dataframe that includes Time, at the time specified.
#' @aliases valueOfAll, valueofall
#' @author William Cooper
#' @export ValueOfAll
#' @param DataFrame The specified dataframe, which must contain Time as
#' a POSIXgt variable.
#' @param HHMMSS The time, in hour-minute-second format (e.g., 140321) 
#' at which to report the variables in the dataframe.
#' @return A vector containing all the variables at the specified
#' time. These values are also printed.
#' @examples 
#' vlist <- ValueOfAll (RAFdata, 201100)

ValueOfAll <- function (DataFrame, HHMMSS) {
  print (DataFrame[getIndex(DataFrame$Time, HHMMSS), ])
  return (DataFrame[getIndex(DataFrame$Time, HHMMSS), ])
}

#' @title getAttributes
#' @description List the netCDF attributes for a specified variable or data.frame
#' @details Prints the netCDF attributes and their values, and returns
#' a text vector with the names of the attributes, for a specified
#' data.frame. For variable attributes, the name of the variable should be
#' specified as a string. For global attributes, omit the 'vname' parameter.
#' This function is designed to work with data.frames generated by Ranadu::getNetCDF.R,
#' and for such data.frames it will list attributes as in the original netCDF file from
#' which the data.frame was generated.
#' @aliases GetAttributes,getattributes
#' @author William Cooper
#' @export getAttributes
#' @param dname The name of the data.frame. Alternately, a data.frame column.
#' @param vname The name of a variable in the netCDF file. If provided, this can be
#' either a column name in 'dname' (e.g., "TASX") or the variable itself (e.g., TASX).
#' If omitted, the attributes of the first parameter (the data.frame) will be returned.
#' @param .print A logical variable indicating if the values should be printed. 
#' Default is TRUE. The format of this listing is more concise than that obtained
#' by printing the returned list of attributes, so when used interactively it may
#' be preferable to use .print=TRUE and assign the returned list to avoid printing
#' it a second time; e.g., Z <- getAttributes(RAFdata, TASX)
#' @return A list of the attributes and associated values
#' @examples 
#' ATT <- getAttributes (RAFdata, TASX)
#' ATT <- getAttributes (RAFdata)
#' ATT <- getAttributes (RAFdata, "TASX", .print=FALSE)

getAttributes <- function (dname, vname=NULL, .print=TRUE) {
  atts <- list()
  if (!is.data.frame (dname)) {
    if (!is.atomic(dname) && !is.vector(dname)) {
      print (sprintf ("invalid variable, dname=variable call; returning"))
      return (NA)
    }
    ATT <- attributes (dname)
    if (.print) {
      print (sprintf ("attributes for variable"))
    }
    for (i in 1:length(ATT)) {
      if (names(ATT[i]) == "Dimensions") {next}
      if (names(ATT[i]) == "dim") {next}
      atts[[length(atts)+1]]  <- ATT[i]
      if (.print) {
        print (sprintf ("%s: %s", names(ATT[i]), ATT[i]))
      }
    }
    return (atts)
  }
  ## avoid having is.null fail for variable argument rather than text (vname)
  if (typeof (substitute (vname)) == "symbol") {
    vname <- deparse (substitute (vname))
  }
  if (is.null(vname)) {
    ATT <- attributes (dname)
    if (.print) {
      print ("attributes of data.frame:")
    }
    for (i in 1:length(ATT)) {
      if (names(ATT[i]) == "row.names") {next}
      if (names(ATT[i]) == "names") {next}
      if (names(ATT[i]) == "Dimensions") {next}
      if (names(ATT[i]) == "class") {next}
      atts[[length(atts)+1]]  <- ATT[i]
      if (.print) {
        print (sprintf ("%s: %s", names(ATT[i]), ATT[i]))
      }
    }
    return (atts)
  } else {    # variable attributes
    vname <- substitute (vname)
    if (typeof (vname) != "character") {
      vname <- deparse (substitute (vname))
    }
    ATT <- attributes (eval(parse(text=sprintf("dname$%s", vname))))
    if (.print) {
      print (sprintf ("attributes for variable %s", vname))
    }
    for (i in 1:length(ATT)) {
      if (names (ATT[i]) == "Dimensions") {next}
      if (names (ATT[i]) == "dim") {next}
      if (names (ATT[i]) == "class") {next}
      atts[[length(atts)+1]]  <- ATT[i]
      if (.print) {
        print (sprintf ("%s: %s", names(ATT[i]), ATT[i]))
      }
    }
    return (atts)
  }
}
  
