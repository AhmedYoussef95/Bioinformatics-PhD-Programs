library(shiny)
library(leaflet)
library(maps)
library(readxl)
library(scales)
library(DT)

appData <- read_excel("./app data.xlsx")
appData$Deadline <- format(appData$Deadline, "%b %d") #e.g. Dec 15

ui <- fluidPage(
  
  titlePanel("Bioinformatics PhD Programs in the US"),
  
  mainPanel(width="100%",
            tabsetPanel(
              tabPanel("Map",leafletOutput("map",  height = 600)),
              tabPanel("Table",dataTableOutput("table"))
            ),
            helpText(p(em('©️ Ahmed Youssef'))),
            tags$div(class="header", checked=NA,
                     tags$a(href="https://github.com/AhmedYoussef95/Bioinformatics-PhD-Programs", "Source Code")
            )
  )
)

server <- function(input, output) {
  
  output$map <- renderLeaflet({
    mapStates = map("state", fill = TRUE, plot = FALSE)
    popupText <- vector(length = length(appData$University))
    for(i in 1 : length(popupText)){
      popupText[i] <- paste(
        p(a(appData$University[i], href = appData$Website[i])),
        p(strong("Program:"), appData$Program[i]), 
        p(strong("Deadline:"), appData$Deadline[i]),
        p(strong("App Fee:"), dollar(appData$`App Fee`)[i]),
        p(strong("State:"), appData$Location[i]),
        p(strong("US News Ranking:"), appData$`US News Ranking (2018)`[i])
      )
    }
    
    m <- leaflet(data = mapStates, options = leafletOptions(minZoom = 4, maxZoom = 18)) %>%
      addTiles() %>% 
      addMarkers(lng = appData$Longitude, lat = appData$Latitude, label = appData$University, popup = popupText, 
                 icon = makeIcon(iconUrl = 'http://www.mcm-copyrent.com/wp-content/uploads/2013/03/blue-pin-hi.png', iconWidth = 20, iconHeight = 30)) %>%
      addPolygons(fillColor = topo.colors(10, alpha = NULL), stroke = F)
  })
  
  output$table <- renderDataTable({
    names(appData)[4] <- "App Fee ($)"
    appData$University = paste0("<a href='",appData$Website,"'>",appData$University,"</a>")
    DT::datatable(appData[,1:7], escape = F)
  })
  
}

shinyApp(ui = ui, server = server)
