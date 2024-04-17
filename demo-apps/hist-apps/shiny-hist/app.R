# this script creates an app that generates a histogram from a random sample

library(shiny)
library(bslib)
library(tidyverse)

# define the ui
ui <- page_sidebar(
  title = "Sampling from the normal distribution",
  sidebar = sidebar(
    sliderInput(
      inputId = "number",
      label = "Number of observations",
      value = 1000,
      min = 100,
      max = 5000
    ),
    numericInput(
      inputId = "mean",
      label = "Mean",
      value = 50
    ),
    numericInput(
      inputId = "sd",
      label = "Standard deviation",
      value = 10
    ),
    sliderInput(
      inputId = "bins",
      label = "Number of bins",
      min = 1, 
      max = 50,
      value = 30
    )
  ),
  card(
    card_title("Histogram"),
    plotOutput("dist_plot")
  )
)

# Define server logic required to draw a histogram
server <- function(input, output, session) {
  
  # render the histogram to the output in the ui
  output$dist_plot <- renderPlot({
    
    samples <- rnorm(n = input$number, mean = input$mean, sd = input$sd)
    
    ggplot(data.frame(samples), aes(x = samples)) +
      geom_histogram(bins = input$bins, fill = "steelblue", color = "black") +
      labs(x = "Value", y = "Count") +
      theme_minimal()
  })
}

shinyApp(ui = ui, server = server)