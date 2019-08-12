#' Plot the lift chart for the binary predictions.
#' @param table The data.frame with two columns named by \code{y} and \code{yhat}.
#' @param bin_number default 10. The binning set number.
#' @export
#' @example
#' lift_chart(add2evaluation::df, bin_number = 10)
lift_chart <- function(table, bin_number = 10){
    table <- lift_table(table, bin_number = bin_number)
    table %>%
        ggplot() +
        aes(yhat_bin,y) +
        geom_col() +
        theme(
            axis.text.x = element_text(angle = 90)
        )
}

#' Output the dataframe table of lift chart.
#' @param table The data.frame with two columns named by \code{y} and \code{yhat}.
#' @param bin_number default 10. The binning set number.
lift_table <- function(table, bin_number = 10){
  table %>%
      mutate(yhat_bin = cut_number(yhat,bin_number)) %>%
      group_by(yhat_bin) %>%
      summarise(y = mean(y))
}
