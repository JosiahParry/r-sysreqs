#' @keywords internal
`%||%` <- function (x, y) {
  if (rlang::is_null(x))
    y
  else x
}

patterns <- fetch_patterns()



#' Check if a vector of packages are available
#'
#' @param x a character vector of package names
#' @keywords internal
check_pkg_suggests <- function(x) {
  missing_pkgs <- !vapply(x, requireNamespace, FUN.VALUE = logical(1), quietly = TRUE)

  if (any(missing_pkgs))
    cli::cli_abort('Missing packages: {paste("`", x[missing_pkgs], "`", sep = "", collapse = ", ")}')
}
