#### GBIF practical ####
# Setting up gbif
install.packages("rgbif")
library(rgbif)

options(gbif_user = "mari-fjelldal")
options(gbif_email = "mari.fjelldal@gmail.com")
options(gbif_pwd = "rEccym-1cogte-kegxeb")


# Working with gbif backbone
sp_name <- "Lagopus muta"
sp_backbone <- name_backbone(name = sp_name)
knitr::kable(sp_backbone)
sp_key <- sp_backbone$usageKey
sp_key
sp_backbone <- name_backbone(name = sp_name, verbose = TRUE)
knitr::kable(sp_backbone)
sp_backbone2 <- name_backbone(name = "Calluna vulgaris", verbose = TRUE)
knitr::kable(t(sp_backbone2))
knitr::kable(name_backbone("Lagopus mut", verbose = TRUE))
knitr::kable(name_backbone("Glocianus punctiger", verbose = TRUE))
checklist_df <- name_backbone_checklist(c(sp_name, "Calluna vulgaris"))
knitr::kable(checklist_df)
sp_suggest <- name_suggest(sp_name)$data
knitr::kable(t(head(sp_suggest)))
#sp_lookup <- name_lookup(sp_name)$data #not working
#knitr::kable(head(sp_lookup))
sp_usage <- name_usage(key = sp_key, data = "vernacularNames")$data
knitr::kable(head(sp_usage))


# Discovering data with rgbif
sp_name <- "Lagopus muta"
sp_backbone <- name_backbone(name = sp_name)
sp_key <- sp_backbone$usageKey
occ_count(taxonKey = sp_key)
occ_search(taxonKey = sp_key, limit = 0)$meta$count

#enumeration_country() # to find country code
occ_NO <- occ_search(taxonKey = sp_key, country = "NO")
occ_NO$meta$count
NO_shp <- rnaturalearth::ne_countries(country = "Norway", scale = "small", returnclass = "sf")[, 1] # I am extracting only the first column for ease of use, I don't need additional information

library(leaflet)
leaflet(NO_shp) %>%
  addTiles() %>%
  addPolygons(col = "red")
saveWidget(shape_leaflet, "leaflet_shape.html", selfcontained = TRUE)

library(sf)
NO_shp <- st_crop(NO_shp, xmin = 4.98, xmax = 31.3, ymin = 58, ymax = 71.14)
NO_wkt <- st_as_text(st_geometry(NO_shp))
occ_wkt <- occ_search(taxonKey = sp_key, geometry = NO_wkt)
occ_wkt$meta$count

occ_year <- occ_search(
  taxonKey = sp_key,
  country = "NO",
  year = 2020
)
occ_year$meta$count

occ_window <- occ_search(  # too big - don't run
  taxonKey = sp_key,
  country = "NO",
  year = 2000:2020
)

sum(unlist(lapply(occ_window, FUN = function(x) {
  x$meta$count
})))

plot_df <- data.frame(
  Year = 2000:2020,
  Records = unlist(lapply(occ_window, FUN = function(x) {
    x$meta$count
  })),
  Cumulative = cumsum(unlist(lapply(occ_window, FUN = function(x) {
    x$meta$count
  })))
)
ggplot(data = plot_df, aes(x = as.factor(Year), y = Cumulative)) +
  geom_bar(stat = "identity", aes(fill = "black")) +
  geom_bar(stat = "identity", aes(y = Records, fill = "forestgreen")) +
  theme_bw() +
  scale_fill_manual(
    name = "Records",
    values = c("black" = "black", "forestgreen" = "forestgreen"), labels = c("Cumulative Total", "New per Year")
  ) +
  theme(legend.position = c(0.15, 0.8), legend.key.size = unit(2, "cm"), legend.text = element_text(size = 20), legend.title = element_text(size = 25)) +
  labs(x = "Year", y = "Records of Lagopus muta throughout Norway starting 2000")


occ_count(    # run instead (in this example at least)
  taxonKey = sp_key,
  country = "NO",
  year = "2000,2020"
)

occ_human <- occ_search(
  taxonKey = sp_key,
  country = "NO",
  year = 2020,
  basisOfRecord = "HUMAN_OBSERVATION"
)
occ_human$meta$count

occ_preserved <- occ_search(
  taxonKey = sp_key,
  country = "NO",
  year = 2020,
  basisOfRecord = "PRESERVED_SPECIMEN"
)
occ_preserved$meta$count


occ_present <- occ_search(
  taxonKey = sp_key,
  country = "NO",
  year = 2020,
  basisOfRecord = "HUMAN_OBSERVATION",
  occurrenceStatus = "PRESENT"
)
occ_present$meta$count

occ_absent <- occ_search(
  taxonKey = sp_key,
  country = "NO",
  year = 2020,
  basisOfRecord = "HUMAN_OBSERVATION",
  occurrenceStatus = "ABSENT"
)
occ_absent$meta$count

occ_absent <- occ_search(
  taxonKey = sp_key,
  occurrenceStatus = "ABSENT"
)
occ_absent$meta$count

occ_meta <- occ_search(taxonKey = sp_key, country = "NO")
str(occ_meta, max.level = 1)

occ_final <- occ_search(
  taxonKey = sp_key,
  country = "NO",
  year = "2000,2020",
  facet = c("year"), # facetting by year will break up the occurrence record counts
  year.facetLimit = 23, # this must either be the same number as facets needed or larger
  basisOfRecord = "HUMAN_OBSERVATION",
  occurrenceStatus = "PRESENT"
)
knitr::kable(t(occ_final$facet$year))

occ_count(
  taxonKey = sp_key,
  country = "NO",
  year = "2000,2020", # the comma here is an alternative way of specifying a range
  basisOfRecord = "HUMAN_OBSERVATION",
  occurrenceStatus = "PRESENT"
)


# Downloading data with rgbif
sp_name <- "Lagopus muta"
sp_backbone <- name_backbone(name = sp_name)
sp_key <- sp_backbone$usageKey

res <- occ_download(
  pred("taxonKey", sp_key),
  pred("basisOfRecord", "HUMAN_OBSERVATION"),
  pred("country", "NO"),
  pred("hasCoordinate", TRUE),
  pred_gte("year", 2000),
  pred_lte("year", 2020)
)

occ_download_meta(res)
