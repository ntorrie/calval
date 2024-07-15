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
    TEMPstarttime_utc <- assign_trim_start_temp(log)
    TEMPendtime_utc <- assign_trim_end_temp(log)
  } else {
    TEMPstarttime_utc <- NA
    TEMPendtime_utc <- NA
  }
  
  if("HDO" %in% var_list){
    HDOstarttime_utc <- assign_trim_start_hdo(log)
    HDOendtime_utc <- assign_trim_end_hdo(log)
  } else{
    HDOstarttime_utc <- NA
    HDOendtime_utc <- NA
  }
  
  if("DO" %in% var_list){
    DOstarttime_utc <- assign_trim_start_do(log)
    DOendtime_utc <- assign_trim_end_do(log)
  } else{
    DOstarttime_utc <- NA
    DOendtime_utc <- NA
  }
  
  if("SAL" %in% var_list){
    SALstarttime_utc <- assign_trim_start_sal(log)
    SALendtime_utc <- assign_trim_end_sal(log)
  } else{
    SALstarttime_utc <- NA
    SALendtime_utc <- NA
  }
  
  trimtime_list <-
    list(
      TimeVariable = c(
        'TEMPstarttime_utc',
        'TEMPendtime_utc',
        'HDOstarttime_utc',
        'HDOendtime_utc',
        'DOstarttime_utc',
        'DOendtime_utc',
        'SALstarttime_utc',
        'SALendtime_utc'
      ),
      DateTime = c(
        TEMPstarttime_utc,
        TEMPendtime_utc,
        HDOstarttime_utc,
        HDOendtime_utc,
        DOstarttime_utc,
        DOendtime_utc,
        SALstarttime_utc,
        SALendtime_utc
      )
    ) 
    
  
  trimtime_table <- data.frame(trimtime_list) 
  
  print(trimtime_table)
  
}






