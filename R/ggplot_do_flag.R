#function to plot DO data colorized by DO flag


ggplot_do_flag <- function(DO) {
  q <-
    ggplot(
      DO,
      aes(
        x = timestamp_utc,
        y = dissolved_oxygen_percent_saturation,
        color = as.factor(FLAG)
      )
    ) +
    geom_point(size = 0.25) +
    scale_color_manual(values = c('Green', 'Red')) +
    geom_hline(yintercept = 95) +
    geom_hline(yintercept = 105) +
    geom_ribbon(aes(ymin = threshold - 5, ymax = threshold + 5),
                alpha = 0.1,
                color = NA)
  q <- q  + labs(color = 'FLAG')
  q
}

