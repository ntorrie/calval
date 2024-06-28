# DATE: 
# NAME: 
# NOTES: 
# calval version: 

# Code to visualize pre and post deployment validation data


# SET UP -----------------------------------------------------------------------
# Create an empty folder called "Log" on the path
# Hobo data must be extracted and placed in a folder on the path called "Hobo"
# aquaMeasure data must be extracted and placed in a folder on the path called "aquaMeasure"
# Vemco data must be extracted and placed in a folder on the path called "Vemco"

# Install the most recent calval package version
library(devtools)
install_github("ntorrie/calval", force = TRUE, dependencies = TRUE)
#library(miceadds) #or source all functions
#source.all("C:/Users/Nicole Torrie/Documents/R/packages/calval/R")

# Load libraries
library(calval)
library(tidyverse)
library(sensorstrings)
library(lubridate)
library(data.table)

# Set the validation ID
#VALID <- "VAL0047" #example 
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
Tracking <- googlesheets4::read_sheet(link, sheet = sheet, col_types = "c") %>%
  filter(`validation event id` == VALID)

Log <- create_val_log(Tracking) 

# Create table of test start/end times for each variable
# Set the variable to "TRUE" if the data type is present in the validation dataset
# TODO: can this part be automated based on the "validation variable" tracking sheet col?
trimtime_table <- assign_trim_times_all(Temp = TRUE,
                                        DO = TRUE,
                                        HDO = FALSE,
                                        SAL = FALSE)

# Apply final Log edits for data processing
# TODO: should this be part of the create_val_log function?
cleaned_log <- clean_log_all(Log)

# Write log to shared drive folder
fwrite(
  cleaned_log,
  file = paste0(path, "/", "Log", "/", VALID, "Log.csv"),
  na = "NA",
  showProgress = TRUE,
  col.names = TRUE
)


## READ IN LOG AND DATA --------------------------------------------------------
VALraw <- ss_compile_deployment_data(path)

# General visualization of all test data together
ss_ggplot_variables(VALraw)


# FLAGGING TEMP DATA -----------------------------------------------------------
# TODO: Figure out a more eloquent way to select the temp start/end times
#         from the trimtime_table. Reduce code. 
#       Create function to standardize the sampling interval based on user input
#         of sensor types and interval to set to

# Set the temperature test start and end times
TEMPstarttime_utc <- (trimtime_table %>%
                        filter(TimeVariable == "TEMPstarttime_utc"))[1, 2]

TEMPendtime_utc <- (trimtime_table %>%
                      filter(TimeVariable == "TEMPendtime_utc"))[1, 2]

# Manually adjust temp start or end time after viewing data if necessary
# TEMPstarttime_utc <- as_datetime("2024-05-13 14:00:00", tz = "UTC")
# TEMPendtime_utc <- as_datetime("2023-11-16 13:40:00", tz = "UTC")

# Filter for just temp variable and temp test time range
TEMP <- filter(VALraw, `temperature_degree_c` != "NA") %>%
  filter(timestamp_utc > TEMPstarttime_utc &
           timestamp_utc < TEMPendtime_utc)

# Create new column rounding timestamps to nearest 15 minutes and calculate 
#   median value for each time grouping. Then populate the flag column
# TODO: Can any of this code be more "behind the scenes" to reduce script?
#       Maybe a function so you can still set the rounding interval and accuracy?
TEMP <- TEMP %>%
  mutate(rounddate = round_date(timestamp_utc, unit = "15 minutes"))

medians <- TEMP %>%
  group_by(rounddate) %>%
  summarise_at(vars(temperature_degree_c), list(median = median))

final_temp <-
  merge(TEMP, medians, by = "rounddate", all.x = TRUE) %>%
  mutate(accuracy = if_else(sensor_type == "vr2ar", 0.5, 0.2)) %>%
  mutate(
    FLAG = case_when(
      temperature_degree_c > median + accuracy |
        temperature_degree_c < median - accuracy ~ 1,
      TRUE ~ as.numeric(0)
    )
  )

# Plot final_temp colorized by flag (0 = pass)
r <- ggplot_temp_flag(final_temp, point_size = 0.75)
r

# Plot final_temp colorized by sensor
s <- ggplot_temp_val(final_temp, point_size = 0.5)
s

# Calculate what percent of the time each sensor is outside an "acceptable" range
PercentT <- final_temp %>%
  group_by(sensor_serial_number) %>%
  summarise('Percent Bad T' = (sum(FLAG)) / (count = n())*100)
print(PercentT)


# FLAGGING DO PERCENT SATURATION DATA ------------------------------------------
# TODO: Figure out a more eloquent way to select the start/end times
#         from the trimtime_table. Reduce code. 
# Set the aquaMeasure DO test start and end times
DOstarttime_utc <- (trimtime_table %>%
                      filter(TimeVariable == "DOstarttime_utc"))[1, 2]

DOendtime_utc <- (trimtime_table %>%
                    filter(TimeVariable == "DOendtime_utc"))[1, 2]

# Manually adjust aquaMeasure DO start or end time after viewing data if necessary
# DOstarttime_utc <- as_datetime("2023-11-16 13:40:00", tz = "UTC")
# DOendtime_utc <- as_datetime("2023-11-16 13:40:00", tz = "UTC")

# Filter for just the DO % saturation variable and aquaMeasure DO test time range
DO <- filter(VALraw, `dissolved_oxygen_percent_saturation` != "NA") %>%
      filter(timestamp_utc > DOstarttime_utc &
             timestamp_utc < DOendtime_utc)
           
# Create and populate the flag column 
# DO data should read 100% during DO bucket saturation test, +/- 5% error
# TODO: Can any of this code be more "behind the scenes" to reduce script?
#       Maybe a function so you can still set the threshold and accuracy?
threshold <- 100 

final_DO <- DO %>%
  mutate(
    FLAG = case_when(
      dissolved_oxygen_percent_saturation > threshold + 5 |
        dissolved_oxygen_percent_saturation < threshold - 5 ~ 1,
      TRUE ~ as.numeric(0)
    )
  )

# Plot final_DO colorized by flag (0 = pass)
q <- ggplot_do_flag(final_DO, point_size = 0.75)
q

# Plot final_DO colorized by sensor
p <- ggplot_do_val(final_DO, point_size = 0.6)
p

# Calculate what percent of the time each sensor is outside an "acceptable" range
PercentDO <- final_DO %>%
  group_by(sensor_serial_number) %>%
  summarise('Percent Bad DO' = (sum(FLAG)) / (count = n()) * 100)
print(PercentDO)


# FLAGGING DO CONCENTRATION DATA------------------------------------------------
# TODO: Figure out a more eloquent way to select the start/end times
#         from the trimtime_table. Reduce code. 
# Set the HOBO DO test start and end times
HDOstarttime_utc <- (trimtime_table %>%
                      filter(TimeVariable == "HDOstarttime_utc"))[1,2]

HDOendtime_utc <- (trimtime_table %>%
                    filter(TimeVariable == "HDOendtime_utc"))[1,2]

# Manually adjust Hobo DO start or end time after viewing data if necessary
# HDOstarttime_utc <- as_datetime("2023-11-16 13:40:00", tz = "UTC")
# HDOendtime_utc <- as_datetime("2023-11-16 13:40:00", tz = "UTC")

# Filter for just dissolved oxygen mg/l variable and test time range
HDO <- filter(VALraw, `dissolved_oxygen_uncorrected_mg_per_l` != "NA") %>%
  filter(timestamp_utc > HDOstarttime_utc & timestamp_utc < HDOendtime_utc)

# Create new column rounding timestamps to nearest 10 minutes and calculate 
#   median value for each time grouping. Then populate the flag column
# TODO: Can any of this code be more "behind the scenes" to reduce script?
#       Maybe a function so you can still set the rounding interval and accuracy?
HDO <- HDO %>%
  mutate(rounddate = round_date(timestamp_utc, unit = "10 minutes"))

hdo_medians <- HDO %>%
  group_by(rounddate) %>%
  summarise_at(vars(dissolved_oxygen_uncorrected_mg_per_l), list(median = median))

final_HDO <- merge(HDO, hdo_medians, by = "rounddate", all.x = TRUE) %>%
  mutate(
    FLAG = case_when(
      dissolved_oxygen_uncorrected_mg_per_l > median + 0.20 |
        dissolved_oxygen_uncorrected_mg_per_l < median - 0.20 ~ 1,
      TRUE ~ as.numeric(0)
    )
  )

# Plot final_HDO colorized by flag (0 = pass)
v <- ggplot_hdo_flag(final_HDO, point_size = 0.75)
v

# Plot final_HDO colorized by sensor
w <- ggplot_hdo_val(final_HDO, point_size = 0.4)
w

# Calculate what percent of the time each sensor is outside an "acceptable" range
PercentHDO <- final_HDO %>%
  group_by(sensor_serial_number) %>%
  summarise('Percent Bad HDO' = (sum(FLAG)) / (count = n())*100)
print(PercentHDO)


# FLAGGING SAL DATA -----------------------------------------------------------------------------
# TODO: Figure out a more eloquent way to select the start/end times
#         from the trimtime_table. Reduce code. 
# Set the SAL test start and end times
SALstarttime_utc <- (trimtime_table %>%
                        filter(TimeVariable == "SALstarttime_utc"))[1,2]

SALendtime_utc <- (trimtime_table %>%
                      filter(TimeVariable == "SALendtime_utc"))[1,2]

# Manually adjust sal start or end time after viewing data if necessary
# SALstarttime_utc <- as_datetime("2023-11-16 13:40:00", tz = "UTC")
# SALendtime_utc <- as_datetime("2023-11-16 13:40:00", tz = "UTC")

# Filter for just salinity_psu variable and test time
SAL <- filter(VALraw, `salinity_psu` != "NA") %>%
  filter(timestamp_utc > SALstarttime_utc & timestamp_utc < SALendtime_utc)

#Create new column rounding timestamps to nearest 10 minutes and calculate 
#   median value for each time grouping. Then populate the flag column
# TODO: Can any of this code be more "behind the scenes" to reduce script?
#       Maybe a function so you can still set the rounding interval and accuracy?
SAL <- SAL %>%
  mutate(rounddate = round_date(timestamp_utc, unit = "10 minutes"))

sal_medians <- SAL %>%
  group_by(rounddate) %>%
  summarise_at(vars(salinity_psu), list(median = median))

final_SAL <- merge(SAL, sal_medians, by = "rounddate", all.x = TRUE) %>% 
  mutate(FLAG = case_when(
  salinity_psu > median + 1 |
  salinity_psu < median - 1 ~ 1,
  TRUE ~ as.numeric(0)
))

# Plot final_SAL colorized by flag (0 = pass)
t <- ggplot_sal_flag(final_SAL, point_size = 0.5)
t

# Plot final_SAL colorized by sensor
u <- ggplot_sal_val(final_SAL, point_size = 1)
u

# Calculate what percent of the time each sensor is outside an "acceptable" range
PercentS <- final_SAL %>%
  group_by(sensor_serial_number) %>%
  summarise('Percent Bad SAL' = (sum(FLAG)) / (count = n()) * 100)
print(PercentS)









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
