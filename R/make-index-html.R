# outdir = "_api"
# pkgs index --------------------------------------------------------------

create_indexes <- function(outdir) {
  create_pkg_index(outdir)
  create_rules_index(outdir)
  create_home_index(outdir)
}

create_pkg_index <- function(outdir) {
  check_pkg_suggests("htmltools")
  fps <- fs::dir_ls(fs::path(outdir, "pkgs"))
  pkg_names <- stringr::str_remove(basename(fps), ".json")

  tags$ul(
    purrr::map2(basename(fps), pkg_names, ~{
      tags$li(tags$a(.y, href = fs::path( .x)))
    })
  ) |>
    htmltools::save_html(fs::path(outdir, "pkgs/index.html"))
}

# Rules index -------------------------------------------------------------

create_rules_index <- function(outdir) {
  check_pkg_suggests("htmltools")
  fps <- list.files(fs::path(outdir, "rules"))
  lib_names <- stringr::str_remove(basename(fps), ".json")

  tags$ul(
    purrr::map2(fps, lib_names, ~{
      tags$li(tags$a(.y, href = fs::path( .x)))
    })
  ) |>
    htmltools::save_html(fs::path(outdir, "rules/index.html"))
}





# root index --------------------------------------------------------------
create_home_index <- function(outdir) {
  check_pkg_suggests("htmltools")
  tags$ul(
    tags$li(tags$a("/pkgs", href = "pkgs")),
    tags$li(tags$a("/rules", href = "rules")),
    tags$li(tags$a("patterns", href = "patterns.json")),
    tags$li(tags$a("systems", href = "systems.json"))
  ) |>
    htmltools::save_html(fs::path(outdir, "index.html"))
}


