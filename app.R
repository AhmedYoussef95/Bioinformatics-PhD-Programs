library(shiny)
library(leaflet)
library(maps)
library(readxl)
library(scales)

appData <- read_excel("./app data.xlsx")
appData$Deadline <- format(appData$Deadline, "%b %d") #e.g. Dec 15

ui <- fluidPage(
  
  titlePanel("Bioinformatics PhD Programs in the US"),
  
  mainPanel(width="100%",
            tabsetPanel(
              tabPanel("Map",leafletOutput("map",  height = 600)),
              tabPanel("Table",dataTableOutput("table"))
            )
  )
)

server <- function(input, output) {
  
  output$map <- renderLeaflet({
    mapStates = map("state", fill = TRUE, plot = FALSE)
    popupText <- vector(length = length(appData$University))
    for(i in 1 : length(popupText)){
      popupText[i] <- paste(
        p(a(appData$University[i], href = appData$URL[i])),
        p(strong("Program:"), appData$Program[i]), 
        p(strong("Deadline:"), appData$Deadline[i]),
        p(strong("App Fee:"), dollar(appData$`App Fee`)[i]),
        p(strong("State:"), appData$Location[i]),
        p(strong("US News Ranking:"), appData$`US News Ranking`[i])
      )
    }
    
    m <- leaflet(data = mapStates, options = leafletOptions(minZoom = 4, maxZoom = 18)) %>%
      addTiles() %>% 
      addMarkers(lng = appData$Longitude, lat = appData$Latitude, label = appData$University, popup = popupText) %>%
      addPolygons(fillColor = topo.colors(10, alpha = NULL), stroke = F)
  })
  
  output$table <- renderDataTable({
    names(appData)[4] <- "App Fee ($)"
    appData[,1:7]
  })
  
}

shinyApp(ui = ui, server = server)
