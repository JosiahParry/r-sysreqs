
fps <- list.files("rules", full.names = TRUE)
lib_names <- stringr::str_remove(basename(fps), ".json")

all_rules_raw <- fps |>
  lapply(jsonlite::read_json)

rules <- lapply(all_rules_raw, \(.x) unlist(purrr::pluck(.x, "patterns"))) |>
  setNames(lib_names)

jsonlite::write_json(rules, "rules.json")


rules <- jsonlite::read_json("rules.json") |>
  purrr::map(unlist)
