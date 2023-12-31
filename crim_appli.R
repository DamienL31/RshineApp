source(file = "~/R/RshineApp/Packages.R")
source(file= "~/R/RshineApp/global.R")

#UI
ui <- fluidPage(
  tags$style(HTML("body {background-color: #e6f7ff;}")),
  titlePanel(strong("Los Angeles Crimes Application")),
  navlistPanel(
    "Widgets for Explore Data",
    # Accueil
    tabPanel("Home", icon = icon("home"),
             fluidRow(
               h2("Welcome to the Los Angeles Crimes Application", align = "center"),
               br(),
               p("Welcome to the Los Angeles Crimes app, a comprehensive tool for exploring crime data in the city of Los Angeles. 
                 This Shiny web application provides visualizations and analyses by LA districts to help users understand crime trends 
                 and variations over time and across districts.", align = "center"),
               br(),
               p(em("Select the tabs to access the various analyses.")),
               img(src = "police.jpg", alt = "Police Board", style = "max-width: 60%;"),
               br(),
               br(),
               br(),
               tags$a(href = "https://data.lacity.org/Public-Safety/Crime-Data-from-2020-to-Present/2nrs-mtv8/about_data",
                      "Click on the link to access data and further information", align = "center"),
                      p(em("This application is created by Lauger Damien", align = "center"))
              
             )),
    # Sommaire
    tabPanel("Summary", icon = icon("info"),
             actionButton("showSummary", "Show summary"),
             dataTableOutput("summaryTable")
    ),
    # Card
    tabPanel("District card", icon = icon("globe-americas"),
             selectInput("district_selector", "Select a district", choices = coordonnees$district),
             leafletOutput("carte")
    ),
    # TopcrimeTable
    tabPanel("Top 10 crimes", icon = icon("exclamation-circle"),
             tableOutput("topCrimesTable")
    ),
    # Topcrime District plot
    tabPanel("Top 10 crimes by district", icon = icon("bar-chart"),
             selectInput("district_type_crimes", "Select a district", choices = unique(data$area.name)),
             plotOutput("type_crimes_plot")
    ),
    # TopWeapons District plot
    tabPanel("Top 10 weapons by district", icon = icon("gun"),
             selectInput("district_type_weapons", "Select a district", choices = unique(data$area.name)),
             plotOutput("type_weapons_plot")
    ),
    # Topdesent district plot
    tabPanel("Victime ethnicity graph by district", icon = icon("user"),
             selectInput("district_selector_ethnie", "Select a district", choices = unique(data_ethnie$area.name)),
             plotOutput("ethnie_victime_plot")
    ),
    # Statistique 
    tabPanel("Statistics", icon = icon("calendar"),
             p(em("Please select a range between 2020-01-01 and 2023-10-30 to access the data")),
             dateRangeInput("daterange", label = "Select a date range",
                            start = min(data$date.occ), end = max(data$date.occ)),
             dataTableOutput("Statistics")
    )
  )
)

# Server
server <- function(input, output) {
  #Table sommaire
  output$summaryTable <- renderDataTable({
    head(data)
  })
  
  #Carte selon district choisit par user
  output$carte <- renderLeaflet({
    district_selected <- coordonnees[coordonnees$district == input$district_selector,]
    leaflet() %>%
      setView(lng = district_selected$longitude, lat = district_selected$lattitude, zoom = 10,5) %>%
      addTiles() %>%
      addMarkers(lng = district_selected$longitude, lat = district_selected$lattitude,
                 popup = input$district_selector)
  })
  #Table Top 10 crimes
  output$topCrimesTable <- renderTable({
    top_crimes
  })
  #Choix district affichage top10crimes
  output$type_crimes_plot <- renderPlot({
    filter_data <- data %>%
      filter(area.name == input$district_type_crimes)
    
    top_types_crime <- filter_data %>%
      group_by(crimes_description) %>%
      summarise(nbre_occurrences = n()) %>%
      top_n(10, nbre_occurrences)
    
    ggplot(top_types_crime, aes(x = reorder(crimes_description, -nbre_occurrences), y = nbre_occurrences)) +
      geom_bar(stat = "identity", fill = "forestgreen") +
      labs(title = paste("Top 10 Crime Types - District", input$district_selector_type_crimes),
           x = "Types crimes",
           y = "Nbre d'occurrences") +
      theme_minimal() +
      theme(axis.text.x = element_text(size = 6, angle = 55, hjust = 1))
  })
  #Choix district affichage top10 armes
  output$type_weapons_plot <- renderPlot({
    filter_data <- data %>%
      filter(area.name == input$district_type_weapons)
    
    top_weapons <- filter_data %>%
      group_by(weapons_description) %>%
      summarise(nbre_occurences = n()) %>%
      filter(!is.na(weapons_description) & weapons_description != "") %>%
      top_n(10, nbre_occurences)
    
    ggplot(top_weapons, aes(x = reorder(weapons_description, -nbre_occurences), y = nbre_occurences)) +
      geom_bar(stat = "identity", fill = "darkblue") +
      labs(title = paste("Top 10 Weapons - District", input$district_type_weapons),
           x = "Types d'armes",
           y = "Nbre d'occurrences") +
      theme_classic() +
      theme(axis.text.x = element_text(size = 5, angle = 55, hjust = 1, color = "darkblue"))
  })
  
  #Aggrégation data_ethnie + plot
  output$ethnie_victime_plot <- renderPlot({
    filter_data_ethnie <- data_ethnie %>%
      filter(area.name == input$district_selector_ethnie)
    
    ggplot(filter_data_ethnie, aes(x = vict.descent, y = nbre_victime, color = vict.sex)) +
      geom_point() +
      labs(title = paste("Scatter Plot somme des victimes par Ethni depuis 2020 - District", input$district_selector_ethnie),
           x = "Ethni",
           y = "Nombre de Victimes") +
      theme_light()
  })
  
  #Statistque nbre de crime et nbr ethni 
  output$Statistics <- renderDataTable({
    filtered_data <- data %>%
      filter(date.occ >= input$daterange[1], date.occ <= input$daterange[2])
    
    nbr_crimes <- filtered_data %>%
      group_by(area.name) %>%
      summarise(Nombre_de_crimes = n(),
                Moyenne_age = round(mean(vict.age, na.rm = TRUE),1))
    
  })
  
}
# Application
shinyApp(ui = ui, server = server)
