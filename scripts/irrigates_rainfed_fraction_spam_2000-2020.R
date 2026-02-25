library(readr)
library(dplyr)
library(writexl)

# Set working directory
setwd("C:/Users/Pedro/ownCloud/CzechGlobe/FABLE-C-CZE/raw/spam/spam2020V2r0_global_harvested_area")

# Function to calculate crop totals
crop_summary <- function(data, crop_pattern) {
  if (is.null(data) || nrow(data) == 0) return(NULL)
  
  crop_cols <- grep(crop_pattern, names(data), value = TRUE, ignore.case = TRUE)
  
  totals <- data.frame(
    Crop = toupper(gsub(crop_pattern, "", crop_cols, ignore.case = TRUE)),
    Total_Area_ha = sapply(crop_cols, function(col) sum(data[[col]], na.rm = TRUE))
  )
  
  totals <- totals %>%
    filter(Total_Area_ha > 0) %>%
    arrange(desc(Total_Area_ha))
  
  return(totals)
}

# Results list
all_summaries <- list()

#SPAM2020
ti_2020 <- read_csv("spam2020V2r0_global_H_TI.csv", show_col_types = FALSE) %>%
  filter(ADM0_NAME == "Czechia")
tr_2020 <- read_csv("spam2020V2r0_global_H_TR.csv", show_col_types = FALSE) %>%
  filter(ADM0_NAME == "Czechia")

if (nrow(ti_2020) > 0) {
  all_summaries[["2020_Irrigated"]] <- crop_summary(ti_2020, "_I$")
}
if (nrow(tr_2020) > 0) {
  all_summaries[["2020_Rainfed"]] <- crop_summary(tr_2020, "_R$")
}

#SPAM2010
ti_2010 <- read_csv("spam2010V2r0_global_H_TI.csv", show_col_types = FALSE) %>%
  filter(iso3 == "CZE")
tr_2010 <- read_csv("spam2010V2r0_global_H_TR.csv", show_col_types = FALSE) %>%
  filter(iso3 == "CZE")

if (nrow(ti_2010) > 0) {
  all_summaries[["2010_Irrigated"]] <- crop_summary(ti_2010, "_i$")
}
if (nrow(tr_2010) > 0) {
  all_summaries[["2010_Rainfed"]] <- crop_summary(tr_2010, "_r$")
}

#SPAM2005
ti_2005 <- read_csv("spam2005V3r2_global_H_TI.csv", show_col_types = FALSE) %>%
  filter(iso3 == "CZE")
tr_2005 <- read_csv("spam2005V3r2_global_H_TR.csv", show_col_types = FALSE) %>%
  filter(iso3 == "CZE")

if (nrow(ti_2005) > 0) {
  all_summaries[["2005_Irrigated"]] <- crop_summary(ti_2005, "_i$")
}
if (nrow(tr_2005) > 0) {
  all_summaries[["2005_Rainfed"]] <- crop_summary(tr_2005, "_r$")
}

#SPAM2000
spam2000 <- read_csv("spam2000v3.0.7_global_harv_area.csv", show_col_types = FALSE) %>%
  filter(stat_code == "CZE")

if (nrow(spam2000) > 0) {
  all_summaries[["2000_Irrigated"]] <- crop_summary(spam2000, "_i$")
  all_summaries[["2000_Rainfed"]] <- crop_summary(spam2000, "_s$")
}

# Write to Excel
output_file <- paste0("SPAM_Czechia_Summary_", Sys.Date(), ".xlsx")
write_xlsx(all_summaries, output_file)

for (name in names(all_summaries)) {
  cat("  -", name, "\n")
}
cat("\nDone!\n")
