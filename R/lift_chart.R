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

#' Plot the decile chart for the binary predictions.
#' @param table The data.frame with two columns named by \code{y} and \code{yhat}.
#' @param bin_number default 10. The binning set number.
#' @export
#' @example
#' decile_chart(add2evaluation::df, bin_number = 10)
decile_chart <- function(table, bin_number = 10){
    global_mean <- mean(table$y)
    table <- lift_table(table, bin_number = bin_number) %>%
        mutate(y = y/global_mean)
    table %>%
        ggplot() +
        aes(yhat_bin,y) +
        geom_col() +
        theme(
            axis.text.x = element_text(angle = 90)
        ) +
        labs(
            y = "decile mean / global mean"
        )
}

#' Plot the cumulative gains chart.
#' @param table The data.frame with two columns named by \code{y} and \code{yhat}.
#' @export
#' @example
#' cum_gains_chart(add2evaluation::df)
cum_gains_chart <- function(table) {
  table %>%
      arrange(desc(yhat)) %>%
      mutate(
          pos_pctg = cumsum(y)/sum(y),
          obs_pctg = row_number()/n()
      ) %>%
      ggplot() +
      aes(obs_pctg, pos_pctg) +
      geom_line() +
      geom_abline(slope=1, intercept=0, col = 'red') +
      theme(axis.text.x = element_text(angle = 90)) +
      labs(x = "% Obs",
           y = "% Positive Response")
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
