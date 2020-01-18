#' Run PCA model for a dataset and build a plot.
#' @import irlba
#' @import data.table
#' @import dplyr
#' @import tidyr
#' @import ggplot2
#' @import forcats
#' @import irlba
#' @import lubridate
#' @import stats
#' @param data data.frame prepared for running PCA model.
#' @export
pca_inbar <- function(data){
    # library(irlba)
    # library(data.table)
    # library(tidyverse)
    data %>%
        stats::na.omit() %>%
        irlba::prcomp_irlba(n=1,center = T,scale. = T) %>%
        .$rotation %>%
        as.data.frame() %>%
        dplyr::mutate(name = data %>% names) %>%
        dplyr::top_n(10,abs(PC1)) %>%
        dplyr::mutate(name = as.factor(name)) %>%
        ggplot2::ggplot(aes(
            x = forcats::fct_reorder(name,PC1)
            ,y = PC1
            ,fill = name
        )) +
        ggplot2::geom_col(show.legend = FALSE, alpha = 0.8) +
        ggplot2::theme_bw() +
        ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 90, hjust = 1, vjust = 0.5),
              axis.ticks.x = ggplot2::element_blank())
}
