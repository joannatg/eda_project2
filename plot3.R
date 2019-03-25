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

#Question3: Of the four types of sources indicated by the  (point, nonpoint, onroad, nonroad) variable, which of these four sources have seen decreases in emissions from 1999–2008 for Baltimore City? 
#Which have seen increases in emissions from 1999–2008? 

# Subset NEI data by Baltimore
baltimoreNEI <- NEI[fips=="24510",]

png("plot3.png")

ggplot(baltimoreNEI,aes(factor(year),Emissions,fill=type)) +
  geom_bar(stat="identity") +
  scale_fill_brewer(palette = "Set1")+
  facet_grid(.~type) + 
  labs(x="Year", y=expression("Total PM"[2.5]*" emission (tons)")) + 
  labs(title=expression("PM"[2.5]*" Baltimore, MD emissions btw. 1999 and 2008 by source type"))+theme_bw()+theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())

dev.off()