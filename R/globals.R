# Need this so that package will play nice with dplyr package
# https://community.rstudio.com/t/how-to-solve-no-visible-binding-for-global-variable-note/28887
# more technical solution here: https://cran.r-project.org/web/packages/dplyr/vignettes/programming.html

# other technical solution here:
# https://dplyr.tidyverse.org/articles/programming.html


utils::globalVariables(c(
  #assign trim times DO
  "validation_variable",
  
  #assign trim times HDO
  "Logger_Model",
  
  #assign trim times all
  "Log",
  
  #clean log duplicates
  "Serial#",
  "Serial.",
  "Lease.",
  
  #create val log
  "validation event id",
  "validation start date",
  "validation start time (AST)",
  "validation end date",
  "validation end time (AST)",
  "sensor model",
  "serial number",
  "firmware version",
  "name of calibration attendant",
  "calibration date",
  "calibration room temperature (C)",
  "calibration water temperature (C)",
  "calibration pressure (kPa)",
  "validation variable",
  "name of validation attendant",
  "validation room temperature (C) at start",
  "validation pressure (kPa) at start",
  "validation room temperature (C) at end",
  "validation pressure (kPa) at end",
  "validation status (CMAR USE)",
  "percent bad temp readings",
  "percent bad do readings",
  "percent bad sal readings",
  "Deployment",
  "validation_start_time",
  "Retrieval",
  "validation_end_time",
  
  #ggplot functions
  "timestamp_utc",
  "dissolved_oxygen_percent_saturation",
  "FLAG",
  "threshold",
  "sensor_serial_number",
  "dissolved_oxygen_uncorrected_mg_per_l",
  "median",
  "salinity_psu",
  "temperature_degree_c",
  

  ))







