

#' Title
#'
#' @param Log 
#'
#' @return
#' @export
#'
#' @examples

#Dissolved Oxygen
#Convert the test start/end times to UTC https://savvytime.com/converter/ast-to-utc
#Add 3 hrs to convert from ADT (dst true). Daylight savings (ADT) runs roughly from March 12- November 5.
#Add 4 hrs to convert from AST (dst false)

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