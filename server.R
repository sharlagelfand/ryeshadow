function(input, output){
  
  inputs <- eventReactive(input$run, list(n = input$n_eyeshadows,
                                          type = input$type,
                                          palette = input$palette))
  
  output$my_palette <- renderImage({
    
    n <- inputs()[["n"]]
    type <- inputs()[["type"]]
    palette <- inputs()[["palette"]]
    
    n_row <- floor(sqrt(n))
    n_col <- ceiling(n/n_row)
    
    path_folder <- case_when(type == "All eyeshadows" ~ "",
                             type == "Singles only" ~ "singles/",
                             type == "Specific palette(s)" ~ "palettes/")
    
    pans_sample <- dir_ls(paste0("pans/", path_folder), recursive = TRUE, glob = "*.png")
    
    if(type == "Specific palette(s)"){
      pans_sample <- pans_sample[str_detect(pans_sample, paste(paste0(str_replace_all(palette, " ", "-"), "/"), collapse = "|"))]
    }
    
    pans_sample <- pans_sample %>%
      sample(size = n, replace = TRUE*(n > length(pans_sample)))

    pan_paths <- split(pans_sample, rep(1:n, each = 1))
    pan_paths_df <- data_frame(id = 1:n,
                               path =as.character(pan_paths))
    
    read_append <- . %>%
      magick::image_read() %>%
      magick::image_append()
    
    images <- purrr::map(pan_paths, read_append)
    
    info <- magick::image_read(pans_sample[1]) %>%
      magick::image_info()
    
    height <- info$height
    width <- info$width
    
    eyeshadows_df <- data_frame(id = 1:n,
                                row = rep(1:n_row, each = n_col)[1:n],
                                col = rep(1:n_col, times = n_row)[1:n]) %>%
      mutate(image_x_offset = 60*col + width*(col - 1),
             image_y_offset = 60*row+ height*(row - 1)) %>%
      left_join(pan_paths_df, by = "id") %>%
      mutate(path = str_replace_all(path, "-", " ")) %>%
      separate(path, into = c("folder", "type", "brand", "palette", "shade"), sep = "/") %>%
      mutate(shade = str_replace(shade, ".png", "")) %>%
      mutate(brand_y_offset = image_y_offset + height + 5,
             palette_y_offset = brand_y_offset + 15,
             shade_y_offset = palette_y_offset + 15)
    
    my_palette <- magick::image_blank(width = width*n_col + 60*(n_col + 1),
                                      height = height*n_row + 60*(n_row + 1),
                                      col = "#000000")
    
    for(i in 1:length(images)){
      image_offset <- paste0("+", eyeshadows_df[i, "image_x_offset"], "+", eyeshadows_df[i, "image_y_offset"])
      brand_offset <- paste0("+", eyeshadows_df[i, "image_x_offset"], "+", eyeshadows_df[i, "brand_y_offset"])
      palette_offset <- paste0("+", eyeshadows_df[i, "image_x_offset"], "+", eyeshadows_df[i, "palette_y_offset"])
      shade_offset <- paste0("+", eyeshadows_df[i, "image_x_offset"], "+", eyeshadows_df[i, "shade_y_offset"])
      
      my_palette <- image_composite(my_palette, images[[i]], offset = image_offset)
      my_palette <- image_annotate(my_palette, eyeshadows_df[i, "brand"] %>% unlist(), size = 15,
                                   color = "white", 
                                   location = brand_offset)
      my_palette <- image_annotate(my_palette, eyeshadows_df[i, "palette"] %>% unlist(), size = 15,
                                   color = "white", 
                                   location = palette_offset)
      my_palette <- image_annotate(my_palette, eyeshadows_df[i, "shade"] %>% unlist(), size = 15,
                                   color = "white", 
                                   location = shade_offset)
    }
    
    my_palette <- my_palette %>%
      image_write(tempfile(fileext='jpg'), format = 'jpg')
    
    # Return a list
    list(src = my_palette, contentType = "image/jpeg")
  }
  )
}