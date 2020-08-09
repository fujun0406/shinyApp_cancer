# Project - Cancer Data (Using Shiny App)

## Contents
* [Background](#background)
* [Dataset](#dataset)
* [Application](#application)

## Background
Shiny is a package created by [Rstudio](https://rstudio.com/). Users can easily use this package to build interactive web apps straight from R. Motivated by this, I tried to employ this package to create a web application about cancer data. You can access my web app on [shiny.io](https://fuchun.shinyapps.io/shinyApp_cancer/).

## Dataset
Cancer is one of the leading causes of death in worldwide. The cancer data can provide information on the numbers and rates of mortality. Those inforamtion can benefit diagnosis, treatment and outcomes for patients who are diagnosed with cancer.

In this project, the data is obtained from the [United Kingdom NHS](https://www.cancerdata.nhs.uk/). This data set includes the number of incidences and death and tumour sites. We employ the package tidyverse to organize data structure then use shiny package to create web application.

## Application
Users can depend on their needs to choice variables including year, tumor sites, the number of cases etc to investigate dataset. After choicing the variables, they only need to press update then table and plot will automatically filter the data that is interesting by users. Users also can depends on their preference to access wide table or long table.

<img src="/image/shinyApp_cancer.jpg" width="800"/> 

<em>Figure 1: The shiny app.</em>
