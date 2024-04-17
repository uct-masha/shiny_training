# this script creates an app for demonstrating the layout_columns() function

library(shiny)
library(bslib)

# define the ui
ui <- page_fluid(
  title = "Hello Shiny",
  h1("Without layout_columns()"),
  numericInput(
    inputId = "population", 
    label = "Population size", 
    value = 10000
  ),
  sliderInput(
    inputId = "percent", 
    label = "Percentage", 
    value = 25, 
    post = "%",
    min = 0,
    max = 100
  ),
  sliderInput(
    inputId = "percent_range", 
    label = "Percent range", 
    value = c(10, 30), 
    post = "%",
    min = 0,
    max = 100
  ),
  h1("With layout_columns()"),
  layout_columns(
    numericInput(
      inputId = "population", 
      label = "Population size", 
      value = 10000
    ),
    sliderInput(
      inputId = "percent", 
      label = "Percentage", 
      value = 25, 
      post = "%",
      min = 0,
      max = 100
    ),
    sliderInput(
      inputId = "percent_range", 
      label = "Percent range", 
      value = c(10, 30), 
      post = "%",
      min = 0,
      max = 100
    )
  )
)

server <- function(input, output, session) {
  
}

shinyApp(ui, server)