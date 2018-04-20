source("components/collection.r")

navbarPage(
  title = "ryeshadow",
  tabPanel(
    "Randomizer",
    fluidPage(
      sidebarLayout(
        sidebarPanel(
          width = 3,
          numericInput("n_eyeshadows", label = "Number of eyeshadows:",
                       value = ""),
          
          radioButtons("type", label = "Choose from:",
                       choices = list("All eyeshadows",
                                      "Singles only", 
                                      "Specific palette(s)"
                       ),
                       selected = NULL),
          
          conditionalPanel(
            condition = "input.type == 'Specific palette(s)'",
            checkboxGroupInput("palette", "",
                               choices = palette_names)),
          
          actionButton("run", label = "Generate my palette!")
        ),
        
        mainPanel(
          imageOutput("my_palette")
        )
      )
    )
  ),
  tabPanel(
    "Tracking",
    fluidPage(
      sidebarLayout(
        sidebarPanel(
          width = 4,
          selectInput("brand", "Brand", 
                      choices = c('', unique(eyeshadows_df[["brand"]])),
                      selectize = TRUE),
          
          uiOutput("palette_selection"),
          uiOutput("shade_selection")
        ),
        mainPanel()
      )
    )
  )
)