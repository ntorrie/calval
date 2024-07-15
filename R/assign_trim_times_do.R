#' Create variable for DO test start time in UTC 
#'
#' @param log Metadata log with deployment_datetime column
#'
#' @return Returns do_starttime_utc
#' 
#' @author Nicole Torrie
#' 
#' @importFrom dplyr filter %>% row_number
#' @importFrom lubridate as_datetime
#' 
#' @export
#'


#Dissolved Oxygen
#Convert the test start time to UTC 
assign_trim_start_do <- function(log){
  dolog <- filter(log, validation_variable == "DO", Logger_Model == "aquaMeasure DOT") %>%
    filter(row_number() == 1)
  do_starttime_utc <- as_datetime(dolog$deployment_datetime, tz = "UTC")
}


#' Create variable for DO test end time in UTC
#'
#' @param log Metadata log with deployment_datetime column
#'
#' @return Returns do_endtime_utc
#' 
#' @author Nicole Torrie
#' 
#' @importFrom dplyr filter %>% row_number
#' @importFrom lubridate as_datetime
#' 
#' @export
#'

#Dissolved Oxygen
#Convert the test end time to UTC 
assign_trim_end_do <- function(log){
  dolog <- filter(log, validation_variable == "DO", Logger_Model == "aquaMeasure DOT") %>%
    filter(row_number() == 1)
  do_endtime_utc <- as_datetime(dolog$retrieval_datetime, tz = "UTC")
}