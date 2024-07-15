#' Create variable for TEMP test start time in UTC 
#'
#' @param log Metadata log with deployment_datetime column
#'
#' @return Returns temp_starttime_utc
#' 
#' @author Nicole Torrie
#' 
#' @importFrom dplyr filter %>% row_number
#' @importFrom lubridate as_datetime
#' 
#' @export
#'


#Temperature
#Convert the test start time to UTC 
assign_trim_start_temp <- function(log){
  temp_log <- filter(log, validation_variable == "Temp") %>%
    filter(row_number()==1)
  temp_starttime_utc <- as_datetime(temp_log$deployment_datetime, tz = "UTC")
}


#' Create variable for TEMP test end time in UTC
#'
#' @param log Metadata log with deployment_datetime column
#'
#' @return Returns temp_endtime_utc
#' 
#' @author Nicole Torrie
#' 
#' @importFrom dplyr filter %>% row_number
#' @importFrom lubridate as_datetime
#' 
#' @export
#'

#Temperature
#Convert the test end time to UTC 
assign_trim_end_temp <- function(log){
  temp_log <- filter(log, validation_variable == "Temp") %>%
    filter(row_number()==1)
  temp_endtime_utc <- as_datetime(temp_log$retrieval_datetime, tz = "UTC")
}

