# DATE: 
# NAME: 
# NOTES: 
# calval version: 

# Code to visualize pre and post deployment validation data
# SET UP -----------------------------------------------------------------------
# Create an empty folder called "Log" on the path
# Hobo data must be extracted and placed in a folder on the path called "hobo"
# aquaMeasure data must be extracted and placed in a folder on the path called "aquameasure"
# Vemco data must be extracted and placed in a folder on the path called "vemco"

# Install the most recent calval package version
#library(devtools)
install_github("ntorrie/calval", force = TRUE, dependencies = TRUE)
library(miceadds) #or source all functions
source.all("C:/Users/Nicole Torrie/Documents/R/packages/calval/R")

# Load libraries
library(calval)
library(dplyr)
library(sensorstrings)
library(lubridate)
library(data.table)

# Set the validation ID
VALID <- "VAL0045"

# Set the path to the folder with validation data
path <-
  file.path(paste0(
      "R:/data_branches/water_quality/validation/validation_data/",
      VALID,"_Data"))


## CONSTRUCT METADATA LOG AND DEFINE VARIABLES----------------------------------
# Allow access to the Calibration/Validation Tracking Google sheet
googlesheets4::gs4_deauth()
sheet = ifelse(str_detect(VALID, "^POST"),
               "Post Deployment Validation",
               "Pre Deployment CalVal")
link <-"https://docs.google.com/spreadsheets/d/1u1beyNL02NQvMblhkpGX9tazRqlhfZaJbzifvOKNP54/edit#gid=0"

# Create metadata log from Tracking Google sheet
tracking <- googlesheets4::read_sheet(link, sheet = sheet, col_types = "c") %>%
  filter(`validation event id` == VALID)

log <- create_val_log(tracking) 

# Get a list of variables measured in this validation event
val_var_list <-
  tracking %>%
  # Get the sensor models and modify HOBO DO variable into HDO
  distinct(`sensor model`, `validation variable`) %>%
  mutate(`validation variable` = case_when(`sensor model` == "HOBO DO" ~ "HDO",
         .default = `validation variable`)) %>%
  # Get only validation variables
  distinct(`validation variable`) %>%
  pull(`validation variable`)

# Create table of test start/end times for each variable
trimtime_table <- assign_trim_times_all(var_list = val_var_list,
                                        log = log)
# Could probably put this line into assign_trim_times_all()
trimtime_table <- pivot_wider(trimtime_table,
                              names_from = TimeVariable,
                              values_from = DateTime)

# Apply final Log edits for data processing
# TODO: should this be part of the create_val_log function?
cleaned_log <- clean_log_all(log)

# Write log to shared drive folder
fwrite(
  cleaned_log,
  file = paste0(path, "/", "Log", "/", VALID, "Log.csv"),
  na = "NA",
  showProgress = TRUE,
  col.names = TRUE
)


## READ IN LOG AND DATA --------------------------------------------------------
raw_val_data <- ss_compile_deployment_data(path)

# General visualization of all test data together
ss_ggplot_variables(raw_val_data)


# FLAGGING TEMP DATA -----------------------------------------------------------
# TODO: Figure out a more eloquent way to select the temp start/end times
#         from the trimtime_table. Reduce code. 
#       Create function to standardize the sampling interval based on user input
#         of sensor types and interval to set to

# Manually adjust temp start or end time after viewing data if necessary
# TEMPstarttime_utc <- as_datetime("2024-05-13 14:00:00", tz = "UTC")
# TEMPendtime_utc <- as_datetime("2023-11-16 13:40:00", tz = "UTC")

# Filter for just temp variable and temp test time range
temp_data <- filter(raw_val_data, `temperature_degree_c` != "NA") %>%
  filter(timestamp_utc > trimtime_table$TEMPstarttime_utc &
           timestamp_utc < trimtime_table$TEMPendtime_utc)

# Create new column rounding timestamps to nearest 15 minutes and calculate 
#   median value for each time grouping. Then populate the flag column
# TODO: Can any of this code be more "behind the scenes" to reduce script?
#       Maybe a function so you can still set the rounding interval and accuracy?
temp_data <- temp_data %>%
  mutate(rounddate = round_date(timestamp_utc, unit = "15 minutes"))

medians <- temp_data %>%
  group_by(rounddate) %>%
  summarise_at(vars(temperature_degree_c), list(median = median))

final_temp <-
  merge(temp_data, medians, by = "rounddate", all.x = TRUE) %>%
  mutate(accuracy = if_else(sensor_type == "vr2ar", 0.5, 0.2)) %>%
  mutate(
    FLAG = case_when(
      temperature_degree_c > median + accuracy |
        temperature_degree_c < median - accuracy ~ 1,
      TRUE ~ as.numeric(0)
    )
  )

# Plot final_temp colorized by flag (0 = pass)
r <- ggplot_temp_flag(final_temp, point_size = 1.5)
r

# Plot final_temp colorized by sensor
s <- ggplot_temp_val(final_temp, point_size = 1.5)
s

# Calculate what percent of the time each sensor is outside an "acceptable" range
percent_time_temp_out_of_range <- final_temp %>%
  group_by(sensor_serial_number) %>%
  summarise('Percent Bad T' = (sum(FLAG)) / (count = n())*100)
print(percent_time_temp_out_of_range)


# FLAGGING DO PERCENT SATURATION DATA ------------------------------------------
# TODO: Figure out a more eloquent way to select the start/end times
#         from the trimtime_table. Reduce code. 

# Manually adjust aquaMeasure DO start or end time after viewing data if necessary
# DOstarttime_utc <- as_datetime("2023-11-16 13:40:00", tz = "UTC")
# DOendtime_utc <- as_datetime("2023-11-16 13:40:00", tz = "UTC")

# Filter for just the DO % saturation variable and aquaMeasure DO test time range
do_data <- filter(VALraw, `dissolved_oxygen_percent_saturation` != "NA") %>%
      filter(timestamp_utc > trimtime_table$DOstarttime_utc &
             timestamp_utc < trimtime_table$DOendtime_utc)
           
# Create and populate the flag column 
# DO data should read 100% during DO bucket saturation test, +/- 5% error
# TODO: Can any of this code be more "behind the scenes" to reduce script?
#       Maybe a function so you can still set the threshold and accuracy?
threshold <- 100 

final_do <- do_data %>%
  mutate(
    FLAG = case_when(
      dissolved_oxygen_percent_saturation > threshold + 5 |
        dissolved_oxygen_percent_saturation < threshold - 5 ~ 1,
      TRUE ~ as.numeric(0)
    )
  )

# Plot final_DO colorized by flag (0 = pass)
q <- ggplot_do_flag(final_do, point_size = 0.75)
q

# Plot final_DO colorized by sensor
p <- ggplot_do_val(final_do, point_size = 0.6)
p

# Calculate what percent of the time each sensor is outside an "acceptable" range
percent_time_do_out_of_range <- final_do %>%
  group_by(sensor_serial_number) %>%
  summarise('Percent Bad DO' = (sum(FLAG)) / (count = n()) * 100)
print(percent_time_do_out_of_range)


# FLAGGING DO CONCENTRATION DATA------------------------------------------------
# TODO: Figure out a more eloquent way to select the start/end times
#         from the trimtime_table. Reduce code. 

# Manually adjust Hobo DO start or end time after viewing data if necessary
# HDOstarttime_utc <- as_datetime("2023-11-16 13:40:00", tz = "UTC")
# HDOendtime_utc <- as_datetime("2023-11-16 13:40:00", tz = "UTC")

# Filter for just dissolved oxygen mg/l variable and test time range
hobo_do_data <-
  filter(raw_val_data, `dissolved_oxygen_uncorrected_mg_per_l` != "NA") %>%
  filter(
    timestamp_utc > trimtime_table$HDOstarttime_utc &
      timestamp_utc < trimtimetable$HDOendtime_utc
  )

# Create new column rounding timestamps to nearest 10 minutes and calculate 
#   median value for each time grouping. Then populate the flag column
# TODO: Can any of this code be more "behind the scenes" to reduce script?
#       Maybe a function so you can still set the rounding interval and accuracy?
hobo_do_data <- hobo_do_data %>%
  mutate(rounddate = round_date(timestamp_utc, unit = "10 minutes"))

hobo_do_medians <- hobo_do_data %>%
  group_by(rounddate) %>%
  summarise_at(vars(dissolved_oxygen_uncorrected_mg_per_l), list(median = median))

final_hobo_do <- merge(hobo_do_data, hdo_medians, by = "rounddate", all.x = TRUE) %>%
  mutate(
    FLAG = case_when(
      dissolved_oxygen_uncorrected_mg_per_l > median + 0.20 |
        dissolved_oxygen_uncorrected_mg_per_l < median - 0.20 ~ 1,
      TRUE ~ as.numeric(0)
    )
  )

# Plot final_HDO colorized by flag (0 = pass)
v <- ggplot_hobo_do_flag(final_hobo_do, point_size = 0.75)
v

# Plot final_HDO colorized by sensor
w <- ggplot_hobo_do_val(final_hobo_do, point_size = 0.4)
w

# Calculate what percent of the time each sensor is outside an "acceptable" range
percent_time_hobo_do_out_of_range <- final_hobo_do %>%
  group_by(sensor_serial_number) %>%
  summarise('Percent Bad HDO' = (sum(FLAG)) / (count = n())*100)
print(percent_time_hobo_do_out_of_range)


# FLAGGING SAL DATA -----------------------------------------------------------------------------
# TODO: Figure out a more eloquent way to select the start/end times
#         from the trimtime_table. Reduce code. 

# Manually adjust sal start or end time after viewing data if necessary
# SALstarttime_utc <- as_datetime("2023-11-16 13:40:00", tz = "UTC")
# SALendtime_utc <- as_datetime("2023-11-16 13:40:00", tz = "UTC")

# Filter for just salinity_psu variable and test time
sal_data <- filter(VALraw, `salinity_psu` != "NA") %>%
  filter(
    timestamp_utc > trimtime_table$SALstarttime_utc &
      trimtime_table$timestamp_utc < SALendtime_utc
  )

#Create new column rounding timestamps to nearest 10 minutes and calculate 
#   median value for each time grouping. Then populate the flag column
# TODO: Can any of this code be more "behind the scenes" to reduce script?
#       Maybe a function so you can still set the rounding interval and accuracy?
sal_data <- sal_data %>%
  mutate(rounddate = round_date(timestamp_utc, unit = "10 minutes"))

sal_medians <- sal_data %>%
  group_by(rounddate) %>%
  summarise_at(vars(salinity_psu), list(median = median))

final_sal <- merge(sal_data, sal_medians, by = "rounddate", all.x = TRUE) %>% 
  mutate(FLAG = case_when(
  salinity_psu > median + 1 |
  salinity_psu < median - 1 ~ 1,
  TRUE ~ as.numeric(0)
))

# Plot final_SAL colorized by flag (0 = pass)
t <- ggplot_sal_flag(final_sal, point_size = 0.5)
t

# Plot final_SAL colorized by sensor
u <- ggplot_sal_val(final_sal, point_size = 1)
u

# Calculate what percent of the time each sensor is outside an "acceptable" range
percent_time_sal_out_of_range <- final_SAL %>%
  group_by(sensor_serial_number) %>%
  summarise('Percent Bad SAL' = (sum(FLAG)) / (count = n()) * 100)
print(percent_time_sal_out_of_range)









# EXTRA CODE--------------------------------------------------------------------
# TODO: add a new section with a VR2 test, select one observation/hr for every
#       sensor type for median calculation. Test all other temp sensors as usual 


#If sensors are recording on different intervals, standardize the interval
# VR2AR <- VALraw %>%
#   filter(sensor_type == "vr2ar") %>%
#   slice(which(row_number() %% 10 == 1))
# 
# VALraw2 <- filter(VALraw, sensor_type == "aquameasure" | sensor_type == "hobo")
# 
# TEMPraw <- bind_rows(VR2AR, VALraw2)
