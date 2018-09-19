# Load libraries
library(dplyr)      # you can choose to load dplyr only
library(data.table) # for data loading
library(viridis)    # for our colors

# Read data
hap <- fread("2017.csv")

# take a look at the data
glimpse(hap) 

#=======================
# Clean / Transform Data 
#=======================
#Some of these country names (USA and UK) do not match with the map_data(‘world’) dataset.
#Produce an output showing all the region names:
  #Var. 1 -> unique(map_data("world")$region)
  #Var. 2 -> map_data("world") %>% group_by(region) %>% summarise() %>% print(n = Inf)

hap <- hap %>% mutate(Country = if_else(Country == "United States", 'USA', 
                                if_else(Country == "United Kingdom", 'UK', 
                      Country)))

#=======================
# Create worldmap 
#=======================
# Get map_world function
map.world <- map_data('world')

# join both data sets
hf <- left_join(map.world, hap, by = c('region' = 'Country'))

# draw plot
ggplot(data = hf, aes(x = long, y = lat, group = group)) +
       geom_polygon(aes(fill = `Health..Life.Expectancy.`)) + 
       scale_fill_viridis(option = 'plasma')+ 
       labs(title = "Countries With Highest Life Expectancy", subtitle = "People living in Scandinavian Countries Live Longest", caption = "Source:World Happiness Report 2016") + 
       theme_bw()