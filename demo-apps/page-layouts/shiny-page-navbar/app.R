# this script creates an app demonstrating page_navbar

library(shiny)
library(bslib)

ui <- page_navbar(
  title = "Hello shiny",
  nav_panel(title = "Page One", p("First page content.")),
  nav_panel(title = "Page Two", p("Second page content.")),
  nav_panel(title = "Page Three", p("Third page content.")),
  nav_menu(
    title = "More",
    nav_panel(
      title = "About",
      p("We are a research group")
    ),
    nav_panel(
      title = "Software",
      p("We build a lot of software")
    )
  ),
  nav_spacer(),
  nav_menu(
    title = "Links",
    align = "right",
    nav_item(tags$a("MASHA", href = "https://science.uct.ac.za/masha")),
    nav_item(tags$a("Shiny", href = "https://shiny.posit.co"))
  )
)

server <- function(input, output, session) {
  
}

shinyApp(ui, server)
