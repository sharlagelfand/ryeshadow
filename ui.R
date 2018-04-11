palettes <- dir_ls("pans/palettes/", recursive = TRUE, type = "directory")
palettes <- palettes[str_count(palettes, "/") == 3] # only keep directories 3 levels deep, i.e. actual palettes not just brand folders

palettes_df <- data_frame(palette_path = palettes) %>%
  separate(palette_path, into = c("path", "type", "brand", "palette"), sep = "/", remove = FALSE)

palette_names <- str_replace_all(palettes_df[["palette"]],
                                 "-",
                                 " ")

fluidPage(
  titlePanel("Eyeshadow palette generator"),
  
  sidebarLayout(
    sidebarPanel(
      width = 4,
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