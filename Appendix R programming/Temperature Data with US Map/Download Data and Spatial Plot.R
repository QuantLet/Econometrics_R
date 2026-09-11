# ==============================================================
# Daily maximum temperature: New York City and the contiguous US
# ==============================================================

rm(list = ls())

# The GHCN inventory is large; allow enough time on slower connections.
options(timeout = max(300, getOption("timeout")))

# install.packages(c("dplyr", "ggplot2", "jsonlite", "maps", "viridis"))
library(dplyr)
library(ggplot2)
library(jsonlite)
library(maps)
library(viridis)

if (requireNamespace("rstudioapi", quietly = TRUE) && rstudioapi::isAvailable()) {
  setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
}

analysis_year <- 2014L
nyc_station <- "USW00094728" # New York City Central Park

# Official GHCN-Daily station metadata and inventory files.
stations_url <- paste0(
  "https://www.ncei.noaa.gov/pub/data/ghcn/daily/",
  "ghcnd-stations.txt"
)
inventory_url <- paste0(
  "https://www.ncei.noaa.gov/pub/data/ghcn/daily/",
  "ghcnd-inventory.txt"
)

download_lines <- function(url) {
  destination <- tempfile(fileext = ".txt")
  on.exit(unlink(destination), add = TRUE)
  utils::download.file(url, destination, mode = "wb", quiet = TRUE)
  readLines(destination, warn = FALSE)
}

station_lines <- download_lines(stations_url)
stations <- data.frame(
  id = substr(station_lines, 1, 11),
  latitude = as.numeric(substr(station_lines, 13, 20)),
  longitude = as.numeric(substr(station_lines, 22, 30)),
  state_code = trimws(substr(station_lines, 39, 40)),
  station_name = trimws(substr(station_lines, 42, 71)),
  stringsAsFactors = FALSE
)

inventory_lines <- download_lines(inventory_url)
tmax_inventory <- data.frame(
  id = substr(inventory_lines, 1, 11),
  element = substr(inventory_lines, 32, 35),
  first_year = as.integer(substr(inventory_lines, 37, 40)),
  last_year = as.integer(substr(inventory_lines, 42, 45)),
  stringsAsFactors = FALSE
) %>%
  filter(
    element == "TMAX",
    first_year <= analysis_year,
    last_year >= analysis_year
  )

# Select candidate stations close to each state capital.  Alaska and Hawaii
# are excluded because the map below covers the contiguous 48 states.
data("us.cities", package = "maps")
contiguous_codes <- setdiff(state.abb, c("AK", "HI"))
capitals <- us.cities %>%
  filter(capital == 2, country.etc %in% contiguous_codes) %>%
  transmute(
    state_code = country.etc,
    capital_name = sub(" [A-Z]{2}$", "", name),
    capital_latitude = lat,
    capital_longitude = long
  )

active_stations <- stations %>%
  inner_join(tmax_inventory %>% select(id), by = "id") %>%
  filter(state_code %in% contiguous_codes)

haversine_km <- function(lat1, lon1, lat2, lon2) {
  radians <- pi / 180
  dlat <- (lat2 - lat1) * radians
  dlon <- (lon2 - lon1) * radians
  a <- sin(dlat / 2)^2 +
    cos(lat1 * radians) * cos(lat2 * radians) * sin(dlon / 2)^2
  6371 * 2 * atan2(sqrt(a), sqrt(1 - a))
}

# Retain the five closest candidates in each state, then use actual 2014
# coverage to select a station.  This avoids relying on an unchecked,
# hand-written station-to-state table.
candidate_stations <- capitals %>%
  inner_join(active_stations, by = "state_code") %>%
  mutate(
    distance_km = haversine_km(
      capital_latitude, capital_longitude, latitude, longitude
    )
  ) %>%
  group_by(state_code) %>%
  slice_min(distance_km, n = 5, with_ties = FALSE) %>%
  ungroup()

# NOAA's Daily Summaries service returns metric TMAX directly in degrees C.
fetch_daily_summaries <- function(station_ids) {
  endpoint <- "https://www.ncei.noaa.gov/access/services/data/v1"
  query <- paste0(
    "?dataset=daily-summaries",
    "&stations=", paste(station_ids, collapse = ","),
    "&startDate=", analysis_year, "-01-01",
    "&endDate=", analysis_year, "-12-31",
    "&format=json&units=metric",
    "&includeAttributes=false&includeStationName=true"
  )

  response <- jsonlite::fromJSON(paste0(endpoint, query))
  if (is.null(response) || nrow(response) == 0L) {
    return(data.frame())
  }
  if (!"TMAX" %in% names(response)) response$TMAX <- NA_character_

  response %>%
    transmute(
      id = STATION,
      date = as.Date(DATE),
      tmax = suppressWarnings(as.numeric(TMAX))
    )
}

ids_to_download <- unique(c(candidate_stations$id, nyc_station))
id_batches <- split(ids_to_download, ceiling(seq_along(ids_to_download) / 10))
daily_data <- bind_rows(lapply(id_batches, fetch_daily_summaries))

coverage <- daily_data %>%
  group_by(id) %>%
  summarise(n_tmax = sum(!is.na(tmax)), .groups = "drop")

candidate_stations <- candidate_stations %>%
  left_join(coverage, by = "id") %>%
  mutate(n_tmax = ifelse(is.na(n_tmax), 0L, n_tmax))

# Prefer the closest station with at least 300 valid daily observations.
# If no candidate reaches that threshold, use the best-covered candidate.
select_station <- function(state_candidates) {
  adequate <- state_candidates %>% filter(n_tmax >= 300L)
  if (nrow(adequate) > 0L) {
    adequate %>% slice_min(distance_km, n = 1, with_ties = FALSE)
  } else {
    state_candidates %>%
      arrange(desc(n_tmax), distance_km) %>%
      slice(1)
  }
}

representative_stations <- candidate_stations %>%
  group_by(state_code) %>%
  group_modify(~ select_station(.x)) %>%
  ungroup() %>%
  mutate(state_name = state.name[match(state_code, state.abb)])

if (nrow(representative_stations) != 48L) {
  stop("Could not select one representative station for every contiguous state.")
}

# Daily maximum temperature at New York City Central Park.
new_york_data <- daily_data %>%
  filter(id == nyc_station, !is.na(tmax))

ny_plot <- ggplot(new_york_data, aes(x = date, y = tmax)) +
  geom_line(colour = "#244A5A", linewidth = 0.45) +
  labs(
    title = "Daily Maximum Temperature in New York City, 2014",
    subtitle = "Central Park station (USW00094728)",
    x = "Date",
    y = "Temperature (degrees C)"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    plot.title = element_text(face = "bold"),
    plot.background = element_rect(fill = "white", colour = NA),
    panel.background = element_rect(fill = "white", colour = NA)
  )

ggsave(
  "NY_Temperature_2014.png", ny_plot,
  width = 8, height = 5, dpi = 300, bg = "white"
)

# Annual mean of daily TMAX for one representative station per state.
station_averages <- daily_data %>%
  filter(id %in% representative_stations$id) %>%
  group_by(id) %>%
  summarise(
    mean_tmax_2014 = mean(tmax, na.rm = TRUE),
    observations = sum(!is.na(tmax)),
    .groups = "drop"
  ) %>%
  inner_join(
    representative_stations %>%
      select(id, state_code, state_name, station_name, capital_name),
    by = "id"
  )

state_polygons <- ggplot2::map_data("state") %>%
  mutate(state_name = tools::toTitleCase(region)) %>%
  left_join(station_averages, by = "state_name")

us_map_plot <- ggplot(
  state_polygons,
  aes(x = long, y = lat, group = group, fill = mean_tmax_2014)
) +
  geom_polygon(colour = "white", linewidth = 0.2) +
  coord_quickmap(xlim = c(-125, -66), ylim = c(24, 50), expand = FALSE) +
  scale_fill_viridis_c(
    option = "C",
    name = "Mean daily\nmaximum (degrees C)",
    na.value = "grey85"
  ) +
  labs(
    title = "Annual Mean of Daily Maximum Temperature, 2014",
    subtitle = "One representative station near each state capital"
  ) +
  theme_void(base_size = 12) +
  theme(
    legend.position = "bottom",
    plot.title = element_text(hjust = 0.5, face = "bold"),
    plot.subtitle = element_text(hjust = 0.5),
    plot.background = element_rect(fill = "white", colour = NA),
    panel.background = element_rect(fill = "white", colour = NA),
    legend.background = element_rect(fill = "white", colour = NA)
  )

ggsave(
  "US_Temperature_Map_2014.png", us_map_plot,
  width = 11, height = 6.5, dpi = 300, bg = "white"
)

print(
  representative_stations %>%
    select(state_name, capital_name, id, station_name, distance_km, n_tmax)
)
