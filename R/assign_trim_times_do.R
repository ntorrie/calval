#' Create variable for DO test start time in UTC 
#'
#' @param log Metadata log with deployment_datetime column
#'
#' @return Returns DOstarttime_utc
#' 
#' @author Nicole Torrie
#' 
#' @importFrom dplyr filter %>% row_number
#' @importFrom lubridate as_datetime
#' 
#' @export
#'


#Dissolved Oxygen
#Convert the test start/end times to UTC 
#Add 3 hrs to convert from ADT (dst true). Daylight savings (ADT) runs roughly from March 12- November 5.
#Add 4 hrs to convert from AST (dst false)

assign_trim_start_do <- function(log){
  dolog <- filter(log, validation_variable == "DO", Logger_Model == "aquaMeasure DOT") %>%
    filter(row_number() == 1)
  DOstarttime_utc <- as_datetime(dolog$deployment_datetime, tz = "UTC")
}


#' Create variable for DO test end time in UTC
#'
#' @param log Metadata log with deployment_datetime column
#'
#' @return Returns DOendtime_utc
#' 
#' @author Nicole Torrie
#' 
#' @importFrom dplyr filter %>% row_number
#' @importFrom lubridate as_datetime
#' 
#' @export
#'


assign_trim_end_do <- function(log){
  dolog <- filter(log, validation_variable == "DO", Logger_Model == "aquaMeasure DOT") %>%
    filter(row_number() == 1)
  DOendtime_utc <- as_datetime(dolog$retrieval_datetime, tz = "UTC")
}