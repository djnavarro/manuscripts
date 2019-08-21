library(dplyr)
library(here)
library(bib2df)

bib <- here("citation", "danielle.bib")

bib %>%
  bib2df() %>%
  arrange(desc(YEAR), BIBTEXKEY) %>%
  df2bib(file = bib)
