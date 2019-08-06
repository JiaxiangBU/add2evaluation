#' Plot the lift chart for the binary predictions.
#' @param table The data.frame with two columns named by \code{y} and \code{yhat}.
#' @param bin_number default 10. The binning set number.
#' @export
lift_chart <- function(table, bin_number = 10){

    table %>%
        mutate(yhat_bin = cut_number(yhat,bin_number)) %>%
        group_by(yhat_bin) %>%
        summarise(y = mean(y)) %>%
        ggplot() +
        aes(yhat_bin,y) +
        geom_col() +
        theme(
            axis.text.x = element_text(angle = 90)
        )
}
