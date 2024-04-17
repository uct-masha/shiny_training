# An app to provide the user interface and facilitate the use of a basic malaria model

# load libraries
library(shiny)
library(bslib)
library(deSolve)
library(tidyverse)

# Define the ui ----
ui <- page_sidebar(
  title = "Basic Malaria App",
  # side bar ----
  sidebar = sidebar(
    title = "Model Inputs",
    width = 300,
    
    strong("Human Parameters"),
    
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
    ),
    
    strong("Mosquito Parameters"),
    
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
    ),
    
    strong("Initial Conditions"),
    
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
    
  ),
  # main panel ----
  card(
    card_title("Model Results"),
    plotOutput("model_plot")
  )
) 

# define the server function ----
server <- function(input, output, session) {
  
  # reactive to store the model output ----
  model_output <- reactive({
    # function to return the rates
    rates <- function(t, y, parms) {
      with(as.list(c(y, parms)), {
        poph <- Sh + Ih + Rh
        popm <- Sm + Im
        
        lambda_h <- beta_h * Im / poph 
        lambda_m <- beta_m * Ih / poph
        
        dSh <- mub_h * poph - (lambda_h + mud_h) * Sh
        dIh <- lambda_h * Sh - (gamma_h + mud_h) * Ih
        dRh <- gamma_h * Ih - mud_h * Rh
        
        dSm <- mub_m * popm - (lambda_m + mud_m) * Sm
        dIm <- lambda_m * Sm - mud_m * Im
        
        return(list(c(dSh, dIh, dRh, dSm, dIm)))
      })
    }
    # initial conditions
    initial_conditions <- c(
      Sh = 10000,
      Ih = 100,
      Rh = 0,
      Sm = 10000,
      Im = 100
    )
    
    # parameters
    parameters <- c(
      mub_h = 0.02,
      mud_h = 0.02,
      beta_h = 18,
      gamma_h = 365.25 / 180,
      mub_m = 2,
      mud_m = 2,
      beta_m = 1
    )
    
    # time steps
    timesteps <- seq(2015, 2025, 1 / 365)
    
    compartment_names <- names(initial_conditions)
    results <- ode(y = initial_conditions, times = timesteps, func = rates, parms = parameters) %>% 
      as.data.frame() %>% 
      pivot_longer(
        cols = !time, names_to = "compartment", values_to = "population",
        names_transform = ~ factor(.x, levels = compartment_names)
      )
  })
  
  
  # render the model output plot ----
  output$model_plot <- renderPlot({
    
    # create a ggplot plot
    ggplot(model_output()) +
      aes(x = time, y = population, color = compartment) +
      geom_line() +
      theme_minimal() +
      scale_x_continuous(breaks = seq(2015, 2025, 2)) +
      labs(
        color = "Compartment",
        x = "Time",
        y = "Population"
      )
      
  })

}

shinyApp(ui = ui, server = server)