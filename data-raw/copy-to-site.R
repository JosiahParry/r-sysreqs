# all jsons
from <- list.files("_api", recursive = TRUE, full.names = TRUE,
                   pattern = "*.json")
to <- stringr::str_replace(from, "^_api/", "_site/")

file.copy(from, to)


create_rules_index("_api")
create_pkg_index("_api")

file.copy(
  c("_api/pkgs/index.html",
  "_api/rules/index.html"),
  c("_site/pkgs/index.html",
    "_site/rules/index.html"),
  overwrite = TRUE)
