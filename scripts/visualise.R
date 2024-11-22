library(dplyr)
library(ggplot2)

# Select relevant columns: name, popularity, explicit
strokes_data <- strokes_track_details %>%
  select(name, popularity, explicit)

# Find the top 10 most popular tracks
top_tracks <- strokes_data %>%
  arrange(desc(popularity)) %>%
  slice_head(n = 50)  # Get the top 10 tracks

# Display the top 50 tracks
print(top_tracks)

# Count how many of the top tracks are explicit
explicit_count <- top_tracks %>%
  count(explicit)

# Display explicit vs. non-explicit counts
print(explicit_count)

# Figure 1 - Plot: Popularity of top tracks and explicitness
ggplot(top_tracks, aes(x = reorder(name, -popularity), y = popularity, fill = explicit)) +
  geom_bar(stat = "identity") +
  coord_flip() +
  labs(
    title = "Top 50 Most Popular Tracks - The Strokes",
    x = "Track Name",
    y = "Popularity",
    fill = "Explicit"
  ) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))


# Figure 2 - Track duration and popularity 
ggplot(strokes_track_details, aes(x = duration_ms / 1000, y = popularity)) +
  geom_point(alpha = 0.6) +
  geom_smooth(method = "lm", se = FALSE, color = "red") +
  labs(
    title = "Duration vs. Popularity of Tracks",
    x = "Duration (seconds)",
    y = "Popularity"
  ) +
  theme_minimal()
