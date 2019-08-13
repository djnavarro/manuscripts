manuscript <- "2012_samplingassumptions"

# load packages
library(tinytex)
library(here)

# latex is annoying with directories, so use setwd
wd <- setwd(here("source", manuscript))

# compile document
for(i in 1:1) {
  cat(".")
  latexmk(
    file = paste0(manuscript, ".tex"),
    install_packages = TRUE,
    bib_engine = "bibtex"
  )
}

# move the pdf to where it should go
file.rename(
  from = here("source", manuscript, paste0(manuscript, ".pdf")),
  to = here("manuscripts", paste0(manuscript, ".pdf"))
)

# be polite: return to where we came from
setwd(wd)
