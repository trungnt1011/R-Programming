# Get/set your working directorry
getwd()
setwd("C:/Users/trungnt/Data Science")

# Checking for and creating directories
if(!file.exists("Get and Clean Data")){
	dir.create("Get and Clean Data")
}
setwd("./Get and Clean Data")

# Getting data from the internet - download.file()
# Important parameters are: url, destfile, method
fileUrl <- "http://data.baltimorecity.gov/api/views/dz54-2aru/rows.csv?accessType=DOWNLOAD"
download.file(fileUrl, destfile = "./camera.csv") # Sometime: method = "curl"
dateDownloaded <- date()

# Loading flat files - read.table()
# Read the data into Ram - big data can cause problems (big data co the gay van de)
# Important parameters: file, header, sep, row.names, nrows
# Relatedd: read.csv(), read.csv2() 	(#ham lien quan)
cameraData <- read.table("camera.csv", sep = ",", header = TRUE)
head(cameraData)
# Some more important parameters
# quote: You can tell R whether there are any quoted values quote = "" mean no quotes.
# na.strings - set the character that represents a missing value.
# skip - number of lines to skips before starting to read.

# Reading Excel files
fileUrl2 <- "http://data.baltimorecity.gov/api/views/dz54-2aru/rows.xlsx?accessType=DOWNLOAD"
download.file(fileUrl2, destfile = "./cameras.xlsx")

















