#' Create a local system requirements site
#'
#' Downloads the system requirement data to a local directory. This can be used to create your own resource to call or serve offline.
#'
#' @param outdir default `"_api"`. The path to write the site files to.
#' @param include_index default `TRUE`. Whether or not to create `index.html` files in the site.
#' @export
create_sysreqs_site <- function(outdir = "_api", include_index = TRUE) {
  check_pkg_suggests("htmltools")
  write_rules(outdir)
  write_patterns(outdir)
  write_pkgs(outdir)
  write_systems(outdir)

  if (include_index) {
    create_indexes(outdir)
  }

  cli::cli_alert_success("sysreqs directories created.")
}


#' Serve a local version of the system requirements site
#'
#' To stop serving the site, call [`stop_sysreqs()`].
#'
#' @param dir default `"_api"`. The directory to serve
#' @param host default localhost. The host to serve on.
#' @param port default `8080`. The port to listen on.
#' @export
serve_sysreqs <- function(dir = "_api", host = "0.0.0.0", port = 8080) {
  check_pkg_suggests(c("withr", "httpuv"))

  withr::with_dir(dir, {
    api_port <- httpuv::randomPort()
    s <- httpuv::startServer(host, port,
                     list(
                       staticPaths = list(
                         "/rules" = "rules/",
                         "/pkgs" = "pkgs/",
                         "/" = "./"
                       )
                     )
    )
  })

  cli::cli_alert_info(
    "site being served at http://{s$getHost()}:{s$getPort()}"
  )

  if (b_url() == "https://r-sysdeps.josiahparry.com") {
    cli::cli_alert_info("Set env var `SYSREQS_URL` to `http://{s$getHost()}:{s$getPort()}` to call local site.")
  }

  invisible(s)

}

#' Stop serving system requirements site
#' @export
stop_sysreqs <- function() httpuv::stopAllServers()


