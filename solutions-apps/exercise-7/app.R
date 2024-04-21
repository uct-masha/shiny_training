# An app to provide the user interface and facilitate the use of a basic malaria model

# load libraries
library(shiny)
library(bslib)
library(deSolve)
library(tidyverse)
library(plotly)
library(reactable)

# source the model script
source("model.R")

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
        title = "Variables",
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
    ),
    nav_panel(
      title = "Downloads",
      p(
        "You can download both the raw model results in a CSV file and an html report."
      ),
      layout_columns(
        downloadButton(
          outputId = "raw_model_results",
          label = "Download results"
        ),
        downloadButton(
          outputId = "report",
          label = "Download report"
        ),
        col_widths = c(6, 6)
      )
    )
  )
) 

# define the server function ----
server <- function(input, output, session) {
  
  # reactive to store the model output ----
  model_output <- eventReactive(input$run_model, ignoreNULL=FALSE, {
    
    # make an initial conditions vector using a function defined in the model.R script
    initial_conditions <- makeinitial_conditions(
      Sh = input$susceptible_humans,
      Ih = input$infectious_humans,
      Rh = input$recovered_humans,
      Sm = input$susceptible_mosquitoes,
      Im = input$infectious_mosquitoes
    )
    
    # make a parameters vector using a function defined in the model.R script
    parameters <- make_parameters(
      mub_h = input$birth_rate_human,
      mud_h = input$death_rate_human,
      beta_h = input$beta_human,
      gamma_h = input$gamma_human,
      mub_m = input$birth_rate_mosquito,
      mud_m = input$death_rate_mosquito,
      beta_m = input$beta_mosquito
    )
    
    # run the model using the run_model function defined in the model.R script
    model_output <- run_model(timesteps, initial_conditions, make_parameters(beta_h=18))
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
          time = colDef(name = "Time", format = colFormat(digits = 2)),
          compartment = colDef(name = "Compartment"),
          population = colDef(
            name = "Population", 
            format = colFormat(digits = 0, separators = TRUE)
          )
        )
      )
  })
  
  # download csv of results
  output$raw_model_results <- downloadHandler(
    filename = function() {
      paste("model_output -", Sys.Date(), ".csv")
    },
    content = function(file) {
      write_csv(model_output(), file)
    }
  )
  
  # download html report of the results
  output$report <- downloadHandler(
    # for a PDF report we would have "report.pdf"
    filename = "report.html",
    content = function(file) {
      # Copy the report file to a temporary directory before processing it,
      # in case we don't have write permissions to the current working directory
      temp_report <- file.path(tempdir(), "report.Rmd")
      file.copy("report.Rmd", temp_report, overwrite = TRUE)
      
      # Set up parameters to pass to Rmd document
      params <- list(
        birth_rate_human = input$birth_rate_human,
        death_rate_human = input$death_rate_human,
        beta_human = input$beta_human,
        gamma_human = input$gamma_human,
        birth_rate_mosquito = input$birth_rate_mosquito,
        death_rate_mosquito = input$death_rate_mosquito,
        beta_mosquito = input$beta_mosquito,
        susceptible_humans = input$susceptible_humans,
        infectious_humans = input$infectious_humans,
        recovered_humans = input$recovered_humans,
        susceptible_mosquitoes = input$susceptible_mosquitoes,
        infectious_mosquitoes = input$infectious_mosquitoes,
        model_output = model_output()
      )
      
      # Knit the document, passing in the `params` list, and eval it in a
      # child of the global environment (this isolates the code in the document
      # from the code in this app).
      rmarkdown::render(temp_report, output_file = file,
                        params = params,
                        envir = new.env(parent = globalenv())
      )
    }
  )
}

shinyApp(ui = ui, server = server)