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

#Question4: Across the United States, how have emissions from coal combustion-related sources changed from 1999–2008?

# Subset coal combustion related NEI data
combRel <- grepl("comb", SCC[, SCC.Level.One], ignore.case=TRUE)
coalRel <- grepl("coal", SCC[, SCC.Level.Four], ignore.case=TRUE) 
combSCC <- SCC[combRel & coalRel, SCC]
combNEI <- NEI[NEI[,SCC] %in% combSCC ]

png("plot4.png")

ggplot(combNEI,aes(x = factor(year),y = Emissions/10^5)) +
  geom_bar(stat="identity", fill ="#99d4ff", width=0.50) +
  labs(x="Year", y=expression("Total PM"[2.5]*" emission (10^5 tons)")) + 
  labs(title=expression("PM"[2.5]*" Coal combustion emissions in US btw.1999 and 2008"))+theme_bw()+theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())

dev.off()