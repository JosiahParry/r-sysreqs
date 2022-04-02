db <- tools::CRAN_package_db()
sysreqs <- db[!is.na(db$SystemRequirements), c("Package", "Version", "SystemRequirements")]

for (i in 1:nrow(sysreqs)) {
  pkg <- sysreqs[i, c("Package", "SystemRequirements")]
  jsonlite::write_json(
    pkg,
    fs::path("pkgs", pkg[["Package"]], ext = "json")
  )
}

