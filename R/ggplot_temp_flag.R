#function to plot temp data colorized by temp flag


ggplot_temp_flag <- function(final_temp) {
  r <-
    ggplot(final_temp,
           aes(
             x = timestamp_utc,
             y = temperature_degree_c,
             color = as.factor(FLAG)
           )) +
    geom_point(size = 0.25) +
    scale_color_manual(values = c('Green', 'Red')) +
    geom_line(aes(y = median), color = "black") +
    geom_ribbon(aes(ymin = median - 0.2, ymax = median + 0.2),
                alpha = 0.3,
                color = NA)
  
  r <- r  + labs(color = 'FLAG')
  r
}


