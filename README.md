
<!-- README.md is generated from README.Rmd. Please edit that file -->

# calval

<img src="man/figures/README-calval_hexsticker.png" width="25%" style="display: block; margin: auto;" />

<!-- badges: start -->

[![License: GPL
v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![R-CMD-check](https://github.com/ntorrie/calval/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/ntorrie/calval/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

The calval package contains a collection of functions to assist with the
flagging and visualization of validation data collected during quality
assurance testing of CMAR Coastal Monitoring Program sensors. Sensor
testing occurs prior to sensor deployment to ensure sensors are
recording within an appropriate range. Testing occurs again after
sensors are retrieved from deployment to check for sensor drift and
biofouling impacts.

# Installation

You can install the development version of calval from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("ntorrie/calval")
```

# Pre-Deployment Validation Tests

Prior to deployment, sensors that can be calibrated are calibrated
according to their specific sensor manual. All sensors are then
subjected to a Validation Test(s), which differ depending on the
variables measured.

## Dissolved Oxygen (percent saturation)

For a Validation Test of dissolved oxygen measured in units of percent
saturation, sensors are set to record at 10 minute intervals and placed
in an air-tight environment with water-saturated air at 100 % humidity.
The sensors are left to record for a minimum of 6 hours (Figure 2)

The precision for these dissolved oxygen sensors is +/-5 % (InnovaSea
2021). Since the the sensors in the bucket are in water-saturated air,
they should measure 100 +/-5 % saturation. Any sensors outside of the
acceptable 95 - 105 % range for more than 10 % of the test require
re-calibration.

Figure 3 shows the results of a dissolved oxygen Validation Test for
four sensors. Sensor \#675016 recorded outside of an acceptable range
for 99.9% of the test period, and was therefore flagged for
re-calibration.

## Other Variables

For Validation Tests of temperature and dissolved oxygen measured in
mg/L, sensors are set to record at 10 - 15 minute intervals and
submerged in a well insulated, circulating tank of fresh water for a
minimum of 12 hours. The same procedure is used for the salinity
Validation Tests, except seawater is used instead of fresh water.

## Results

Upon completion of the Validation Tests, data from each sensor is
offloaded and evaluated using the calval package functions to ensure all
sensors are recording within an appropriate manufacturer-specified range
of each other. Sensors that pass the tests are cleared for deployment.
Any sensor that records outside of the acceptable range for \> 10 % of
the test will be re-calibrated (if applicable) and re-validated. If a
sensor fails more than 2 consecutive validation tests it will be sent
back to the manufacturer for troubleshooting.

# Post-Deployment Validation

After sensors are retrieved from deployment, they undergo
post-deployment validation testing following the same procedures as the
pre-deployment validation test. Results from the post-deployment
validation tests indicate whether the sensor data retrieved during the
sensor deployment may have been impacted by sensor drift or biofouling.
