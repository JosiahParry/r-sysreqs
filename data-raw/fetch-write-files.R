
# Get rules ---------------------------------------------------------------

rules <- gh::gh("/repos/{owner}/{repo}/contents/{path}",
   owner = "rstudio",
   repo = "r-system-requirements",
   path = "rules")

name_raw <- sapply(rules, `[[`, "name")
download_url <- sapply(rules, `[[`, "download_url")

download.file(download_url,
              fs::path("rules", name_raw))


# Get patterns ------------------------------------------------------------

fps <- list.files("rules", full.names = TRUE)
lib_names <- stringr::str_remove(basename(fps), ".json")

all_rules_raw <- fps |>
  lapply(jsonlite::read_json)

patterns <- lapply(all_rules_raw, \(.x) unlist(purrr::pluck(.x, "patterns"))) |>
  setNames(lib_names)

lapply(all_rules_raw, \(.x) unlist(.x[["patterns"]])) |>
  setNames(lib_names)

jsonlite::write_json(patterns, "patterns.json")


# Write packages ----------------------------------------------------------


db <- tools::CRAN_package_db()
sysreqs <- db[!is.na(db$SystemRequirements),
              c("Package", "Version", "SystemRequirements")]

for (i in 1:nrow(sysreqs)) {
  pkg <- sysreqs[i,]
  jsonlite::write_json(
    pkg,
    fs::path("pkgs", pkg[["Package"]], ext = "json")
  )
}

