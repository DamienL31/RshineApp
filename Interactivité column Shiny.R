

ui <- fluidPage(
  titlePanel("Basic Widgets"),
  fluidRow(
    column(3,
           h3("Buttons"),
           actionButton("Action_button", "Action"),
           br(),
           br(),
           submitButton("Submit"),
           h3("Date Range"),
           dateRangeInput("daterange","",),
           h3("Radio Buttons"),
           radioButtons("radio_choice", label = NULL, choices = c("Choice 1", "Choice 2", "Choice 3"))
    ),
    
    # Deuxième colonne
    column(3,
           h3("Single Checkbox"),
           checkboxInput("Checkbox", "Choice A", TRUE),
           br(),
           br(),
           fileInput("fileInput", h3("File Input")),
           br(),
           br(),
           h3("Select Box"),
           selectInput("Select_box", label = NULL, choices = c("Choice 1"))
    ),
    
    # Troisième colonne
    column(3,
           h3("Checkbox Group"),
           checkboxGroupInput("Checkbox", label = NULL, choices = c("Choice 1", "Choice 2", "Choice 3")),
           h3("Help Text"),
           helpText("Note: Help text isn't a true widget, but it provides an easy way to add text to accompany other widgets"),
           h3("Sliders"),
           sliderInput("Slider1", "Slider 1", min = 0, max = 100, step = 10, value = 50),
           sliderInput("Slider2", "Slider 2", min = 0, max = 100, step = 10, value = c(25, 75))
    ),
    
    # Quatrième colonne
    column(3,
           h3("Date Input"),
           dateInput("date2", "Date:"),
           h3("Numeric Input"),
           numericInput("num","",1),
           h3("Text Input"),
           textInput("text","","Enter text...")
    )
  )
)

server <- function(input, output) {
  # Your server logic goes here
}

shinyApp(ui = ui, server = server)
