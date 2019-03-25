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

#Question6: Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle sources in Los Angeles County, California. 
#Which city has seen greater changes over time in motor vehicle emissions?

# Gather the subset of the NEI data which corresponds to vehicles
condition <- grepl("vehicle", SCC[, SCC.Level.Two], ignore.case=TRUE)
vehSCC <- SCC[condition, SCC]
vehNEI <- NEI[NEI[, SCC] %in% vehSCC,]

# Subset the vehicles NEI data by each city's fip and add city name.
vehBaltimoreNEI <- vehNEI[fips == "24510",]
vehBaltimoreNEI[, city := c("Baltimore, MD")]

vehNEI <- vehNEI[fips == "06037",]
vehNEI[, city := c("Los Angeles, CA")]

# Combine data.tables into one data.table
bothNEI <- rbind(vehBaltimoreNEI,vehNEI)

png("plot6.png")

ggplot(bothNEI, aes(x=factor(year), y=Emissions, fill=City)) +
  geom_bar(aes(fill=year),stat="identity") +
  facet_grid(scales="free", space="free", .~city) +
  labs(x="Year", y=expression("Total PM"[2.5]*" emission (kilo-tons)")) + 
  labs(title=expression("PM"[2.5]*" Motor vehicle emissions in Baltimore, MD and Los Angeles, CA \n btw. 1999 and 2008"))+theme_bw()+theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())


dev.off()