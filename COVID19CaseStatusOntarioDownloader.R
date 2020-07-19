library(lubridate)

#grab file 

urlfile="https://data.ontario.ca/dataset/f4f86e54-872d-43f8-8a86-3892fd3cb5e6/resource/ed270bb8-340b-41f9-a7c6-e8ef587e6d11/download/covidtesting.csv"

#start_time <- Sys.time()
caseStatusOntario <-read.csv(url(urlfile))

#data dict URL 
#https://data.ontario.ca/dataset/status-of-covid-19-cases-in-ontario
#end_time <- Sys.time()
#end_time - start_time




#clean file
caseStatusOntario$Reported.Date <- as.Date(caseStatusOntario$Reported.Date)

#write file to directory appending the current date 
#each day will have its own folder in case we decide to optimize it later by writing each aggregation table to
#a new csv file 


#create .csv for each date of dataset
dirPath <- "C:/Users/patri/Documents/covid19/Ontario/LiveShinyDashboard/ShinyAppProj/Datasets/"


newfolder <- Sys.Date()
newpath <- file.path(dirPath, newfolder)

newdir <- paste(newpath, "caseStatusOntario", sep = "_")


write.csv(caseStatusOntario,
          file = paste0(newdir, '.csv', collapse = ""), 
          fileEncoding = "UTF-8",
          row.names = FALSE)
