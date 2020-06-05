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

##plot4 combo
plot.new()
par(mfrow=c(2,2))
##first plot
twoDays$Global_active_power <-as.numeric(twoDays$Global_active_power)
with(twoDays, plot(DateTime,Global_active_power, type = "l",xlab="",ylab = "Global Active Power")) ##type is line
##second plot
twoDays$Voltage <- as.numeric(twoDays$Voltage)
with(twoDays, plot(DateTime, Voltage, type = "l"))
##third plot
plot(twoDays$DateTime,twoDays$Sub_metering_1, xlab="", ylab = "Energy sub metering", type = "n") ##creates empty plot window
twoDays$Sub_metering_1 <- as.numeric(twoDays$Sub_metering_1) ##as nrs
twoDays$Sub_metering_2 <- as.numeric(twoDays$Sub_metering_2)
twoDays$Sub_metering_3 <- as.numeric(twoDays$Sub_metering_3)
with(twoDays, lines(DateTime, Sub_metering_1, type="l", col="black")) ##adds lines to the plot
with(twoDays, lines(DateTime, Sub_metering_2, type="l", col="red"))
with(twoDays, lines(DateTime, Sub_metering_3, type="l", col="blue"))
legend("topright", lty = "solid",col=c("black","red","blue"),legend = c("Sub metering 1","Sub metering 2", "Sub metering 3"))
##fourth plot
twoDays$Global_reactive_power <- as.numeric(twoDays$Global_reactive_power)
with(twoDays, plot(DateTime,Global_reactive_power, type = "l"))
##write png
dev.copy(png,filename = "plot4.png", width = 480, height = 480, units = "px")
dev.off()