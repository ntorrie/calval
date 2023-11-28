#Salinity
#Convert the test start/end times to UTC https://savvytime.com/converter/ast-to-utc
#Add 3 hrs to convert from ADT (dst true). Daylight savings (ADT) runs roughly from March 12- November 5.
#Add 4 hrs to convert from AST (dst false)


#new method (tz)
assign_trim_start_sal <- function(Log){
  SALLog <- filter(Log, validation_variable == "SAL") %>%
    filter(row_number()==1)
  SALstarttime_utc <- as_datetime(SALLog$deployment_datetime, tz = "UTC")
}


assign_trim_end_sal <- function(Log){
  SALLog <- filter(Log, validation_variable == "SAL") %>%
    filter(row_number()==1)
  SALendtime_utc <- as_datetime(SALLog$retrieval_datetime, tz = "UTC")
}




#old method (manual)

# assign_trim_start_sal <- function(Log){
#   dst <- dst(Log[1,]$deployment_datetime)
#   ifelse(dst == TRUE,  adjusttime <- 3*60*60, adjusttime <- 4*60*60)
#   SALLog <- filter(Log, validation_variable == "SAL") %>% 
#     filter(row_number()==1)
#   SALstarttime_utc <- SALLog$deployment_datetime + adjusttime
# }
# 
# 
# assign_trim_end_sal <- function(Log){
#   dst <- dst(Log[1,]$deployment_datetime)
#   ifelse(dst == TRUE,  adjusttime <- 3*60*60, adjusttime <- 4*60*60)
#   SALLog <- filter(Log, validation_variable == "SAL") %>% 
#     filter(row_number()==1)
#   SALendtime_utc <- SALLog$retrieval_datetime + adjusttime
# }


# SALstarttime_utc <- assign_trim_start_sal(Log)
# SALendtime_utc <- assign_trim_end_sal(Log)
