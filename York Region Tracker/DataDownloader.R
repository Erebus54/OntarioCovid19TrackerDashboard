library(lubridate)
library(data.table)

#grab file 
casestatus <- read.csv(file = "https://data.ontario.ca/dataset/f4112442-bdc8-45d2-be3c-12efae72fb27/resource/455fd63b-603d-4608-8216-7d8647f43350/download/conposcovidloc.csv")

#data dict URL 
#https://data.ontario.ca/dataset/status-of-covid-19-cases-in-ontario
#end_time <- Sys.time()
#end_time - start_time


#clean CaseStatus file
casestatus$Accurate_Episode_Date <- as.Date(casestatus$Accurate_Episode_Date)
casestatus$Case_Reported_Date <- as.Date(casestatus$Case_Reported_Date)
casestatus$Test_Reported_Date <- as.Date(casestatus$Test_Reported_Date)


#create .csv for each date of dataset
dirPath <- "C:/Users/patri/Documents/covid19/York Region Tracker/datasets/"
#Delete files if exists 
do.call(file.remove, list(list.files(dirPath, full.names = TRUE)))
fileName = paste(dirPath, 'casestatus.csv',sep = '')
#Write Case Status File 
write.csv(casestatus, 
          file = fileName, 
          fileEncoding = 'UTF-8', 
          row.names = F)

