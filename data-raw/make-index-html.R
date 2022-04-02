library(htmltools)


# pkgs index --------------------------------------------------------------

fps <- list.files("pkgs")
pkg_names <- stringr::str_remove(basename(fps), ".json")



tags$ul(
  purrr::map2(fps, pkg_names, ~{
    tags$li(tags$a(.y, href = fs::path( .x)))
  })
) |>
  save_html("pkgs/index.html")

# Rules index -------------------------------------------------------------



fps <- list.files("rules")
lib_names <- stringr::str_remove(basename(fps), ".json")


tags$ul(
  purrr::map2(fps, lib_names, ~{
    tags$li(tags$a(.y, href = fs::path( .x)))
  })
) |>
  save_html("rules/index.html")



# root index --------------------------------------------------------------


tags$ul(
  tags$li(tags$a("/pkgs", href = "pkgs")),
  tags$li(tags$a("/rules", href = "rules")),
  tags$li(tags$a("patterns", href = "patterns.json")),
  tags$li(tags$a("systems", href = "systems.json"))
) |>
  save_html("index.html")
