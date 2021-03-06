% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/MachNumber.R
\name{MachNumber}
\alias{MachNumber}
\alias{machnumber}
\title{MachNumber}
\usage{
MachNumber(P, Q, E = 0)
}
\arguments{
\item{P}{A numeric (optionally vector) giving the ambient pressure in hPa}

\item{Q}{A numeric (optionally vector) giving the dynamic pressure in hPa}

\item{E}{A numeric (optionally vector) giving the water vapor pressure in hPa}
}
\value{
A numeric (possible vector) giving the MACH Number
}
\description{
Calculates the Mach number
}
\details{
returns the Mach number calculated from ambient and dynamic pressure and, 
optionally, corrected for water vapor pressure
}
\examples{
MACH <- MachNumber(500., 50.)
MACH <- MachNumber(700., 60., 1.1)
MACH <- MachNumber (RAFdata$PSXC, RAFdata$QCXC, RAFdata$EWX)

}
\author{
William Cooper
}
