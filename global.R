library(shiny)
library(dplyr)
library(ggplot2)
library(leaflet)
library(shinydashboard)
library(readr)
library(knitr)

library(shiny)
library(dplyr)
library(ggplot2)
library(data.table)
library(tidyr)
library(gganimate)
library(leaflet)
library(geojsonio)
library(maps)
library(htmlwidgets)
library(htmltools)
library(rgdal)
library(zoo)
library(latticeExtra)
library(shinydashboard)
library(googleVis)
library(RColorBrewer)
library(widgetframe)
library(scales)
installations <- data.frame("Name" = c("Austin Installation", "Aberdeen Installation", "Leavenworth Installation"),
                            "lat" = c(30.26897, 39.42535, 39.34798), "lng" = c(-97.74081,-76.21358,-94.93554 ), "pop"=c(1274000,255441,81758), "dense"=c(1245,485,174))
myfile <- "https://github.com/CSSEGISandData/COVID-19/raw/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_US.csv"
confirmed <- read_csv(myfile)
recovered <- confirmed
recovered[,12:ncol(recovered)] <-0
recovered[,33:ncol(recovered)] <- confirmed[,12:(ncol(confirmed)-21)]
confirmed[,12:ncol(confirmed)] <- confirmed[,12:ncol(confirmed)]-recovered[,12:ncol(recovered)]
confirmed <- confirmed[,11:ncol(confirmed)] %>% gather(., "Date","Active_Cases",-Combined_Key )
recovered <- recovered[,11:ncol(recovered)] %>% gather(., "Date","Resolved_Cases",-Combined_Key )
confirmed <- confirmed %>% mutate(Resolved_Cases = recovered$Resolved_Cases)
confirmed$Date<-as.Date(confirmed$Date, "%m/%d/%y")


myfile <- paste("https://github.com/CSSEGISandData/COVID-19/raw/master/csse_covid_19_data/csse_covid_19_daily_reports/", format(Sys.Date()-2, "%m-%d-%Y"),".csv",sep="")
incidence <- read_csv(myfile)
installations = installations %>% mutate(Incidence_Rate = c(
incidence[incidence$Combined_Key == "Travis, Texas, US",]$Incidence_Rate,
incidence[incidence$Combined_Key == "Harford, Maryland, US",]$Incidence_Rate,
incidence[incidence$Combined_Key == "Leavenworth, Kansas, US",]$Incidence_Rate),
county=c("Travis, Texas, US","Harford, Maryland, US","Leavenworth, Kansas, US"))
myfile <- "https://opendata.arcgis.com/datasets/6ac5e325468c4cb9b905f1728d6fbf0f_0.csv?outSR=%7B%22latestWkid%22%3A3857%2C%22wkid%22%3A102100%7D"
capacity <- read_csv(myfile)
installations = installations %>% mutate(Beds = c(
sum(pmax( capacity[capacity$STATE=="TX" & capacity$COUNTY=="TRAVIS",]$BEDS),0),
sum(pmax(capacity[capacity$STATE=="MD" & capacity$COUNTY=="HARFORD",]$BEDS),0),
sum(pmax(capacity[capacity$STATE=="KS" & capacity$COUNTY=="LEAVENWORTH",]$BEDS,0))))
installations = installations %>% mutate(Total_Confirmed = c(
  incidence[incidence$Combined_Key == "Travis, Texas, US",]$Active,
  incidence[incidence$Combined_Key == "Harford, Maryland, US",]$Active,
  incidence[incidence$Combined_Key == "Leavenworth, Kansas, US",]$Active),
  state=c("Texas","Maryland","Kansas"))
myfile<- "https://covidtracking.com/api/v1/states/tx/daily.csv"
testing <- read_csv(myfile)
testing = filter(testing, testing$totalTestResultsIncrease >0)
testCap1 = mean(Map("/",testing[1:7, "positiveIncrease"], testing[1:7, "totalTestResultsIncrease"])[[1]])
tests1 = mean(testing[1:7, "positiveIncrease"][[1]])
pos1 = testing[1,"positive"]-testing[1,"recovered"]-testing[1,"death"]
myfile<- "https://covidtracking.com/api/v1/states/md/daily.csv"
testing <- read_csv(myfile)
testing = filter(testing, testing$totalTestResultsIncrease >0)
testCap2 = mean(Map("/",testing[1:7, "positiveIncrease"], testing[1:7, "totalTestResultsIncrease"])[[1]])
tests2 = mean(testing[1:7, "positiveIncrease"][[1]])
pos2 = testing[1,"positive"]-testing[1,"recovered"]-testing[1,"death"]
myfile<- "https://covidtracking.com/api/v1/states/ks/daily.csv"
testing <- read_csv(myfile)
testing = filter(testing, testing$totalTestResultsIncrease >0)
testCap3 = mean(Map("/",testing[1:7, "positiveIncrease"], testing[1:7, "totalTestResultsIncrease"])[[1]])
tests3 = mean(testing[1:7, "positiveIncrease"][[1]])
pos3 = testing[1,"positive"]-testing[1,"recovered"]-testing[1,"death"]
installations = installations %>% mutate(Testing_Ratio = c(testCap1, testCap2, testCap3),Testing_Total = c(tests1, tests2, tests3) )
