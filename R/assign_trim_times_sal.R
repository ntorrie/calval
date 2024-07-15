#' Create variable for SAL test start time in UTC 
#'
#' @param log Metadata log with deployment_datetime column
#'
#' @return Returns sal_starttime_utc
#' 
#' @author Nicole Torrie
#' 
#' @importFrom dplyr filter %>% row_number
#' @importFrom lubridate as_datetime
#' 
#' @export
#'

#Salinity
#Convert the test start time to UTC 
assign_trim_start_sal <- function(log){
  sal_log <- filter(log, validation_variable == "SAL") %>%
    filter(row_number()==1)
  sal_starttime_utc <- as_datetime(sal_log$deployment_datetime, tz = "UTC")
}


#' Create variable for SAL test end time in UTC 
#'
#' @param log Metadata log with deployment_datetime column
#'
#' @return Returns sal_endtime_utc
#' 
#' @author Nicole Torrie
#' 
#' @importFrom dplyr filter %>% row_number
#' @importFrom lubridate as_datetime
#' 
#' @export
#'

#Salinity
#Convert the test end time to UTC 
assign_trim_end_sal <- function(log){
  sal_log <- filter(log, validation_variable == "SAL") %>%
    filter(row_number()==1)
  sal_endtime_utc <- as_datetime(sal_log$retrieval_datetime, tz = "UTC")
}

