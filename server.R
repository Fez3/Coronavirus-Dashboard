
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
                paste(scales::percent(installations[installations$Name== input$inst,]$Testing_Ratio), "positive of",
                      installations[installations$Name== input$inst,]$Testing_Total, "tests daily during the last seven days", sep=" ")
                
              })
              
          
            })