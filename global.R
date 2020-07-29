library(shiny)
library(dplyr)
library(ggplot2)

library(readr)
library(knitr)

myfile <- "https://github.com/CSSEGISandData/COVID-19/raw/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_US.csv"
confirmed <- read_csv(myfile)
inst1CC <- confirmed[confirmed$Combined_Key == "Travis, Texas, US" ,11:ncol(confirmed)]
inst2CC <- confirmed[confirmed$Combined_Key == "Harford, Maryland, US" ,11:ncol(confirmed)]
inst3CC <- confirmed[confirmed$Combined_Key == "Leavenworth, Kansas, US" ,11:ncol(confirmed)]
myfile <- "https://opendata.arcgis.com/datasets/6ac5e325468c4cb9b905f1728d6fbf0f_0.csv?outSR=%7B%22latestWkid%22%3A3857%2C%22wkid%22%3A102100%7D"
capacity <- read_csv(myfile)
inst1Beds = aggregate(capacity[capacity$STATE=="TX" & capacity$COUNTY=="TRAVIS"]$BEDS)