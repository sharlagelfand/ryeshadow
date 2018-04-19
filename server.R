source("components/palette_randomizer.r")

function(input, output){
  
  inputs <- eventReactive(input$run, list(n = input$n_eyeshadows,
                                          type = input$type,
                                          palette = input$palette))
  
  output$my_palette <- renderImage({
    my_palette(n = inputs()[["n"]],
               type = inputs()[["type"]],
               palette = inputs()[["palette"]])
  })
  
  brand_df <- reactive({
    eyeshadows_df %>%
      dplyr::filter(brand == input$brand)
  })
  
  output$palette_selection <- renderUI({
    selectInput("palette_wear", "Palette",
                choices = unique(brand_df()[["palette"]]),
                selectize = TRUE)
    
  })
  
  palette_df <- reactive({
    brand_df() %>%
      dplyr::filter(palette == input$palette_wear)
  })
  
  output$shade_selection <- renderUI({
    selectInput("shade", "Shade",
                choices = unique(palette_df()[["shade"]]),
                selectize = TRUE,
                multiple = TRUE)
  })
  
}