#' Plot the lift chart for the binary predictions.
#' @param table The data.frame with two columns named by \code{y} and \code{yhat}.
#' @param bin_number default 10. The binning set number.
#' @import dplyr
#' @import ggplot2
#' @export
#' @examples
#' \dontrun{lift_chart(add2evaluation::df, bin_number = 10)}
lift_chart <- function(table, bin_number = 10) {
  table <- lift_table(table, bin_number = bin_number)
  table %>%
    ggplot2::ggplot() +
    ggplot2::aes(yhat_bin, y) +
    ggplot2::geom_col() +
    ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 90))
}

#' Plot the decile chart for the binary predictions.
#' @param table The data.frame with two columns named by \code{y} and \code{yhat}.
#' @param bin_number default 10. The binning set number.
#' @export
#' @examples
#' \dontrun{decile_chart(add2evaluation::df, bin_number = 10)}
decile_chart <- function(table, bin_number = 10) {
  global_mean <- mean(table$y)
  table <- lift_table(table, bin_number = bin_number) %>%
    dplyr::mutate(y = y / global_mean)
  table %>%
    ggplot2::ggplot() +
    ggplot2::aes(yhat_bin, y) +
    ggplot2::geom_col() +
    ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 90)) +
    ggplot2::labs(y = "decile mean / global mean")
}

#' Plot the cumulative gains chart.
#' @param table The data.frame with two columns named by \code{y} and \code{yhat}.
#' @export
#' @examples
#' \dontrun{cum_gains_chart(add2evaluation::df)}
cum_gains_chart <- function(table) {
  table %>%
    dplyr::arrange(dplyr::desc(yhat)) %>%
    dplyr::mutate(pos_pctg = cumsum(y) / sum(y),
                  obs_pctg = dplyr::row_number() / dplyr::n()) %>%
    ggplot2::ggplot() +
    ggplot2::aes(obs_pctg, pos_pctg) +
    ggplot2::geom_line() +
    ggplot2::geom_abline(slope = 1,
                         intercept = 0,
                         col = 'red') +
    ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 90)) +
    ggplot2::labs(x = "% Obs",
                  y = "% Positive Response")
}

#' Plot the cumulative lift chart.
#' @param table The data.frame with two columns named by \code{y} and \code{yhat}.
#' @export
#' @examples
#' \dontrun{cum_lift_chart(add2evaluation::df)}
cum_lift_chart <- function(table) {
  table %>%
    dplyr::arrange(dplyr::desc(yhat)) %>%
    dplyr::mutate(
      local_mean = dplyr::cummean(y),
      global_mean = mean(y),
      lift = local_mean / global_mean,
      obs_pctg = dplyr::row_number() / dplyr::n()
    ) %>%
    ggplot2::ggplot() +
    ggplot2::aes(obs_pctg, lift) +
    geom_hline(yintercept = 1, col = 'red') +
    ggplot2::geom_line() +
    ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 90)) +
    ggplot2::labs(x = "% Obs",
                  y = "Lift")
}

#' Output the dataframe table of lift chart.
#' @param table The data.frame with two columns named by \code{y} and \code{yhat}.
#' @param bin_number default 10. The binning set number.
lift_table <- function(table, bin_number = 10) {
  table %>%
    dplyr::mutate(yhat_bin = ggplot2::cut_number(yhat, bin_number)) %>%
    dplyr::group_by(yhat_bin) %>%
    dplyr::summarise(y = mean(y), yhat = mean(yhat))
}

#' Plot the calibration curve for the binary predictions.
#' @param table The data.frame with two columns named by \code{y} and \code{yhat}.
#' @param bin_number default 10. The binning set number.
#' @export
#' @examples
#' \dontrun{calibration_curve(add2evaluation::df, bin_number = 10)}
calibration_curve <- function(table, bin_number = 10) {
  table <- lift_table(table, bin_number = bin_number)
  table %>%
    ggplot2::ggplot() +
    ggplot2::aes(yhat, y) +
    ggplot2::geom_line() +
    ggplot2::geom_abline(slope = 1, intercept = 0, color = 'red') +
    ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 90)) +
    ggplot2::labs(x = "Ave. Pred. Prob.",
                  y = "Frac. of pos.") +
    coord_equal()
}
