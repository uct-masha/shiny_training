# An app to provide the user interface and facilitate the use of a basic malaria model

# load libraries
library(shiny)
library(bslib)
library(deSolve)
library(tidyverse)
library(plotly)
library(reactable)

# source the model script


# Define the ui ----
ui <- page_sidebar(
  title = "Basic Malaria App",
  # side bar ----
  sidebar = sidebar(
    title = "Model Inputs",
    width = 300,
    accordion(
      open = FALSE,
      accordion_panel(
        title = "Human Parameters",
        icon = fontawesome::fa("person"),
        sliderInput(
          inputId = "birth_rate_human",
          label = "Human birth rate",
          value = 0.02,
          min = 0,
          max = 1
        ),
        sliderInput(
          inputId = "death_rate_human",
          label = "Human death rate",
          value = 0.02,
          min = 0,
          max = 1
        ),
        numericInput(
          inputId = "beta_human",
          label = "Human transmission parameter",
          value = 18
        ),
        numericInput(
          inputId = "gamma_human",
          label = "Human recovery rate",
          value = round(365.25 / 180)
        )
      ),
      accordion_panel(
        title = "Mosquito Parameters",
        icon = fontawesome::fa("mosquito"),
        sliderInput(
          inputId = "birth_rate_mosquito",
          label = "Mosquito birth rate",
          value = 2,
          min = 1,
          max = 5
        ),
        sliderInput(
          inputId = "death_rate_mosquito",
          label = "Mosquito death rate",
          value = 2,
          min = 1,
          max = 5
        ),
        numericInput(
          inputId = "beta_mosquito",
          label = "Mosquito transmission parameter",
          value = 1
        )
      ),
      accordion_panel(
        title = "Initial Conditions",
        icon = fontawesome::fa("network-wired"),
        numericInput(
          inputId = "susceptible_humans",
          label = "Susceptible humans",
          value = 10000
        ),
        numericInput(
          inputId = "infectious_humans",
          label = "Infectious humans",
          value = 100
        ),
        numericInput(
          inputId = "recovered_humans",
          label = "Recovered humans",
          value = 0
        ),
        numericInput(
          inputId = "susceptible_mosquitoes",
          label = "Susceptible Mosquitoes",
          value = 10000
        ),
        numericInput(
          inputId = "infectious_mosquitoes",
          label = "Infectious Mosquitoes",
          value = 100
        )
      )
    ),
    actionButton(
      inputId = "run_model",
      label = "Run model"
    )
  ),
  # main panel ----
  navset_card_underline(
    title = "Model Results",
    nav_panel(
      title = "Plots",
      plotlyOutput("model_plot")
    ),
    nav_panel(
      title = "Raw results",
      reactableOutput("raw_results")
    )
  )
) 

# define the server function ----
server <- function(input, output, session) {
  
  # reactive to store the model output ----
  model_output <- eventReactive(input$run_model, ignoreNULL=FALSE, {
    
    # make an initial conditions vector using a function defined in the model.R script
    initial_conditions <- 
    
    # make a parameters vector using a function defined in the model.R script
    parameters <- 
    
    # run the model using the run_model function defined in the model.R script
    model_output <- 
  })
  
  # render the model output plot ----
  output$model_plot <- renderPlotly({
    
    # create a ggplot object
    plt <- ggplot(model_output()) +
      aes(x = time, y = population, color = compartment) +
      geom_line() +
      theme_minimal() +
      scale_x_continuous(breaks = seq(2015, 2025, 2)) +
      labs(
        title = "Compartmental Model",
        color = "Compartment",
        x = "Time",
        y = "Population"
      )
    
    # convert the ggplot object to a plotly object
    ggplotly(plt)
      
  })
  
  # render the raw results table ----
  output$raw_results <- renderReactable({
    model_output() %>% 
      reactable(
        defaultPageSize = 15,
        highlight = TRUE,
        columns = list(
          time = colDef(
            name = "Time", 
            format = colFormat(digits = 2)
          ),
          compartment = colDef(
            name = "Compartment"
          ),
          population = colDef(
            name = "Population", 
            format = colFormat(digits = 0, separators = TRUE)
          )
        )
      )
  })
  
}

shinyApp(ui = ui, server = server)