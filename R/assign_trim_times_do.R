#Dissolved Oxygen
#Convert the test start/end times to UTC https://savvytime.com/converter/ast-to-utc
#Add 3 hrs to convert from ADT (dst true). Daylight savings (ADT) runs roughly from March 12- November 5.
#Add 4 hrs to convert from AST (dst false)

#new method (tz)
assign_trim_start_do <- function(Log){
  DOLog <- filter(Log, validation_variable == "DO") %>%
    filter(row_number()==1)
  DOstarttime_utc <- as_datetime(DOLog$deployment_datetime, tz = "UTC")
}


assign_trim_end_do <- function(Log){
  DOLog <- filter(Log, validation_variable == "DO") %>%
    filter(row_number()==1)
  DOendtime_utc <- as_datetime(DOLog$retrieval_datetime, tz = "UTC")
}

#old method (manual)
# assign_trim_start_do <- function(Log){
#   dst <- dst(Log[1,]$deployment_datetime)
#   ifelse(dst == TRUE,  adjusttime <- 3*60*60, adjusttime <- 4*60*60)
#   DOLog <- filter(Log, validation_variable == "DO") %>% 
#     filter(row_number()==1)
#   DOstarttime_utc <- DOLog$deployment_datetime + adjusttime
# }
# 
# 
# 
# 
# assign_trim_end_do <- function(Log){
#   dst <- dst(Log[1,]$deployment_datetime)
#   ifelse(dst == TRUE,  adjusttime <- 3*60*60, adjusttime <- 4*60*60)
#   DOLog <- filter(Log, validation_variable == "DO") %>% 
#     filter(row_number()==1)
#   DOendtime_utc <- DOLog$retrieval_datetime + adjusttime
# }

# 
# DOstarttime_utc <- assign_trim_start_do(Log)
# DOendtime_utc <- assign_trim_end_do(Log)

# x <- ymd("2023-5-31")
# dst(x)
# y <- ymd("2023-11-23")
# dst(y)
