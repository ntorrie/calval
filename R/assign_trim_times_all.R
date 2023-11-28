#to assign trim times for all variables at once

assign_trim_times_all <- function(Temp = TRUE,
                                  DO = TRUE,
                                  SAL = FALSE){
  
  if(Temp == TRUE){
    TEMPstarttime_utc <- assign_trim_start_temp(Log)
    TEMPendtime_utc <- assign_trim_end_temp(Log)
  }
  
  if(DO == TRUE){
    DOstarttime_utc <- assign_trim_start_do(Log)
    DOendtime_utc <- assign_trim_end_do(Log)
  }
  
  if(SAL == TRUE){
    SALstarttime_utc <- assign_trim_start_sal(Log)
    SALendtime_utc <- assign_trim_end_sal(Log)
  }
  
  trimtime_list <-
    list(
      TimeVariable = c(
        'TEMPstarttime_utc',
        'TEMPendtime_utc',
        'DOstarttime_utc',
        'DOendtime_utc',
        'SALstarttime_utc',
        'SALendtime_utc'
      ),
      DateTime = c(
        TEMPstarttime_utc,
        TEMPendtime_utc,
        DOstarttime_utc,
        DOendtime_utc,
        SALstarttime_utc,
        SALendtime_utc
      )
    ) 
    
  
  trimtime_table <- data.frame(trimtime_list) 
  
  print(trimtime_table)
  
}






