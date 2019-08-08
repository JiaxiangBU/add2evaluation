#' Run PCA model for a dataset and build a plot.
#' @export
pca_inbar <- function(data){
    library(irlba)
    library(data.table)
    library(tidyverse)
    data %>%
        na.omit() %>%
        prcomp_irlba(n=1,center = T,scale. = T) %>%
        .$rotation %>%
        as.data.frame() %>%
        mutate(name = data %>% names) %>%
        top_n(10,abs(PC1)) %>%
        mutate(name = as.factor(name)) %>%
        ggplot(aes(
            x = fct_reorder(name,PC1)
            ,y = PC1
            ,fill = name
        )) +
        geom_col(show.legend = FALSE, alpha = 0.8) +
        theme_bw() +
        theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5),
              axis.ticks.x = element_blank())
}
