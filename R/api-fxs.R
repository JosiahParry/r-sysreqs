b_url <- "https://r-sysdeps.josiahparry.com"

get_systems <- function() {
  httr::GET(fs::path(b_url, "systems", ext = "json")) |>
    httr::content()
}

get_patterns <- function() {
  httr::GET(fs::path(b_url, "patterns.json")) |>
    httr::content(as = "text") |>
    jsonlite::parse_json(simplifyVector = TRUE)
}

# get_patterns()

get_pkg_deps <- function(pkg) {
  pkg_url <- fs::path(b_url, "pkgs", pkg, ext = "json")
  res <- httr::GET(pkg_url) |>
    httr::content(as = "text", encoding = "utf-8") |>
    jsonlite::parse_json(simplifyVector = TRUE)

  res[["SystemRequirements"]] |>
    stats::setNames(pkg)
}

#get_pkg_deps("igraph")

get_rules <- function(sysdep) {
  sysdep_url <- fs::path(b_url, "rules", sysdep, ext = "json")

  httr::GET(sysdep_url) |>
    httr::content()
}
