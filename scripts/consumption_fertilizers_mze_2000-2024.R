# Load required libraries
library(ggplot2)
library(dplyr)
library(readr)
library(scales)

# Set the path to your CSV file
file_path <- "C:/Users/Pedro/ownCloud/CzechGlobe/FABLE-C-CZE/raw/mze/consumption_fertilisers_mze_2000-2024.csv"

# Read the data from CSV file
data <- read_csv(file_path)

# Check if data was loaded successfully
if (nrow(data) == 0) {
  stop("Data could not be loaded. Please check the file path.")
}

cat("Data loaded successfully!\n")
cat("Number of rows:", nrow(data), "\n")
cat("Number of columns:", ncol(data), "\n")

# Check the column names and structure
cat("\nColumn names:\n")
print(names(data))

cat("\nFirst few rows of data:\n")
print(head(data))

cat("\nData structure:\n")
glimpse(data)

# Clean up the data column names (remove special characters for easier handling)
data_clean <- data %>%
  rename(
    Rok = Rok,
    Spotreba = `Spotřeba minerálního hnojiva`,
    Hnojivo = `Název minerálního hnojiva`,
    Jednotka = Jednotka
  ) %>%
  mutate(
    Rok = as.integer(Rok),
    Hnojivo = factor(Hnojivo, levels = c("N", "P₂O₅", "K₂O")),
    Spotreba = as.numeric(Spotreba)
  )

# Check for any missing values
cat("\nMissing values summary:\n")
print(colSums(is.na(data_clean)))

# Remove any rows with missing values in key columns
data_clean <- data_clean %>%
  filter(!is.na(Rok), !is.na(Spotreba), !is.na(Hnojivo))

cat("\nAfter cleaning - Date range:", range(data_clean$Rok, na.rm = TRUE))
cat("\nFertilizer types:", levels(data_clean$Hnojivo))
cat("\nTotal records:", nrow(data_clean), "\n")

# Define colors for fertilizers
fertilizer_colors <- c("N" = "#2E86AB", "P₂O₅" = "#A23B72", "K₂O" = "#F18F01")

# Plot 1: Line chart with trends
p1 <- ggplot(data_clean, aes(x = Rok, y = Spotreba, color = Hnojivo, group = Hnojivo)) +
  geom_line(size = 1) +
  geom_point(size = 1.5) +
  scale_color_manual(values = fertilizer_colors, name = "Minerální hnojivo") +
  scale_x_continuous(breaks = seq(min(data_clean$Rok), max(data_clean$Rok), by = 2)) +
  labs(
    title = paste("Vývoj spotřeby minerálních hnojiv (", min(data_clean$Rok), "-", max(data_clean$Rok), ")", sep = ""),
    subtitle = "Dlouhodobé trendy spotřeby N, P₂O₅ a K₂O",
    x = "Rok",
    y = "Spotřeba (kg čist. živin.ha⁻¹)",
    caption = "Zdroj: MZE data"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold", size = 14, hjust = 0.5),
    plot.subtitle = element_text(hjust = 0.5),
    axis.text.x = element_text(angle = 45, hjust = 1),
    legend.position = "bottom"
  )

print(p1)

# Plot 2: Faceted plot for individual analysis
p2 <- ggplot(data_clean, aes(x = Rok, y = Spotreba)) +
  geom_line(color = "#2E86AB", size = 1) +
  geom_point(color = "#2E86AB", size = 1) +
  facet_wrap(~ Hnojivo, scales = "free_y", ncol = 1) +
  scale_x_continuous(breaks = seq(min(data_clean$Rok), max(data_clean$Rok), by = 3)) +
  labs(
    title = "Spotřeba minerálních hnojiv - individuální trendy",
    x = "Rok",
    y = "Spotřeba (kg čist. živin.ha⁻¹)"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold", size = 14, hjust = 0.5),
    strip.background = element_rect(fill = "lightgray"),
    strip.text = element_text(face = "bold")
  )

print(p2)

# Plot 3: Bar chart for recent years (last 10 years)
recent_data <- data_clean %>% 
  filter(Rok >= max(Rok) - 9)

p3 <- ggplot(recent_data, aes(x = factor(Rok), y = Spotreba, fill = Hnojivo)) +
  geom_bar(stat = "identity", position = "dodge", alpha = 0.8) +
  scale_fill_manual(values = fertilizer_colors, name = "Minerální hnojivo") +
  labs(
    title = paste("Spotřeba minerálních hnojiv - posledních 10 let (", min(recent_data$Rok), "-", max(recent_data$Rok), ")", sep = ""),
    x = "Rok",
    y = "Spotřeba (kg čist. živin.ha⁻¹)"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold", size = 14, hjust = 0.5),
    axis.text.x = element_text(angle = 45, hjust = 1),
    legend.position = "bottom"
  )

print(p3)

# Plot 4: Area chart showing composition over time
p4 <- ggplot(data_clean, aes(x = Rok, y = Spotreba, fill = Hnojivo)) +
  geom_area(alpha = 0.7) +
  scale_fill_manual(values = fertilizer_colors, name = "Minerální hnojivo") +
  scale_x_continuous(breaks = seq(min(data_clean$Rok), max(data_clean$Rok), by = 3)) +
  labs(
    title = paste("Složení spotřeby minerálních hnojiv v čase (", min(data_clean$Rok), "-", max(data_clean$Rok), ")", sep = ""),
    subtitle = "Kumulativní přehled",
    x = "Rok",
    y = "Spotřeba (kg čist. živin.ha⁻¹)"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold", size = 14, hjust = 0.5),
    plot.subtitle = element_text(hjust = 0.5)
  )

print(p4)

# Summary statistics
summary_stats <- data_clean %>%
  group_by(Hnojivo) %>%
  summarise(
    Prumerna_spotreba = round(mean(Spotreba, na.rm = TRUE), 2),
    Max_spotreba = round(max(Spotreba, na.rm = TRUE), 2),
    Min_spotreba = round(min(Spotreba, na.rm = TRUE), 2),
    Rok_max = Rok[which.max(Spotreba)],
    Rok_min = Rok[which.min(Spotreba)],
    Pocet_let = n()
  )

cat("\nSouhrnné statistiky:\n")
print(summary_stats)

# Yearly totals
yearly_totals <- data_clean %>%
  group_by(Rok) %>%
  summarise(Celkova_spotreba = sum(Spotreba, na.rm = TRUE))

cat("\nCelková roční spotřeba (výběr):\n")
print(tail(yearly_totals, 10))

# Display the clean data table
cat("\nClean data table (first 10 rows):\n")
print(head(data_clean, 10))

# Save plots (optional)
# ggsave("trendy_spotreby_hnojiv.png", p1, width = 12, height = 6, dpi = 300)
# ggsave("individuální_trendy.png", p2, width = 10, height = 8, dpi = 300)
# ggsave("poslednich_10_let.png", p3, width = 10, height = 6, dpi = 300)
# ggsave("slozeni_spotreby.png", p4, width = 12, height = 6, dpi = 300)

cat("\nVisualization completed successfully!\n")
