#Temperature
#Convert the test start/end times to UTC https://savvytime.com/converter/ast-to-utc
  #Add 3 hrs to convert from ADT (dst true). Daylight savings (ADT) runs roughly from March 12- November 5.
  #Add 4 hrs to convert from AST (dst false). Roughly Nov 6-March 11.


#new method (tz)
assign_trim_start_temp <- function(Log){
  TEMPLog <- filter(Log, validation_variable == "Temp") %>%
    filter(row_number()==1)
  TEMPstarttime_utc <- as_datetime(TEMPLog$deployment_datetime, tz = "UTC")
}


assign_trim_end_temp <- function(Log){
  TEMPLog <- filter(Log, validation_variable == "Temp") %>%
    filter(row_number()==1)
  TEMPendtime_utc <- as_datetime(TEMPLog$retrieval_datetime, tz = "UTC")
}




#old method (manual)


# assign_trim_start_temp <- function(Log){
#   dst <- dst(Log[1,]$deployment_datetime)
#   ifelse(dst == TRUE,  adjusttime <- 3*60*60, adjusttime <- 4*60*60)
#   TempLog <- filter(Log, validation_variable == "Temp") %>% 
#       filter(row_number()==1)
#   Tempstarttime_utc <- TempLog$deployment_datetime + adjusttime
# }
# 
# 
# assign_trim_end_temp <- function(Log){
#   dst <- dst(Log[1,]$deployment_datetime)
#   ifelse(dst == TRUE,  adjusttime <- 3*60*60, adjusttime <- 4*60*60)
#   TempLog <- filter(Log, validation_variable == "Temp") %>% 
#     filter(row_number()==1)
#   Tempendtime_utc <- TempLog$retrieval_datetime + adjusttime
# }


# Tempstarttime_utc <- assign_trim_start_temp(Log)
# Tempendtime_utc <- assign_trim_end_temp(Log)
