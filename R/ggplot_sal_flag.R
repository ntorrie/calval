#function to plot sal data colorized by sal flag


ggplot_sal_flag <- function(final_SAL) {
  t <-
    ggplot(final_SAL,
           aes(
             x = timestamp_utc,
             y = salinity_psu,
             color = as.factor(FLAG)
           )) +
    geom_point(size = 0.25) +
    scale_color_manual(values = c('Green', 'Red')) +
    geom_line(aes(y = median), color = "black") +
    geom_ribbon(aes(ymin = median - 0.2, ymax = median + 0.2),
                alpha = 0.3,
                color = NA)
  
  t <- t  + labs(color = 'FLAG')
  t
}


