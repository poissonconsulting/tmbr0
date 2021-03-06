#' @export
check_model_pars.tmb_code <- function(x, fixed, random, derived, drops) {
  check_string(fixed)
  checkor(check_null(random), check_vector(random, character(0)))
  checkor(check_null(derived), check_vector(derived, character(0)))
  checkor(check_null(drops), check_vector(drops, character(0)))

  if (!any(str_detect(pars(x, param_type = "primary"), fixed)))
    error("fixed does not match any primary code parameters")

  if (length(random) && !all(random %in% pars(x, param_type = "primary")))
    error("random effects parameters missing from primary code parameters")

  if (length(derived) && !all(derived %in% pars(x, param_type = "derived")))
    error("derived parameters missing from derived code parameters")

  if (length(drops) && !all(unlist(drops) %in% pars(x, param_type = "primary", scalar = TRUE)))
    error("drops parameters missing from primary scalar code pars")

  pars(x, param_type = "derived")
}

check_data_model <- function(data, model) {
  if (is.data.frame(data)) {
    data %<>% mbr::modify_data(model = model)
    inits(data, model$gen_inits, model$random_effects)
  } else
    llply(data, check_data_model, model)
  TRUE
}
