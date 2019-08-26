groom_model <- function(model) {
    list(
        model = glance(model),
        coefficients = tidy(model),
        observations = augment(model)
    )
}
