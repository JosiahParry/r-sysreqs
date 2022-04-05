# build-site
from <- fs::dir_ls("_api", recursive = TRUE)

to <- stringr::str_replace_all(from, "^_api/", "_site/")

dir.create("_site/rules")
dir.create("_site/pkgs")
file.copy(from, to, overwrite = TRUE)
