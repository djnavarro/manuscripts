library(dplyr)
library(here)
library(bib2df)

bib_file <- here("danielle.bib")

bib_df <- bib %>%
  bib2df() %>%
  arrange(desc(YEAR), BIBTEXKEY)

# df2bib(bib_df, file = bib_file)
