#function to plot DO data colorized by sensor


ggplot_do_val <- function(DO) {
  p <-
    ggplot(
      DO,
      aes(
        x = timestamp_utc,
        y = dissolved_oxygen_percent_saturation,
        color = as.factor(sensor_serial_number)
      )
    ) +
    geom_point(size = 0.25) +
    geom_hline(yintercept = 95) +
    geom_hline(yintercept = 105) +
    geom_ribbon(aes(ymin = threshold - 5, ymax = threshold + 5),
                alpha = 0.1,
                color = NA)
  p <- p  + labs(color = 'sensor_serial_number')
  p
}




