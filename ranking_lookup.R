library(tidyverse)
library(stringdist)

df <- readxl::read_xlsx("lista_universidades_base.xlsx")
THE_rank <- readxl::read_xlsx("lista_rankings.xlsx", sheet = "Times_Higher_Ed")
QS_rank <- readxl::read_xlsx("lista_rankings.xlsx", sheet = "QS_World")

strdist_QS <- as_tibble(stringdistmatrix(df$`names_list$Nombres`, QS_rank$Name))
strdist_QS <- strdist_QS %>% mutate(Name = df$`names_list$Nombres`) %>% select(Name, everything())

strdist_QS$min <- apply(strdist_QS, 1, min)

writexl::write_xlsx(strdist_QS, "matrix.xlsx")
