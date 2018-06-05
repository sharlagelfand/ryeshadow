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