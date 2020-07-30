
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
                paste( "<b>",installations[installations$Name==input$inst,]$county,"</b>", "Population= ", "<b>",installations[installations$Name==input$inst,]$pop,
                       "</b>", " Population Density= ","<b>", installations[installations$Name==input$inst,]$dense,"</b>", "per square mile","<br>",
                  "<h2>", "Total Confirmed Cases: ",installations[installations$Name==input$inst,]$Total_Confirmed," (",
                  scales::percent(installations[installations$Name==input$inst,]$Total_Confirmed / installations[installations$Name==input$inst,]$pop),")"," </h2><br>", 
                  "<b>",scales::percent(installations[installations$Name== input$inst,]$Testing_Ratio),"</b>", "positive of", "<b>",
                      round(installations[installations$Name== input$inst,]$Testing_Total, 0),"</b>", "tests daily during the last seven days","<br>",
                      "<br>", "The WHO has suggested a positive rate of around","<b>"," 3-12%","</b>"," as a general benchmark of adequate testing.",
                  "<a href='https://www.who.int/docs/default-source/coronaviruse/transcripts/who-audio-emergencies-coronavirus-press-conference-full-30mar2020.pdf?sfvrsn=6b68bc4a_2'> 
                  COVID-19 - virtual press conference - 30 March 2020</a>",sep=" ")
                
              })
              
          
            })