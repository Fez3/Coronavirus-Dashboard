
shinyServer(
            
            function(input, output, session) {
              
             
             
               
               
              # v <- reactiveValues(clicker=FALSE)
              output$map <- renderLeaflet({
                
               
                map= leaflet(data = installations) %>% setView(-96, 37.8, 4) %>% addTiles() %>% addMarkers(., ~lng, ~lat)
               
                return(map)
                   
                
              })
              observeEvent(input$inst, {
                loc <- installations[installations$Name == input$inst,]
                proxy <- leafletProxy("map")
                proxy %>% setView(loc$lng, loc$lat, 15 )
                
                
              }, ignoreInit = TRUE)
              output$tstCR <- renderText({ 
                paste( "<b>",installations[installations$Name==input$inst,]$county,"</b>",
                       "Population= ", "<b>",format(installations[installations$Name==input$inst,]$pop, big.mark=","),
                       "</b>", " Population Density= ","<b>", installations[installations$Name==input$inst,]$dense,"</b>", "per square mile","<br>",
                  "<h2>", "Current Confirmed Cases: ",format(installations[installations$Name==input$inst,]$Total_Confirmed,big.mark=",")," (",
                  scales::percent(installations[installations$Name==input$inst,]$Total_Confirmed / installations[installations$Name==input$inst,]$pop),")"," </h2><br>", 
                  "<b>",scales::percent(installations[installations$Name== input$inst,]$Testing_Ratio),"</b>", "positive of", "<b>",
                      round(installations[installations$Name== input$inst,]$Testing_Total, 0),"</b>", "tests daily during the last seven days in",
                  installations[installations$Name==input$inst2,]$state,
                   "<br>", "<br>", "The WHO has suggested a positive rate of around","<b>"," 3-12%","</b>"," as a general benchmark of adequate testing.",
                  "<a href='https://www.who.int/docs/default-source/coronaviruse/transcripts/who-audio-emergencies-coronavirus-press-conference-full-30mar2020.pdf?sfvrsn=6b68bc4a_2'> 
                  COVID-19 - virtual press conference - 30 March 2020</a>",sep=" ")
                
              })
            
              output$timeline=renderPlot({
                confirmedT = confirmed[confirmed$Combined_Key==installations[installations$Name==input$inst2,]$county,]
                ggplot(confirmedT, aes(x=Date)) + 
                  geom_line(aes(y=Active_Cases, col="red")) + 
                  geom_line(aes(y=Resolved_Cases, col="blue"))+
                  labs(title=paste("Time Series of Covid-19 Cases for", installations[installations$Name==input$inst2,]$county, sep=" "),
                       subtitle="No data on recoveries, mean time to resolution of 21 days is used", 
                       caption="Source: Economics", 
                       y="Covid-19 Cases", 
                       color=NULL) +scale_color_manual(labels = c("Resolved", "Active"), 
                                                       values = c( "#0339fc","#fc0313"))
              })
              
              output$info=renderText({
                paste(
                "According to the CDC, <b> 88% - 95% </b> of coronavirus cases are no longer communicable after
                             15-20 days, and the mean time of death for fatal cases is between <b> 10 </b> and <b> 19 </b> days following
                             the onset of symptoms. Mild cases typically resolve in two weeks and severe cases resolve after 3-6 weeks
                             <a href='https://www.cdc.gov/coronavirus/2019-ncov/hcp/duration-isolation.html'> CDC </a> <br> <br>
                The current hospital capacity for ", installations[installations$Name==input$inst2,]$county, " is <b>", 
                installations[installations$Name==input$inst2,]$Beds, "</b> beds total, <b>", 
                round(1000 * installations[installations$Name==input$inst2,]$Beds/installations[installations$Name==input$inst2,]$pop,1), 
                "</b> beds per 1,000 people. The average number of beds per 1,000 people in the USA is ordinarily <b> 2.9 </b> 
                ( <a href='https://data.worldbank.org/indicator/SH.MED.BEDS.ZS'> The World Bank </a>)", 
                " The WHO does not have a standard in place at this time (<a href='https://www.who.int/data/gho/indicator-metadata-registry/imr-details/3119'> link </a>). ",
                "<br>", "<br>",
                "Whitehouse reopening criteria call for a 14-day downward trajectory in new coronavirus cases. <a href='https://www.whitehouse.gov/openingamerica/'> whitehouse.gov<a>",
                
                sep="")
              })
  
          
            })