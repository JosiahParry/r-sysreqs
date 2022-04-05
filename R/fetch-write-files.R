
# Get rules ---------------------------------------------------------------
write_rules <- function(outdir) {
  check_pkg_suggests("gh")
  rules <- gh::gh("/repos/{owner}/{repo}/contents/{path}",
                  owner = "rstudio",
                  repo = "r-system-requirements",
                  path = "rules")

  name_raw <- sapply(rules, `[[`, "name")
  download_url <- sapply(rules, `[[`, "download_url")

  if (!dir.exists(outdir)) {
    dir.create(outdir)
    dir.create(fs::path(outdir, "rules"))
    dir.create(fs::path(outdir, "pkgs"))
  }

  for (i in seq_along(download_url)) {
    utils::download.file(download_url[i],
                  fs::path(outdir, "rules", name_raw[i]))
  }
}


# Get patterns ------------------------------------------------------------


write_patterns <- function(outdir) {
  fps <- list.files(fs::path(outdir, "rules"),
                    pattern = "*.json",
                    full.names = TRUE)
  lib_names <- stringr::str_remove(basename(fps), ".json")

  all_rules_raw <- fps |>
    lapply(jsonlite::read_json)

  patterns <- lapply(all_rules_raw, \(.x) unlist(.x[["patterns"]])) |>
    stats::setNames(lib_names)

  jsonlite::write_json(patterns, fs::path(outdir, "patterns.json"))

}

#write_patterns(outdir)


# Write packages ----------------------------------------------------------

write_pkgs <- function(outdir) {
  check_pkg_suggests("tools")
  db <- tools::CRAN_package_db()
  sysreqs <- db[!is.na(db$SystemRequirements),
                c("Package", "Version", "SystemRequirements")]

  for (i in 1:nrow(sysreqs)) {
    pkg <- sysreqs[i,]
    jsonlite::write_json(
      pkg,
      fs::path(outdir, "pkgs", pkg[["Package"]], ext = "json")
    )
  }
}




# Systems -----------------------------------------------------------------

write_systems <- function(outdir) {
  "[\n//    {\n//        \"os\": \"linux\",\n//        \"distribution\": \"debian\",\n//        \"versions\": [ \"8\", \"9\" ]\n//    },\n    {\n        \"os\": \"linux\",\n        \"distribution\": \"ubuntu\",\n        \"versions\": [ \"14.04\", \"16.04\", \"18.04\", \"20.04\" ]\n    },\n    {\n        \"os\": \"linux\",\n        \"distribution\": \"centos\",\n        \"versions\": [ \"6\", \"7\", \"8\" ]\n    },\n    {\n        \"os\": \"linux\",\n        \"distribution\": \"redhat\",\n        \"versions\": [ \"6\", \"7\", \"8\" ]\n    },\n    {\n        \"os\": \"linux\",\n        \"distribution\": \"opensuse\",\n        \"versions\": [ \"42.3\", \"15.0\", \"15.2\", \"15.3\" ]\n    },\n    {\n        \"os\": \"linux\",\n        \"distribution\": \"sle\",\n        \"versions\": [ \"12.3\", \"15.0\", \"15.2\", \"15.3\" ]\n    }\n]\n" |>
    writeLines(fs::path(outdir, "systems.json"))
}





