source("components/palette_randomizer.r")

function(input, output){
  
  inputs <- eventReactive(input$run, list(n = input$n_eyeshadows,
                                          type = input$type,
                                          palette = input$palette))
  
  output$my_palette <- renderImage({my_palette(n = inputs()[["n"]],
                                               type = inputs()[["type"]],
                                               palette = inputs()[["palette"]])
  })
}