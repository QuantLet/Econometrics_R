## =====================================================
## Tidyverse: data manipulation with dplyr
## =====================================================

# Optional: set working directory to the current script location (RStudio)
if (requireNamespace("rstudioapi", quietly = TRUE)) {
  setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
}

# install.packages("dplyr")
# install.packages("nycflights13")

library(dplyr)
library(nycflights13)

## Example 1: filter, select, arrange, head
flights %>%
  filter(origin == "JFK", month == 1, day == 1) %>%
  select(year, month, day, dep_time, dep_delay, arr_delay, carrier, dest) %>%
  arrange(desc(dep_delay)) %>%
  head(5)

## Example 2: simple row filtering
flights %>%
  filter(carrier == "AA", dep_delay > 60)

## Example 3: arrange, select + mutate, group_by + summarise

# Arrange by largest arrival delay
flights %>%
  arrange(desc(arr_delay))

# Select and mutate: keep basic columns and compute speed (miles per hour)
flights %>%
  select(year, month, day, dep_time, arr_time, distance, air_time) %>%
  mutate(speed_mph = distance / (air_time / 60))

# Summarise and group: average delay by carrier and origin airport
flights %>%
  group_by(carrier, origin) %>%
  summarise(
    avg_dep_delay = mean(dep_delay, na.rm = TRUE),
    avg_arr_delay = mean(arr_delay, na.rm = TRUE),
    n_flights     = n(),
    .groups       = "drop"
  )


## =====================================================
## Tidyverse: data visualisation with ggplot2 (mpg dataset)
## =====================================================

# install.packages("ggplot2")
library(ggplot2)

## 1. Data layer only  --> mpg_data_layer.png
p_data_layer <- ggplot(data = mpg) +
  labs(title = "Visualisation of mpg Dataset")

ggsave("mpg_data_layer.png", p_data_layer,
       width = 7, height = 5, dpi = 300)

## 2. Aesthetic mappings  --> mpg_data_aesthetic_layer.png
p_aesthetic <- ggplot(data = mpg, aes(x = displ, y = hwy, col = class)) +
  labs(title = "Engine Size and Highway Fuel Efficiency by Vehicle Class")

ggsave("mpg_data_aesthetic_layer.png", p_aesthetic,
       width = 7, height = 5, dpi = 300)

## 3. Geometric layer: scatterplot  --> mpg_geom_1.png
p_geom <- ggplot(data = mpg, aes(x = displ, y = hwy, col = class)) +
  geom_point() +
  labs(title = "Engine Size versus Highway Fuel Efficiency",
       x     = "Engine Displacement (litres)",
       y     = "Highway MPG")

ggsave("mpg_geom_1.png", p_geom,
       width = 7, height = 5, dpi = 300)

## 4. Extra aesthetics: size, colour, shape

# Incorporating size (city MPG)  --> mpg_size.png
p_size <- ggplot(data = mpg, aes(x = displ, y = hwy, size = cty)) +
  geom_point() +
  labs(title = "Engine Size vs Highway Efficiency (Point Size = City MPG)",
       x     = "Engine Displacement (litres)",
       y     = "Highway MPG")

ggsave("mpg_size.png", p_size,
       width = 7, height = 5, dpi = 300)

# Employing shape and colour (drive type and vehicle class)  --> mpg_shape_color.png
p_shape_color <- ggplot(
  data = mpg,
  aes(x = displ, y = hwy, col = class, shape = drv)
) +
  geom_point() +
  labs(title = "Highway Efficiency by Class and Drive Type",
       x     = "Engine Displacement (litres)",
       y     = "Highway MPG")

ggsave("mpg_shape_color.png", p_shape_color,
       width = 7, height = 5, dpi = 300)

## 5. Histogram with ggplot2  --> mpg_histogram.png
p_hist <- ggplot(data = mpg, aes(x = hwy)) +
  geom_histogram(binwidth = 1, fill = "skyblue", color = "black") +
  labs(title = "Distribution of Highway Miles-per-Gallon",
       x     = "Highway MPG",
       y     = "Count")

ggsave("mpg_histogram.png", p_hist,
       width = 7, height = 5, dpi = 300)

## 6. Facets

# Base plot
p_base <- ggplot(data = mpg, aes(x = displ, y = hwy)) + geom_point()

# Rows by drive type (f, r, 4)  --> mpg_drv.png
p_drv <- p_base +
  facet_grid(drv ~ .) +
  labs(title = "Highway MPG vs Engine Size by Drive Type")

ggsave("mpg_drv.png", p_drv,
       width = 7, height = 5, dpi = 300)

# Columns by vehicle class  --> mpg_class.png
p_class <- p_base +
  facet_grid(. ~ class) +
  labs(title = "Highway MPG vs Engine Size by Vehicle Class")

ggsave("mpg_class.png", p_class,
       width = 8, height = 5, dpi = 300)

## 7. Statistical layer: smoothing / regression line  --> mpg_statistical.png
p_stat <- ggplot(data = mpg, aes(x = displ, y = hwy)) +
  geom_point() +
  stat_smooth(method = lm, col = "firebrick") +
  labs(title = "Trend in Highway Fuel Efficiency vs Engine Size",
       x     = "Engine Displacement (litres)",
       y     = "Highway MPG")

ggsave("mpg_statistical.png", p_stat,
       width = 7, height = 5, dpi = 300)

## 8. Coordinate and scale control  --> mpg_coordinates.png
p_coord <- ggplot(data = mpg, aes(x = displ, y = hwy)) +
  geom_point() +
  stat_smooth(method = lm, col = "firebrick") +
  scale_y_continuous("Highway MPG",
                     limits = c(10, 45),
                     expand = c(0, 0)) +
  scale_x_continuous("Engine Displacement (litres)",
                     limits = c(1, 7),
                     expand = c(0, 0)) +
  coord_equal() +
  labs(title = "Engine Size and Fuel Efficiency (Equal Scales)")

ggsave("mpg_coordinates.png", p_coord,
       width = 7, height = 5, dpi = 300)

## 9. Zooming with coord_cartesian()  --> mpg_cartesian.png
p_cartesian <- ggplot(data = mpg, aes(x = displ, y = hwy, col = drv)) +
  geom_point() +
  geom_smooth() +
  coord_cartesian(xlim = c(2, 5)) +
  labs(title = "Detailed View: Highway MPG vs Engine Size (2–5 litres)",
       x     = "Engine Displacement (litres)",
       y     = "Highway MPG")

ggsave("mpg_cartesian.png", p_cartesian,
       width = 7, height = 5, dpi = 300)

## 10. Themes and further coord_cartesian() examples
# (Not referenced in LaTeX figures, so no ggsave required unless you want them.)

# Theme minimal with facets
ggplot(data = mpg, aes(x = displ, y = hwy)) +
  geom_point() +
  facet_grid(. ~ class) +
  theme_minimal() +
  labs(title = "Engine Size and Highway Efficiency by Vehicle Class",
       x     = "Engine Displacement (litres)",
       y     = "Highway MPG")

# coord_cartesian() on city MPG
ggplot(data = mpg, aes(x = displ, y = cty)) +
  geom_point() +
  coord_cartesian(xlim = c(2, 5)) +
  labs(title = "Detailed View: Engine Size vs City MPG",
       x     = "Engine Displacement (litres)",
       y     = "City MPG")

## 11. Various plot types with ggplot2
# (Again, no LaTeX figure references for these specific names, so saving is optional.)

# Histogram of highway MPG
ggplot(mpg, aes(x = hwy)) +
  geom_histogram(binwidth = 1, fill = "blue", color = "black") +
  labs(title = "Histogram of Highway Miles-per-Gallon",
       x     = "Highway MPG")

# Boxplot of highway MPG by vehicle class
ggplot(mpg, aes(x = class, y = hwy)) +
  geom_boxplot(fill = "orange", color = "black") +
  labs(title = "Boxplot of Highway MPG by Vehicle Class",
       x     = "Vehicle Class",
       y     = "Highway MPG")

# Bar plot: counts by vehicle class
ggplot(mpg, aes(x = class)) +
  geom_bar(fill = "green", color = "black") +
  labs(title = "Bar Plot of Car Counts by Vehicle Class",
       x     = "Vehicle Class",
       y     = "Count")

# Pie chart of vehicle class shares
ggplot(mpg, aes(x = factor(1), fill = class)) +
  geom_bar(width = 1) +
  coord_polar(theta = "y") +
  labs(title = "Pie Chart of Vehicle Class Composition",
       x     = NULL, y = NULL)

# Density plot of highway MPG
ggplot(mpg, aes(x = hwy)) +
  geom_density(fill = "magenta") +
  labs(title = "Density Plot of Highway Miles-per-Gallon",
       x     = "Highway MPG")

# QQ-Plot of highway MPG against a normal distribution
ggplot(mpg, aes(sample = hwy)) +
  stat_qq() +
  stat_qq_line() +
  labs(title = "QQ-Plot of Highway Miles-per-Gallon")

# 2D density contour plot: engine size vs highway MPG
# install.packages("viridis")
library(viridis)

ggplot(mpg, aes(x = displ, y = hwy)) +
  stat_density_2d(aes(fill = after_stat(level)),
                  geom = "polygon", color = "white") +
  scale_fill_viridis_c() +
  labs(title = "2D Density Contour Plot of Engine Size vs Highway MPG",
       x     = "Engine Displacement (litres)",
       y     = "Highway MPG",
       fill  = "Density")

## 12. Saving a ggplot object (example in text)
# Create a plot object
plot_obj <- ggplot(data = mpg, aes(x = displ, y = hwy)) +
  geom_point() +
  labs(title = "Engine Size vs Highway Fuel Efficiency",
       x     = "Engine Displacement (litres)",
       y     = "Highway MPG")

# Save the plot as a PNG file
ggsave("engine_size_vs_efficiency.png", plot_obj,
       width = 7, height = 5, dpi = 300)

# Isolate the plot as a variable for subsequent use
extracted_plot <- plot_obj

# Print to the active graphics device
plot_obj


## =====================================================
## Tidyverse + APIs example: World Bank data with WDI
## (not tied to LaTeX figures, but kept for completeness)
## =====================================================

# install.packages("WDI")
library(WDI)

# Search for indicators related to GDP per capita
WDIsearch("gdp per capita") |> head()

# Download GDP per capita and population for selected countries, 1990–2022
wb <- WDI(
  country   = c("CN", "GB", "US"),
  indicator = c(gdppc = "NY.GDP.PCAP.KD", pop = "SP.POP.TOTL"),
  start     = 1990,
  end       = 2022,
  extra     = TRUE
) |>
  as_tibble() |>
  arrange(country, year)

# Plot GDP per capita over time (optional save)
p_wb <- ggplot(wb, aes(x = year, y = gdppc, color = country)) +
  geom_line() +
  labs(title = "GDP per Capita (constant 2015 USD)",
       x     = "Year",
       y     = "GDP per capita",
       color = "Country")

# Optionally save:
# ggsave("wb_gdppc.png", p_wb, width = 7, height = 5, dpi = 300)
