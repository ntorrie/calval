% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/assign_trim_times_all.R
\name{assign_trim_times_all}
\alias{assign_trim_times_all}
\title{Create table of test start and end times for each variable}
\usage{
assign_trim_times_all(Temp = TRUE, DO = TRUE, HDO = FALSE, SAL = FALSE)
}
\arguments{
\item{Temp}{TRUE if Temperature data is present in the dataset}

\item{DO}{TRUE if Dissolved Oxygen percent saturation data is present in the dataset}

\item{HDO}{TRUE if Hobo DO mg/l Dissolved Oxygen data is present in the dataset}

\item{SAL}{TRUE if Salinity data is present in the dataset}
}
\value{
a data frame of all test start and end times in utc
}
\description{
Create table of test start and end times for each variable
}
\author{
Nicole Torrie
}
