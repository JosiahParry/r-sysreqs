#' Get system requirements for a package
#'
#' From a given R package name, identify it's system requirements.
#'
#' @returns
#'
#' A named list for each system requirement identified where each element is a named list for each required system library containing the elements:
#'
#' - `dependencies`: the required library names
#' - `pre_installs`: a character vector of commands typically required before installation
#' - `post_installs`: a character vector of commands typically required after installation
#' @param verbose default `TRUE`. Whether to inform of missing packages.
#' @inheritParams fetch_pkg
#' @param os the operating system. See [`fetch_systems()`].
#' @param os_release the version for `os`.
#' @export
#' @examples
#' get_pkg_sysreqs("igraph", "centos", "8")
get_pkg_sysreqs <- function(pkg, os, os_release, verbose = TRUE) {
  sys_deps <- fetch_pkg_deps(pkg, verbose = verbose)

  if (all(is.na(sys_deps))) {
    return(list(
       list(dependencies = NA_character_,
           pre_installs = NA_character_,
           post_installs =NA_character_)
    ))
  }
  lapply(sys_deps, get_lib_reqs, os, os_release) |>
    stats::setNames(sys_deps)
}

#' Get system requirements for multiple packages
#'
#' From a vector of R package names, identify their system dependencies.
#'
#' @returns
#'
#' A tibble with 4 columns:
#'
#' - `name`: The system library name.
#' - `dependencies`: The dependencies for `name`.
#' - `pre_installs`: The recommended pre-installation commands.
#' - `post_installs`: The recommended post-installation commands.

#' @param verbose default `FALSE`. Whether to inform of missing packages.
#' @param pkgs a character vector of package names.
#' @inheritParams get_pkg_sysreqs
#' @export
#' @examples
#' get_pkgs_sysreqs(
#'   c("rJava", "igraph", "rgdal", "spdep"),
#'   "ubuntu", "16.04"
#' )
get_pkgs_sysreqs <- function(pkgs, os, os_release, verbose = FALSE) {
  check_pkg_suggests(c("purrr", "tibble", "tidyr", "dplyr"))
  pkgs |>
    purrr::map_dfr(~{
      tibble::enframe(get_pkg_sysreqs(.x, os, os_release, verbose = verbose)) |>
        dplyr::mutate(pkg = .x, .before = 1,
                      name = as.character(name),
                      name = ifelse(stringr::str_detect(name, "^\\d+$"),
                                    NA_character_,
                                    name))
    })|>
    tidyr::unnest_wider("value")
}
