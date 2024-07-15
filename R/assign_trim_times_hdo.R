#' Create variable for Hobo DO test start time in UTC 
#'
#' @param log Metadata log with deployment_datetime column
#'
#' @return Returns hdo_starttime_utc
#' 
#' @author Nicole Torrie
#' 
#' @importFrom dplyr filter %>% row_number
#' @importFrom lubridate as_datetime
#' 
#' @export
#'


#Hobo DO
#Convert the test start time to UTC 
assign_trim_start_hdo <- function(log){
  hdo_log <- filter(log, validation_variable == "DO", Logger_Model == "HOBO DO") %>%
    filter(row_number()==1)
  hdo_starttime_utc <- as_datetime(hdo_log$deployment_datetime, tz = "UTC")
}


#' Create variable for HOBO DO test end time in UTC
#'
#' @param Log Metadata log with deployment_datetime column
#'
#' @return Returns hdo_endtime_utc
#' 
#' @author Nicole Torrie
#' 
#' @importFrom dplyr filter %>% row_number
#' @importFrom lubridate as_datetime
#' 
#' @export
#'


#Hobo DO
#Convert the test end time to UTC 
assign_trim_end_hdo <- function(log){
  hdo_log <- filter(log, validation_variable == "DO", Logger_Model == "HOBO DO") %>%
    filter(row_number()==1)
  hdo_endtime_utc <- as_datetime(hdo_log$retrieval_datetime, tz = "UTC")
}

