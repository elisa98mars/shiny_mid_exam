library(shiny)
library(ggplot2)
library(plotly)
library(DT)

data <- read.csv("./Data/starb_data.csv")
select_values = colnames(data)


# Panels ------------------------------------------------------------------

intro_panel <- tabPanel(
  
    "Introduction",
    
    img(src="logo.png", height=350, width=950),
    
    p(),
    
    p("This app is going to perfom some analysis on a dataset composed of 
    a survey questions of over 100 respondents for their buying behavior 
    at Starbucks."),
    
    p("Income is show in Malaysian Ringgit (RM)"),
        
    p(a(href = "https://www.kaggle.com/mahirahmzh/starbucks-customer-retention-malaysia-survey", 
          "Data source")),
)


second_panel <- tabPanel(
    "Customer Data",
    titlePanel("Sturbucks Customers Data"),
    
    sidebarLayout( position = "right",
                   
        sidebarPanel(
          helpText("Create a histogram selecting the variable 
                   you want to display"),
          
            selectInput(
                "x_var",
                label = "Select a X variable:",
                choices = select_values[3:16],
                selected = "Age"
            ),
          
          textOutput("text"),
          verbatimTextOutput("legend"),
          
          br(),
          
          checkboxInput("gender_plot", "By gender"),
          
        ),
        
        mainPanel(plotOutput("customer_plot")) 
    ),
)


third_panel <- tabPanel("Data table", DT::dataTableOutput('raw_data'))

# Define UI ---------------------------------------------------------------

ui <- navbarPage(
    strong("Menu"),
    intro_panel,
    second_panel,
    third_panel
)


# Define Server -----------------------------------------------------------

server <- function(input, output) {
    output$customer_plot <- renderPlot({
      
      a <- ggplot(data, aes_string(x=input$x_var))
      
      if (input$gender_plot) {
        a + geom_histogram(aes(fill= Gender),
                           color= "black",
                           position = "dodge",
                           binwidth = 0.5)
      }
      else {
        a + geom_histogram(color = "darkgreen",
                           fill = "springgreen4",
                           binwidth = 0.5)
      }
    })
    
    output$text <- renderText(paste(input$x_var, "legend:"))
    
    output$legend <- renderText(
      if (input$x_var == "Status") {
        paste("0 = Student", "1 = Self-empolyed",
              "2 = Employed", "3 = Housewife", sep="\n")
      }
      else if (input$x_var == "Age") {
        paste("0 = Below 20", "1 = 20-29", 
              "2 = 30-39", "3 = 40 and above", sep="\n")
      }
      else if (input$x_var == "Income") {
        paste("0 = Less than 25,000 RM", "1 = 25,000 RM - 50,000 RM",
              "2 = 50,000 RM - 100,000 RM", "3 = 100,000 RM - 150,000 RM",
              "4 = More than 150,000 RM", sep="\n")
      }
      else if (input$x_var == "VisitNo") {
        paste("0 = Daily", "1 = Weekly", 
              "2 = Monthly", "3 = Never", sep="\n")
      }
      else if (input$x_var == "Method") {
        paste("0 = Dine-in", "1 = Drive-thru",
              "2 = Take-away", "3 = Never", "4 = Others",sep="\n")
      }
      else if (input$x_var == "MembershipCard") {
        paste("0 = Yes", "1 = No", sep="\n")
      }
      else if (input$x_var == "SpendPurchase") {
        paste("0 = Zero", "1 = Less than 20 RM", 
              "2 = 20 RM - 40 RM", "3 = More than 40 RM", sep="\n")
      }
      else {
        paste("Scaled 1-5", "1 = Very Bad", "5 = Excellent", sep="\n")
      }
    )
    
    output$raw_data <- DT::renderDataTable(
      DT::datatable(data, options = list(searching = F))
    )
}


# Run App -----------------------------------------------------------------

shinyApp(ui = ui, server = server)
