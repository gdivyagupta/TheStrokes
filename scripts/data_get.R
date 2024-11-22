install.packages("spotifyr")
install.packages("usethis")

usethis::edit_r_environ()
# Load required packages
library(spotifyr)
library(ggplot2)
library(dplyr)
library(usethis)

# Authenticate using credentials from .Renviron
access_token <- get_spotify_access_token()
print(access_token)
# Get The Strokes' albums
strokes_albums <- get_artist_albums("0epOFNiUfyON9EYx7Tpr6V", include_groups = "album")
print(strokes_albums)

# Fetch tracks for all The Strokes' albums
strokes_tracks <- strokes_albums %>%
  pull(id) %>%
  purrr::map_dfr(get_album_tracks)

# Print the first five rows of strokes_tracks
head(strokes_tracks, 5)

# Fetch details for all tracks (popularity, duration, etc.)
strokes_track_details <- strokes_tracks %>%
  pull(id) %>%
  purrr::map_dfr(get_track)

# Safely fetch track details for each ID
safe_get_track <- purrr::possibly(get_track, NULL)

strokes_track_details_list <- strokes_tracks %>%
  pull(id) %>%
  purrr::map(safe_get_track)

# Remove problematic fields and flatten
strokes_track_details_cleaned <- purrr::map(strokes_track_details_list, function(track) {
  if (!is.null(track)) {
    track$available_markets <- NULL  # Remove nested field causing issues
    track$album <- NULL  # Remove album if inconsistent
  }
  return(track)
})

# Combine results, removing NULL entries
strokes_track_details <- purrr::compact(strokes_track_details_cleaned) %>%
  dplyr::bind_rows()

# Check the first few rows
head(strokes_track_details, 5)

# Check column names
colnames(strokes_track_details)

# Check the structure of the data frame
str(strokes_track_details)

# View the first few track names
head(strokes_track_details$name, 10)
head(strokes_track_details$explicit, 3)

# Create a vector of track names
track_names <- strokes_track_details$name

# Display the first few track names
head(track_names, 10)


# Get all albums by The Strokes
strokes_albums <- get_artist_albums("0epOFNiUfyON9EYx7Tpr6V", include_groups = "album", market = "US")

# Get additional track details (e.g., popularity)
strokes_track_details <- strokes_tracks %>%
  pull(id) %>%
  purrr::map_dfr(get_track)

# Get the top 50 tracks
top_50_tracks <- strokes_data %>% slice_head(n = 50)

# Save the top 50 tracks to a CSV file
write.csv(top_50_tracks, "top_50_tracks_strokes.csv", row.names = FALSE)

# View the first few rows
print(head(top_50_tracks, 5))

# Save the data as an RDS file
saveRDS(top_tracks, "top_tracks_strokes.rds")

# Confirm the file is saved
print("Data saved as top_tracks_strokes.rds")
getwd()

