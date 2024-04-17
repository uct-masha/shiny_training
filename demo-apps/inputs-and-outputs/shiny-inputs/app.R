# this script creates a shiny app used to demonstrate shiny's input controls

library(shiny)
library(bslib)

ui <- page_fluid(
  title = "Inputs",
  h1("Standard inputs"),
  layout_columns(
    card(
      card_title("Numeric Inputs"),
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
    ),
    card(
      card_title("Dates"),
      dateInput(
        inputId = "report_date",
        label = "Select report date"
      ),
      dateRangeInput(
        inputId = "date_range",
        label = "Reporting period"
      )
    )
  ),
  layout_columns(
    card(
      card_title("Limited choices"),
      selectInput(
        inputId = "continent",
        label = "Select continent",
        choices = c("Africa", "Asia", "Europe", "Other")
      ),
      radioButtons(
        inputId = "coding_language",
        label = "Select a language you use",
        choices = c("R", "Python", "Julia")
      )
    ),
    card(
      card_title("Action buttons"),
      actionButton(
        inputId = "run",
        label = "Click to run model"
      ),
      actionButton(
        inputId = "calibrate",
        label = "Click to calibrate",
        icon = icon("play")
      ),
      actionLink(
        inputId = "more",
        label = "Click for more"
      )
    )
  ),
  layout_columns(
    card(
      card_title("Free text"),
      textInput(
        inputId = "name",
        label = "Please type your name"
      ),
      textAreaInput(
        inputId = "notes",
        label = "Write detailed notes about your observation",
        rows = 5
      )
    ),
    card(
      card_title("File uploads"),
      fileInput(
        inputId = "upload_file",
        label = "Please upload csv file"
      )
    )
  )
)

server <- function(input, output, session) {
  
}

shinyApp(ui, server)