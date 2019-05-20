library(rvest)
library(tidyverse)

url = list()
univ_list = list()
cities_list = list()
info_list = list()

#List of Universities for Business Analytics Masters Degree
url[1] = "https://yocket.in/universities/masters-in-business-analytics/study-in-usa"
url[2] = "https://yocket.in/universities/masters-in-business-analytics/study-in-usa?page=2"
url[3] = "https://yocket.in/universities/masters-in-business-analytics/study-in-usa?page=3"

#List of Universities for Data Science & Analytics Masters Degree
url[4] = "https://yocket.in/universities/masters-in-analytics/study-in-usa"
url[5] = "https://yocket.in/universities/masters-in-analytics/study-in-usa?page=2"
url[6] = "https://yocket.in/universities/masters-in-analytics/study-in-usa?page=3"
url[7] = "https://yocket.in/universities/masters-in-analytics/study-in-usa?page=4"

#List of Universities for Business Analytics Masters Degree
url[8] = "https://yocket.in/universities/masters-in-management-information-system/study-in-usa"
url[9] = "https://yocket.in/universities/masters-in-management-information-system/study-in-usa?page=2"
url[10] = "https://yocket.in/universities/masters-in-management-information-system/study-in-usa?page=3"
url[11] = "https://yocket.in/universities/masters-in-management-information-system/study-in-usa?page=4"
url[12] = "https://yocket.in/universities/masters-in-management-information-system/study-in-usa?page=5"
url[13] = "https://yocket.in/universities/masters-in-management-information-system/study-in-usa?page=6"

for (x in c(1:13)){
  single_url = url[[x]]
  download.file(single_url, destfile = "scrapedpage.html", quiet=TRUE)
  content <- read_html("scrapedpage.html")
  
  content <- content %>%  html_nodes(xpath= "//*[contains(concat( ' ', @class, ' ' ), concat( ' ', 'card-content', ' ' ))]")
  titles <- content %>% html_nodes(xpath= "//*[contains(concat( ' ', @class, ' ' ), concat( ' ', 'lead', ' ' ))]")
  p_nodes <- content %>% html_nodes("p")
  univ_list[x] <- as_tibble(html_text(titles))
  #cities_list[x] <- as_tibble(html_text(p_nodes))
  cities_list[x] <- as_tibble(html_text(p_nodes[seq(2, length(p_nodes), 5)]))
  info_list[x] <- as_tibble(html_text(p_nodes[seq(5, length(p_nodes), 5)]))
}

names_list = do.call(rbind, univ_list)
names_list <- as_tibble(names_list)

cities_list = do.call(rbind, cities_list)
cities_list <- as_tibble(cities_list)

info_list = do.call(rbind, info_list)
info_list <- as_tibble(info_list)

names_list <- names_list %>% gather(Fuente, Nombres, everything())
cities_list <- cities_list %>% gather(Fuente, Ciudad, everything())
info_list <- info_list %>% gather(Fuente, Datos, everything())

df <- data_frame(names_list$Nombres, cities_list$Ciudad, info_list$Datos)
writexl::write_xlsx(df, "lista_universidades.xlsx")