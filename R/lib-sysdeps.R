
gdal_rules <- get_rules("gdal")

gdal_deps <- gdal_rules[["dependencies"]]

distro <- gdal_deps[[1]][["constraints"]][[1]][["distribution"]]
distro_version <- gdal_deps[[1]][["constraints"]][[1]][["versions"]] |>
  unlist()

versions <- purrr::map(gdal_deps, ~{
  .x[["constraints"]][[1]][["versions"]] |>
    unlist()
})


distros <- purrr::map_chr(gdal_deps, ~{
  .x[["constraints"]][[1]][["distribution"]] |>
    unlist()
})


setNames(versions, distros)

# Args:
# distro
# distro-version
# lib

# returns:
# packages
# pre-installs
# post-installs



# xml_rules <- get_rules("libxml2")
# xml_deps <- xml_rules[["dependencies"]]
#
# xml_deps[[1]][["constraints"]][[1]][["versions"]]
#
# xml_deps[[1]][["constraints"]]

gdal_packages <- gdal_rules
purrr::map(gdal_deps, ~{
  y <- .x[["constraints"]][[1]]
  distro <- y[["distribution"]]
  version <- y[["versions"]]
  version
})

