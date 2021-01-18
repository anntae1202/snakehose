

require(imager)
require(shiny)
require(jpeg)
require(png)

ui <- shinyUI(
  fluidPage(
    includeCSS("bootstrap.css"),
    
    pageWithSidebar(
      headerPanel(title = 'Image classificaiton using DenseNet',
                  windowTitle = 'Image Classification using DenseNet'),
      
      fluidRow(
        column(1),
        column(9,
               tabsetPanel(
                 id = "tabs",
                 tabPanel("Upload Image",
                          fileInput('file1', 'Upload a PNG / JPEG File:')),
                 tabPanel(
                   "Use the URL",
                   textInput("url", "Image URL:", "http://"),
                   actionButton("goButton", "Go!")
                 )
               ),
               h3(titlePanel("Snake Vs Hose")),
               h3(titlePanel("Image Classification"))
               
        ),
        column(2)
      ),
      
      
      mainPanel(
        h3("Image"),
        tags$hr(),
        imageOutput("originImage", height = "auto"),
        tags$hr(),
        h3("What is this?"),
        tags$hr(),
        verbatimTextOutput("res")
      )
      
      
    )))