function(input, output){
  randomizer_inputs <- eventReactive(input$randomizer_run, list(n = input$n_eyeshadows,
                                                                type = input$type,
                                                                palette = input$palette))
  
  output$my_palette <- renderImage({
    my_palette(n = randomizer_inputs()[["n"]],
               type = randomizer_inputs()[["type"]],
               palette = randomizer_inputs()[["palette"]])
  })
  
  brand_df <- reactive({
    eyeshadows_df %>%
      dplyr::filter(brand == input$brand)
  })
  
  palette_choices <- reactive({
    if(length(unique(brand_df()[["palette"]])) > 1){
      c('', unique(brand_df()[["palette"]]))
    }
    else {unique(brand_df()[["palette"]])}
  })
  
  output$palette_selection <- renderUI({
    selectInput("palette_wear", "Palette",
                choices = palette_choices(),
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
  
  shades_for_submission <- reactive({
    n_rep <- length(input$shade)
    
    data_frame(date = rep(ymd(input$tracking_date), n_rep),
               brand = rep(input$brand, n_rep),
               palette = rep(input$palette_wear, n_rep),
               shade = input$shade)
    
  })
  
  observeEvent(input$tracking_run, {
    add_shade(shades_for_submission())
  })
}