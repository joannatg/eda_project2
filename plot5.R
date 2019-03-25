library(dplyr)
library(ggplot2)
library(scales)
library(data.table)


path <- getwd()
download.file(url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
              , destfile = paste(path, "dataFiles.zip", sep = "/"))
unzip(zipfile = "dataFiles.zip")

SCC <- data.table::as.data.table(x = readRDS(file = "Source_Classification_Code.rds"))
NEI <- data.table::as.data.table(x = readRDS(file = "summarySCC_PM25.rds"))

#Question5: How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?

# Gather the subset of the NEI data which corresponds to vehicles
condition <- grepl("vehicle", SCC[, SCC.Level.Two], ignore.case=TRUE)
vehiclesSCC <- SCC[condition, SCC]
vehiclesNEI <- NEI[NEI[, SCC] %in% vehiclesSCC,]

# Subset the vehicles NEI data to Baltimore's fip
baltVehiclesNEI <- vehiclesNEI[fips=="24510",]

png("plot5.png")

ggplot(baltVehiclesNEI,aes(factor(year),Emissions)) +
  geom_bar(stat="identity", fill ="#99d4ff" ,width=0.50) +
  labs(x="Year", y=expression("Total PM"[2.5]*" emission (10^5 tons)")) + 
  labs(title=expression("PM"[2.5]*" Motor vehicle emissions in Baltimore btw. 1999 and 2008"))+theme_bw()+theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())

dev.off()