library(lubridate)
library(data.table)

library(geojsonio)

library(sf)
library(rgdal)
library(sp)

setwd("C:/Users/patri/Documents/covid19/TrackerDashboards/TrackerDashboards/HotSpotTracker/")

# #download geoJSON file 
# loc = "https://opendata.arcgis.com/datasets/d8fba69152e4408dabfe70e85a2688d2_44.geojson"
# PHU_boundaries <- geojsonio::geojson_read(loc, what = "sp")
# PHU_boundaries_sf <- sf::st_as_sf(PHU_boundaries)
# outname <- paste(getwd(), "/spatial_files/OB/PHU_boundaries.geojson", sep = "")
# #write file
# st_write(obj = PHU_boundaries_sf,  dsn = outname, driver = "GeoJSON")
# 
# PHU_boundaries <- geojsonio::geojson_read("./spatial_files/Ministry_of_Health_Public_Health_Unit_Boundary.geojson", what = "sp")
# PHU_boundaries_sf <- sf::st_as_sf(PHU_boundaries)

#read file 
PHU_boundaries <- geojsonio::geojson_read(outname, what = "sp")
PHU_boundaries_sf <- sf::st_as_sf(PHU_boundaries)


#read CSV file in 
setwd("C:/Users/patri/Documents/covid19/TrackerDashboards/TrackerDashboards/HotSpotTracker/")

#grab file 
loc <- "https://data.ontario.ca/dataset/f4112442-bdc8-45d2-be3c-12efae72fb27/resource/455fd63b-603d-4608-8216-7d8647f43350/download/conposcovidloc.csv"
casestatus <- data.table::fread(input = loc, encoding = 'UTF-8', data.table = F)
#clean casestatus file
casestatus$Accurate_Episode_Date <- as.Date(casestatus$Accurate_Episode_Date)
casestatus$Case_Reported_Date <- as.Date(casestatus$Case_Reported_Date)
casestatus$Test_Reported_Date <- as.Date(casestatus$Test_Reported_Date)
casestatus$Reporting_PHU <- trimws(casestatus$Reporting_PHU)
casestatus$Case_AcquisitionInfo <- trimws(casestatus$Case_AcquisitionInfo)

#write the .csv file for later 
#create .csv for each date of dataset
dirPath <- "C:/Users/patri/Documents/covid19/TrackerDashboards/TrackerDashboards/HotSpotTracker/datasets/"
#Delete files if exists 
do.call(file.remove, list(list.files(dirPath, full.names = TRUE)))
fileName = paste(dirPath, 'casestatus.csv',sep = '')
#Write Case Status File 
write.csv(casestatus, 
          file = fileName, 
          fileEncoding = 'UTF-8', 
          row.names = F)





#preparing dataframe for merge 
#changing 5 PHU names that do not match the GIS file 
casestatus$Reporting_PHU <- as.character(casestatus$Reporting_PHU)
casestatus$Reporting_PHU <- ifelse(casestatus$Reporting_PHU == "Huron Perth District Health Unit", "Huron Perth Health Unit", casestatus$Reporting_PHU)
casestatus$Reporting_PHU <- ifelse(casestatus$Reporting_PHU == "Kingston, Frontenac and Lennox & Addington Public Health", "Kingston, Frontenac and Lennox and Addington Health Unit", casestatus$Reporting_PHU)
casestatus$Reporting_PHU <- ifelse(casestatus$Reporting_PHU == "Sudbury & District Health Unit", "Sudbury and District Health Unit", casestatus$Reporting_PHU)
casestatus$Reporting_PHU <- ifelse(casestatus$Reporting_PHU == "Wellington-Dufferin-Guelph Public Health", "Wellington-Dufferin-Guelph Health Unit", casestatus$Reporting_PHU)
casestatus$Reporting_PHU <- ifelse(casestatus$Reporting_PHU == "York Region Public Health Services", "York Region Public Health", casestatus$Reporting_PHU)

#################################################
# TOTAL CASES 
#################################################

#extracting the Total Number of cases per PHU 
PHU_csums <- data.frame(casestatus %>% 
                          dplyr::group_by(Reporting_PHU) %>% 
                          dplyr::count(name = "TotalCases") %>% 
                          dplyr::arrange(Reporting_PHU) 
)
#merge file with geojson file 
cumulatives <- merge(PHU_boundaries_sf, PHU_csums, by.x = "PHU_NAME_ENG", by.y = "Reporting_PHU" )
#write file 
#Delete files if exists 
dirPath <- "C:/Users/patri/Documents/covid19/TrackerDashboards/TrackerDashboards/HotSpotTracker/spatial_files/cumulatives/"
do.call(file.remove, list(list.files(dirPath, full.names = TRUE)))
outname <- paste(getwd(), "/spatial_files/cumulatives/cumulativeCases.geojson", sep = "")
#write GPKG
sf::st_write(obj = cumulatives,  dsn = outname, driver = "GeoJSON")











#################################################
# TRAVEL CASES 
#################################################
travel_cases <- casestatus %>% 
  dplyr::filter(Case_AcquisitionInfo == "Travel") %>% 
  dplyr::group_by(Reporting_PHU) %>% 
  dplyr::count(name = "TotalCases") %>% 
  dplyr::arrange(Reporting_PHU) %>% 
  data.frame()


#merge file with geojson file 
travel_cases <- merge(PHU_boundaries_sf, travel_cases, by.x = "PHU_NAME_ENG", by.y = "Reporting_PHU" )
#write file 
#Delete files if exists 
dirPath <- "C:/Users/patri/Documents/covid19/TrackerDashboards/TrackerDashboards/HotSpotTracker/spatial_files/travel/"
do.call(file.remove, list(list.files(dirPath, full.names = TRUE)))
outname <- paste(getwd(), "/spatial_files/travel/TravelCases.geojson", sep = "")
#write GPKG
sf::st_write(obj = travel_cases,  dsn = outname, driver = "GeoJSON")















#################################################
# OUTBREAK CASES 
#################################################
OBCases <- casestatus %>% 
  dplyr::filter(Case_AcquisitionInfo == "OB") %>% 
  dplyr::group_by(Reporting_PHU) %>% 
  dplyr::count(name = "TotalCases") %>% 
  dplyr::arrange(Reporting_PHU) %>% 
  data.frame()


#merge file with geojson file 
OBCases <- merge(PHU_boundaries_sf, OBCases, by.x = "PHU_NAME_ENG", by.y = "Reporting_PHU" )
#write file 
#Delete files if exists 
dirPath <- "C:/Users/patri/Documents/covid19/TrackerDashboards/TrackerDashboards/HotSpotTracker/spatial_files/OB/"
do.call(file.remove, list(list.files(dirPath, full.names = TRUE)))
outname <- paste(getwd(), "/spatial_files/OB/OBCases.geojson", sep = "")
#write GPKG
sf::st_write(obj = OBCases,  dsn = outname, driver = "GeoJSON")











#################################################
# CC CASES 
#################################################
CC_Cases <- casestatus %>% 
  dplyr::filter(Case_AcquisitionInfo == "CC") %>% 
  dplyr::group_by(Reporting_PHU) %>% 
  dplyr::count(name = "TotalCases") %>% 
  dplyr::arrange(Reporting_PHU) %>% 
  data.frame()


#merge file with geojson file 
CC_Cases <- merge(PHU_boundaries_sf, CC_Cases, by.x = "PHU_NAME_ENG", by.y = "Reporting_PHU" )
#write file 
#Delete files if exists 
dirPath <- "C:/Users/patri/Documents/covid19/TrackerDashboards/TrackerDashboards/HotSpotTracker/spatial_files/CC/"
do.call(file.remove, list(list.files(dirPath, full.names = TRUE)))
outname <- paste(getwd(), "/spatial_files/CC/CC_Cases.geojson", sep = "")
#write GPKG
sf::st_write(obj = CC_Cases,  dsn = outname, driver = "GeoJSON")



