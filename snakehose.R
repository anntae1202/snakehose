setwd("c:\\data\\mario")


install.packages("DT") # JavaScript 라이브러리
install.packages("shiny") # 샤이니 패키지 설치
install.packages("ggplot2")


library(DT)
library(shiny)
library(ggplot2)


packages <- c('imager', "shiny", "jpeg", "png", "reticulate", "devtools")


install.packages("tensorflow")
install.packages("keras")
install.packages("opencv")
library(opencv)
library(tensorflow)
library(keras)
install_tensorflow()
install_keras()

if (length(setdiff(packages, rownames(installed.packages()))) > 0) {
  install.packages(setdiff(packages, rownames(installed.packages())))  
}

if (length(setdiff("keras", rownames(installed.packages()))) > 0) {
  devtools::install_github("rstudio/keras") 
}

require(imager)
require(shiny)
require(jpeg)
require(png)
library(reticulate)
library(keras)



load("envir.RData")

model<<-load_model_hdf5("snake.h5")

synsets <<- readLines("synset.txt") 

server <- shinyServer(function(input, output) {
  ntext <- eventReactive(input$goButton, {
    print(input$url)
    if (input$url == "http://") {
      NULL
    } else {
      tmp_file <- tempfile()
      download.file(input$url, destfile = tmp_file, mode = 'wb')
      tmp_file
    }
  })
  
  output$originImage = renderImage({
    list(src = if (input$tabs == "Upload Image") {
      if (is.null(input$file1)) {
        if (input$goButton == 0 || is.null(ntext())) {
          'snake.jpg'  # test
        } else {
          ntext()
        }
      } else {
        input$file1$datapath
      }
    } else {
      if (input$goButton == 0 || is.null(ntext())) {
        if (is.null(input$file1)) {
          'snake.jpg'
        } else {
          input$file1$datapath
        }
      } else {
        ntext()
      }
    },
    title = "Original Image")
  }, deleteFile = FALSE)
  
  output$res <- renderText({
    src = if (input$tabs == "Upload Image") {
      if (is.null(input$file1)) {
        if (input$goButton == 0 || is.null(ntext())) {
          'snake.jpg'
        } else {
          ntext()
        }
      } else {
        input$file1$datapath
      }
    } else {
      if (input$goButton == 0 || is.null(ntext())) {
        if (is.null(input$file1)) {
          'snake.jpg'
        } else {
          input$file1$datapath
        }
      } else {
        ntext()
      }
    }
    
    img <- load.image(src)
    plot(img)
    img <- image_load(src, target_size = c(32,32))
    img
    x <- image_to_array(img)
    # ensure we have a 4d tensor with single element in the batch dimension,
    x <- array_reshape(x, c(1, dim(x)))
    
    # normalize
    x[,,,1] <- x[,,,1] /255.0
    x[,,,2] <- x[,,,2] /255.0
    x[,,,3] <- x[,,,3] /255.0
    
    # predcit
    preds <- model %>% predict(x)
    
    # output result as string
    
    order(preds[1,], decreasing = TRUE)
    max.idx <- order(preds[1,], decreasing = TRUE)[1]
    max.idx
    result <- synsets[max.idx]
    res_str <- ""
    tmp <- strsplit(result[1], " ")[[1]]
    res_str <- paste0(res_str, tmp[2])
    res_str
  })
})




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

shinyApp(ui = ui, server = server)