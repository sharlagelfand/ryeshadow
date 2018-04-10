library(shiny)

fluidPage(
  titlePanel("Eyeshadow palette generator"),
  
  sidebarLayout(
    sidebarPanel(
      width = 3,
      numericInput("n_eyeshadows", label = "Number of eyeshadows:",
                   value = ""),
      
      radioButtons("type", label = "Choose from:",
                   choices = list("All eyeshadows",
                                  "Singles only", 
                                  "Palettes only"
                   ),
                   selected = NULL),
      
      actionButton("run", label = "Generate my palette!")
    ),
    
    mainPanel(
      imageOutput("my_palette")
    )
  )
)