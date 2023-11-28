#clean_log_all to run #unify log dates and remove duplicate log items & create a log which sensorstrings can import


clean_log_all <- function(Log = Log) {
  Log <- unify_log_dates(Log)
  cleaned_log <- clean_log_duplicates(Log) 
}


