
data <- read.csv("./data/athlete_events.csv", stringsAsFactors = FALSE) %>% 
  filter(Medal != is.na(Medal))

noc_regions <- fread("./data/noc_regions.csv")

combined_medal_data <- left_join(data, noc_regions, by = "NOC") %>% 
  filter(!is.na(region))

counts <- group_by(combined_medal_data, Medal, region) %>% 
  summarize(count = n())
counts$iso <- countrycode(counts$region, "country.name", "iso3c")
colnames(counts)[2] = "name"

country_codes <- read.csv("https://raw.githubusercontent.com/lukes/ISO-3166-Countries-with-Regional-Codes/master/all/all.csv")
colnames(country_codes)[3] = "iso"
country_codes$iso <- as.character(country_codes$iso)

final_counts <- full_join(counts, country_codes, by = "iso")
final_counts$count[is.na(final_counts$count)] <- 0