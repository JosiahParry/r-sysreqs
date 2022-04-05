
#' Identify system library requirements
#'
#' @param lib the name of a system library. Must match the name of the library as written in `/rules`.
#' @inheritParams get_pkg_sysreqs
#' @export
#' @examples
#' get_lib_reqs("fftw3", "ubuntu", "18.04")
get_lib_reqs <- function(lib, os, os_release) {
  lib_rules <- fetch_rules(lib)
  lib_deps <- lib_rules[["dependencies"]]

  distros <- sapply(lib_deps, function(.x) {
    unlist(.x[["constraints"]][[1]][["distribution"]])
  })

  versions <- sapply(lib_deps, function(.x) {
    unlist(.x[["constraints"]][[1]][["versions"]])
  })

  res <- stats::setNames(versions, distros)

  possible_index <- which(names(res) == os)

  correct_possible_index <- unlist(
    lapply(res[possible_index], \(.x) os_release %in% .x)
  )

  if (rlang::is_scalar_logical(correct_possible_index) &&
      !correct_possible_index) {
    correct_possible_index <- TRUE
  }

  true_index <- possible_index[correct_possible_index]

  pkgs <- lib_deps[[true_index]][["packages"]] |>
    unlist() %||%
    NA_character_

  pre_installs <- lib_deps[[true_index]][["pre_install"]] |>
    lapply(`[[`, "command") |>
    unlist() %||%
    NA_character_

  post_installs <- lib_deps[[true_index]][["post_install"]] |>
    lapply(`[[`, "command") |>
    unlist() %||%
    NA_character_

  list(
    "dependencies" = pkgs,
    "pre_installs" = pre_installs,
    "post_installs" = post_installs
  )
}

#get_lib_reqs("gdal", "sle", "15.0")

# Args:
# distro
# distro-version
# lib

# returns:
# packages
# pre-installs
# post-installs
