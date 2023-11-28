#' Create variable for DO test start time in UTC 
#'
#' @param Log 
#'
#' @return Returns DOstarttime_utc
#' 
#' @importFrom dplyr filter
#' @importFrom lubridate as_datetime
#' 
#' @export
#'


#Dissolved Oxygen
#Convert the test start/end times to UTC 
#Add 3 hrs to convert from ADT (dst true). Daylight savings (ADT) runs roughly from March 12- November 5.
#Add 4 hrs to convert from AST (dst false)

assign_trim_start_do <- function(Log){
  DOLog <- filter(Log, validation_variable == "DO") %>%
    filter(row_number()==1)
  DOstarttime_utc <- as_datetime(DOLog$deployment_datetime, tz = "UTC")
}


#' Create variable for DO test end time in UTC
#'
#' @param Log 
#'
#' @return Returns DOendtime_utc
#' 
#' @importFrom dplyr filter
#' @importFrom lubridate as_datetime
#' 
#' @export
#'


assign_trim_end_do <- function(Log){
  DOLog <- filter(Log, validation_variable == "DO") %>%
    filter(row_number()==1)
  DOendtime_utc <- as_datetime(DOLog$retrieval_datetime, tz = "UTC")
}