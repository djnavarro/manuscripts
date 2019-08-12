build_manuscript <- function(name) {
  build_file <- here::here("source", name, "buildme.R")
  cat("building ", name, " ... ")
  source(build_file)
  cat("done!\n")
}
