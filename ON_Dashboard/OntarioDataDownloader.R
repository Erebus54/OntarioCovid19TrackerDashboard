library(lubridate)
library(data.table)

#grab file 
ConfirmedPositives <- read.csv(file = "https://data.ontario.ca/dataset/f4f86e54-872d-43f8-8a86-3892fd3cb5e6/resource/ed270bb8-340b-41f9-a7c6-e8ef587e6d11/download/covidtesting.csv", sep = ",", encoding = 'UTF-8')
CaseStatus <- read.csv(file = "https://data.ontario.ca/dataset/f4112442-bdc8-45d2-be3c-12efae72fb27/resource/455fd63b-603d-4608-8216-7d8647f43350/download/conposcovidloc.csv")

#data dict URL 
#https://data.ontario.ca/dataset/status-of-covid-19-cases-in-ontario
#end_time <- Sys.time()
#end_time - start_time

setwd("C:/Users/patri/Documents/covid19/ON_Dashboard/")

#clean CaseStatus file
CaseStatus$Accurate_Episode_Date <- as.Date(CaseStatus$Accurate_Episode_Date)
CaseStatus$Case_Reported_Date <- as.Date(CaseStatus$Case_Reported_Date)
CaseStatus$Test_Reported_Date <- as.Date(CaseStatus$Test_Reported_Date)


#clean Confirmed Positive file
ConfirmedPositives$`Reported Date` <- as.Date(ConfirmedPositives$`Reported Date`)



#create .csv for each date of dataset
dirPath <- "C:/Users/patri/Documents/covid19/ON_Dashboard/datasets/"
#Delete files if exists 
do.call(file.remove, list(list.files(dirPath, full.names = TRUE)))
fileName = paste(dirPath, 'casestatus.csv',sep = '')
#Write Case Status File 
write.csv(CaseStatus, 
          file = fileName, 
          fileEncoding = 'UTF-8', 
          row.names = F)


#write confirmed positives file 
fileName = paste(dirPath, 'confirmedpositives.csv',sep = '')
write.csv(ConfirmedPositives, 
          file = fileName, 
          fileEncoding = 'UTF-8', 
          row.names = F)
