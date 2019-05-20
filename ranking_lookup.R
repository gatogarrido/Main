library(tidyverse)
library(stringdist)

df <- readxl::read_xlsx("lista_universidades.xlsx")
THE_rank <- readxl::read_xlsx("lista_rankings.xlsx", sheet = "Times_Higher_Ed")
QS_rank <- readxl::read_xlsx("lista_rankings.xlsx", sheet = "QS_World")

strdist_QS <- as.tibble(stringdistmatrix(df$Name, QS_rank$Name))
strdist_QS <- strdist_QS %>% mutate(Name = df$Name) %>% select(Name, everything())

strdist_QS$min <- apply(strdist_QS, 1, min)
writexl::write_xlsx(strdist_QS, "matrix.xlsx")
