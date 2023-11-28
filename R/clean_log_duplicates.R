#clean_log_duplicates
#separate duplicate rows from multi variable sensors in LOG

clean_log_duplicates <- function(Log) {
  cleaned_log <-
    data.frame(distinct(Log, `Serial#`, .keep_all = TRUE)) %>%
    rename("Serial#" = `Serial.`,
           "Lease#" = `Lease.`)
}


#Log2 <- clean_log_duplicates(Log)
