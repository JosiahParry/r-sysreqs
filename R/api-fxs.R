
#' Get supported operating systems
#'
#' Returns a list of supported operating systems.
#'
#' @export
fetch_systems <- function() {
  httr::GET(fs::path(b_url(), "systems", ext = "json")) |>
    httr::content(encoding = "utf-8")
}

#' Return list of library regex patterns
#'
#' Returns a name list containing the regex patterns stored in each rule. The name is the name of the library and the values are the regex patterns used to match the libary.
#' @export
fetch_patterns <- function() {
  httr::GET(fs::path(b_url(), "patterns.json")) |>
    httr::content(as = "text", encoding = "utf-8") |>
    jsonlite::parse_json(simplifyVector = TRUE)
}

#fetch_patterns()

#' Get a packages information
#'
#' Returns the parsed json from `/pkgs/pkg-name.json`.
#' Containing the package name, version, and system requirements.
#' @param verbose default `TRUE`. Whether to inform of missing packages.
#' @param pkg package name as a scalar character
#' @export
fetch_pkg <- function(pkg, verbose = TRUE) {
  pkg_url <- fs::path(b_url(), "pkgs", pkg, ext = "json")
  res <- httr::GET(pkg_url) |>
    httr::content(as = "text", encoding = "utf-8")

  if (!jsonlite::validate(res)) {
    if (verbose) cli::cli_alert_info("{pkg} has no recorded system requirements.")
    return(
      data.frame(Package = NA_character_,
                 Version = NA_character_,
                 SystemRequirements = NA_character_)
    )
  }

  jsonlite::parse_json(res, simplifyVector = TRUE)

}


#' Get a packages system requirements
#'
#' Fetches a package's information and identifies its required system libraries using the patterns stored in each rule. See `fetch_patterns()`.
#' @param verbose default `TRUE`. Whether to inform of missing packages.
#' @inheritParams fetch_pkg
#' @importFrom stringr str_detect
#' @importFrom httr content GET
#' @export
fetch_pkg_deps <- function(pkg, verbose = TRUE) {

  pkg_url <- fs::path(b_url(), "pkgs", pkg, ext = "json")
  resp <- httr::GET(pkg_url) |>
    httr::content(as = "text", encoding = "utf-8")

  if (!jsonlite::validate(resp)) {
    if (verbose) cli::cli_alert_info("{pkg} has no recorded system requirements.")
    return(NA_character_)
  }

  res <- resp |>
    jsonlite::parse_json(simplifyVector = TRUE)

  pkg_sysreqs <- tolower(res[["SystemRequirements"]])

  req_index <- lapply(patterns,
                      \(.x) any(stringr::str_detect(pkg_sysreqs, .x))) |>
    unlist()

  names(patterns)[req_index]
}

# fetch_pkg_deps("igraph")
# fetch_pkg_deps("RMariaDB")
# fetch_pkg_deps("rgdal")

#' Get rules for a given system library
#'
#' @param lib name of a system library as scalar character
#' @export
fetch_rules <- function(lib) {
  sysdep_url <- fs::path(b_url(), "rules", lib, ext = "json")

  httr::GET(sysdep_url) |>
    httr::content()
}




b_url <- function() {
  if (Sys.getenv("SYSREQS_URL") != "") return(Sys.getenv("SYSREQS_URL"))

  "https://r-sysreqs.josiahparry.com"
}

