library(tidyverse)
getData <- function() {
  cancer <- read.csv("cancer.csv")
  cancer <- tibble(cancer) 
  cancer$MortalityRate <- round(cancer$Deaths/cancer$Cases, 2)

  cancer_longer <- cancer %>%
    pivot_longer(-(Year:TumourSite), names_to = "State", values_to = "Values")
  
  cancer_longer
}
