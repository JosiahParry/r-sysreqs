library(htmltools)


fps <- list.files("rules", full.names = TRUE)
lib_names <- stringr::str_remove(basename(fps), ".json")

tags$ul(
  lapply(lib_names, tags$li)
)

tags$ul(
  purrr::map2(fps, lib_names, ~{
    tags$li(tags$a(.y, href = fs::path( .x)))
  })
) |>
  save_html("rules/index.html")


tags$ul(
  tags$li(tags$a("/pkgs", href = "pkgs")),
  tags$li(tags$a("/rules", href = "rules")),
  tags$li(tags$a("patterns", href = "patterns.json")),
  tags$li(tags$a("systems", href = "systems.json"))
) |>
  save_html("index.html")
