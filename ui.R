
 
shinyUI(dashboardPage(skin = "green",
  dashboardHeader(title = "Installation Report"),
  
  dashboardSidebar(
    Title="Direct questions or issues to", br(), 
    img(src="userimage.jpg", width=50,height = 50, align="center"), 
    subtitle = a(href = "mailto:aaron.festinger@gmail.com", "Aaron Festinger"),
                   
    
        sidebarMenu( 
              
          menuItem("Current Covid-19 Situation", tabName = "map", icon = icon("map")),
          #menuItem("Data", tabName = "data", icon = icon("database")),
          #menuItem("State by State", tabName = "statedata", icon = icon("database")),
          menuItem("Historical Trend", tabName = "hmap", icon = icon("database"))                          
                                    )
      
                                    ),
 
   dashboardBody(
   
    tabItems(
      tabItem(tabName = "map",
              leafletOutput("map"),box(
                selectizeInput(inputId = "inst",label = "Installation",choices = installations$Name)),
  
      box(
        htmlOutput("tstCR"))),
      
      
      tabItem(tabName= "hmap",box(plotOutput("timeline"),selectizeInput(inputId = "inst2",label = "Installation",choices = installations$Name)),
              box(htmlOutput("info")))
)
 
)
)
)

