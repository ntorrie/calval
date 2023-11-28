#' Plot TEMP validation data, colorize points by sensor serial #
#'
#' @param final_temp Dataframe filtered for temperature test data
#'
#' @return Returns a ggplot object of temperature validation data colorized based on sensor serial #
#' 
#' @author Nicole Torrie
#' 
#' @importFrom ggplot2 ggplot aes geom_point geom_line geom_ribbon labs guides guide_legend
#' 
#' @export
#'

ggplot_temp_val <- function(final_temp) {
  s <-
    ggplot(final_temp,
           aes(
             x = timestamp_utc,
             y = temperature_degree_c,
             color = as.factor(sensor_serial_number)
           )) +
    geom_point(size = 0.25) +
    geom_line(aes(y = median), color = "black") +
    geom_ribbon(aes(ymin = median - 0.2, ymax = median + 0.2),
                alpha = 0.3,
                color = NA) 
  
  
  s <- s  + labs(color = 'sensor_serial_number') +
    guides(fill = guide_legend(ncol = 2))
  s
}

