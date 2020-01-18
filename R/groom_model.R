#' Get model details by \pkg{broom}
#' @param model The model object supported by \pkg{broom}
#' @importFrom broom glance tidy augment
#' @export
groom_model <- function(model) {
    list(
        model = broom::glance(model),
        coefficients = broom::tidy(model),
        observations = broom::augment(model)
    )
}
