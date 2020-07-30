
 
shinyUI(dashboardPage(skin = "green",
  dashboardHeader(title = "Installations"),
  
  dashboardSidebar(Title="Aaron Festinger", br(), 
                   img(src="A.jpg", width=100,height = 100, align="center"),
    
        sidebarMenu(
              
          menuItem("Map", tabName = "map", icon = icon("map")),
          #menuItem("Data", tabName = "data", icon = icon("database")),
          #menuItem("State by State", tabName = "statedata", icon = icon("database")),
          menuItem("Geographic Spread", tabName = "hmap", icon = icon("database"))                          
                                    )
                                    ),
 
   dashboardBody(
   
    tabItems(
      tabItem(tabName = "map",
              leafletOutput("map"),box(
                selectizeInput(inputId = "inst",label = "Installation",choices = installations$Name)),
  
      box(
        htmlOutput("tstCR"))),
      
      
      tabItem(tabName = "hmap", box(tags$iframe(src="https://www.youtube.com/embed/dQw4w9WgXcQ",width="600",height="400") )
)
 
)
)
)
)
