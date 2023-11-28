
#Function to set the deployment and retrieval dates for each sensor to match
# Deployment is the earliest deployment date of all sensors in the validation event
# Retrieval is the latest retrieval data of all sensors in the validation event

unify_log_dates <- function(Log = Log) {
  Log %>%
    mutate(Deployment = min(Deployment)) %>%
    mutate(Retrieval = max(Retrieval)) 
}


