# this script creates a shiny app for demonstrating the standard outputs

library(shiny)
library(bslib)

# define the ui
ui <- page_fluid(
  title = "Outputs",
  h1("Standard outputs"),
  layout_columns(
    card(
      card_title("Text"),
      textOutput("dimensions")
    ),
    card(
      card_title("Table"),
      tableOutput("table")
    ),
    card(
      card_title("Plot"),
      plotOutput("plot")
    ),
    col_widths = c(4, 4, 4)
  )
)

server <- function(input, output, session) {
  # text output
  output$dimensions <- renderText({
    paste(
      "The mtcars data frame has dimensions:",
      dim(mtcars)[[1]], 
      "rows and ",
      dim(mtcars)[[2]], 
      "columns."
    )
  })
  # table output
  output$table <- renderTable({
    head(mtcars[,1:5])
  })
  # plot output
  output$plot <- renderPlot({
    boxplot(
      formula = mtcars$mpg ~ mtcars$cyl,
      xlab = "Number of cylinders",
      ylab = "Miles per gallon"
    )
  })
}

shinyApp(ui, server)