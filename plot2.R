##create data directory and download data
if (!file.exists("data")){
      dir.create("data")
}
fileUrl<- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
if (!file.exists("data/household_power_consumption.txt")){
      download.file(fileUrl, destfile="data/household_power_consumption.zip")
      dateDownloaded<-date() ##saves date
      print(dateDownloaded)
      unzip("data/household_power_consumption.zip",exdir="data")
}
list.files(".data")

##read file
myData <- read.table("data/household_power_consumption.txt", header = TRUE, sep=";", na.strings="?", stringsAsFactors = FALSE)

##convert dates
library(dplyr)
library(lubridate)
myData$DateTime <- with(myData, dmy(Date)+hms(Time))
twoDays <- filter(myData, Date == "1/2/2007" | Date == "2/2/2007" ) ##dates filter
##twoDays$Day <- wday(myData$Date, label=TRUE)

##plot2 power timeline
plot.new()
par(mfrow=c(1,1))
twoDays$Global_active_power <-as.numeric(twoDays$Global_active_power)
with(twoDays, plot(DateTime,Global_active_power, type = "l",ylab = "Global Active Power (kilowatts)")) ##type is line
dev.copy(png,filename = "plot2.png", width = 480, height = 480, units = "px")
dev.off()
