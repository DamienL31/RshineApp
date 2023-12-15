# install.packages("questionr")


library(questionr)
data("hdv2003")
library(shiny)

library(shiny)
library(dplyr)

library(shiny)
library(dplyr)  # Make sure to load the dplyr library if you are using filter()

ui <- fluidPage(
  titlePanel("HDV2003 "),
  sidebarLayout(
    sidebarPanel(
    ),
    mainPanel(
      tableOutput("renvoi_donne")
    )
  )
)

server <- function(input, output) {
  
  output$renvoi_donne <- renderTable({
    head(hdv2003)
  })}
  
  


shinyApp(ui = ui, server = server)
