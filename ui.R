# generating list of palettes to use in UI
pans <- dir_ls("pans/", recursive = TRUE, glob = "*.png")

eyeshadows_df <- data_frame(path = pans) %>%
  separate(path,
           into = c("folder", "type", "brand", "palette", "shade"),
           sep = "/",
           remove = FALSE) %>%
  mutate_at(vars(brand:shade), funs(str_replace_all(., "-", " "))) %>%
  mutate(shade = str_replace(shade, ".png", "")) 

palette_names <- unique((eyeshadows_df %>%
                           filter(type == "palettes"))[["palette"]])

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
                      choices = unique(eyeshadows_df[["brand"]]),
                      selectize = TRUE),
          
          uiOutput("palette_selection"),
          uiOutput("shade_selection")
        ),
        mainPanel()
      )
    )
  )
)