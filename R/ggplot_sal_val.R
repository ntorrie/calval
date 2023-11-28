#function to plot sal data colorized by sensor

ggplot_sal_val <- function(final_SAL) {
  u <-
    ggplot(final_SAL,
           aes(
             x = timestamp_utc,
             y = salinity_psu,
             color = as.factor(sensor_serial_number)
           )) +
    geom_point(size = 0.25) +
    geom_line(aes(y = median), color = "black") +
    geom_ribbon(aes(ymin = median - 0.2, ymax = median + 0.2),
                alpha = 0.3,
                color = NA) 
  
  
  u <- u  + labs(color = 'sensor_serial_number') +
    guides(fill = guide_legend(ncol = 2))
  u
}
