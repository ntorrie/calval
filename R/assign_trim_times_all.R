#' Create table of test start and end times for each variable
#'
#' @param var_list list of variables present in the dataset
#' 
#' @param log Metadata log with deployment_datetime and retrieval_datetime columns
#'
#' @return a data frame of all test start and end times in utc
#' 
#' @author Nicole Torrie
#' 
#' @export 
#'
#' 
#' 
#' 

#to assign trim times for all variables at once
assign_trim_times_all <- function(var_list, log){
  
  if("Temp" %in% var_list){
    temp_starttime_utc <- assign_trim_start_temp(log)
    temp_endtime_utc <- assign_trim_end_temp(log)
  } else {
    temp_starttime_utc <- NA
    temp_endtime_utc <- NA
  }
  
  if("HDO" %in% var_list){
    hdo_starttime_utc <- assign_trim_start_hdo(log)
    hdo_endtime_utc <- assign_trim_end_hdo(log)
  } else{
    hdo_starttime_utc <- NA
    hdo_endtime_utc <- NA
  }
  
  if("DO" %in% var_list){
    do_starttime_utc <- assign_trim_start_do(log)
    do_endtime_utc <- assign_trim_end_do(log)
  } else{
    do_starttime_utc <- NA
    do_endtime_utc <- NA
  }
  
  if("SAL" %in% var_list){
    sal_starttime_utc <- assign_trim_start_sal(log)
    sal_endtime_utc <- assign_trim_end_sal(log)
  } else{
    sal_starttime_utc <- NA
    sal_endtime_utc <- NA
  }
  
  trimtime_list <-
    list(
      TimeVariable = c(
        'temp_starttime_utc',
        'temp_endtime_utc',
        'hdo_starttime_utc',
        'hdo_endtime_utc',
        'do_starttime_utc',
        'do_endtime_utc',
        'sal_starttime_utc',
        'sal_endtime_utc'
      ),
      DateTime = c(
        temp_starttime_utc,
        temp_endtime_utc,
        hdo_starttime_utc,
        hdo_endtime_utc,
        do_starttime_utc,
        do_endtime_utc,
        sal_starttime_utc,
        sal_endtime_utc
      )
    ) 
    
  
  trimtime_table <- data.frame(trimtime_list) 
  
  print(trimtime_table)
  
}






