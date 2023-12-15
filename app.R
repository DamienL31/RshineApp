
ui <- fluidPage(
  titlePanel("My Shiny App"),
  sidebarLayout(
    sidebarPanel(
      h1("Installation"),
      br(),
      p("Shiny is available on CRAN, so you can install it in the usual way from your R consol :"),
      br(),
      code("install.packages('shiny')"),
      br(),
      br(),
      img(src="rstudio.png", alt = "Description de l'image", height = 80, width = 190), 
      p("Shiny is a product of", a(href = "https://www.r-studio.com", "Rstudio")),
      
      
    ),
    mainPanel(
      h1("Introducing Shiny"),
      br(),
      p("Shiny is a new package from RStudio that makes it", em("incredibly easy"),"to build interactive web applications with R"),
      br(),
      br(),
      p("For an introduction and live examples, visit the", a(href = "https://shiny.posit.co", "Shiny homepage")),
      br(),
      h2("Features"),
      p(" - Build useful web applications with only a few lines of code - no JavaScript required."),
      p(" - Shiny applications are automatically 'live' in the same way that", strong("spreadsheets"),"are live. Outputs change instlantly as users modify inputs, without requiring a reload of the browser.")
      
    )
  ) 
)



server <- function(input, output){
  
}

shinyApp(ui = ui, server = server)