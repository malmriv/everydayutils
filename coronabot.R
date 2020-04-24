#URL from which information will be extracted
url = "https://www.worldometers.info/coronavirus/#countries"
#Load the necessary libraries:
library(XML)
library(RCurl)
library(twitteR)

#Connect to Twitter:
consumerKey='xxx'
consumerSecret='xxx'
accessToken='xxx'
accessTokenSecret='xxx'
setup_twitter_oauth(consumerKey,consumerSecret,accessToken,accessTokenSecret)

#Load the info from the URL:
rawdata = getURL(url)
#Load the relevant information (the table):
data = readHTMLTable(rawdata,stringsAsFactors = FALSE)
table = data$main_table_countries

#Format the table as needed (in this case, deleting non-decimal commas,
#avoiding NA's and coercing entries into being numeric and not strings"
for(i in 2:7) table[,i] = as.integer(sub(",","", table[,i], fixed = TRUE))
table = replace(table, is.na(table), 0)
table = replace(table, is.null(table),0)


#Extract concrete bits of information:
deaths = sum(table[,4])
cases = sum(table[,2])
recovered = sum(table[,6])


tablerank=table[-which.max(table[,3]),]

#Generate the title, the file and the graph:
title = paste("Nuevos casos por país con fecha ",format(Sys.time(), "%d %b %Y")," (limitado a 40 países)",sep="")
png("./graph.png",width=700,height=450)
barplot(tablerank$NewCases[1:40],names.arg=tablerank$`Country,Other`[1:40],main=title,cex.main=1.6,cex.lab=1.1,ylab="Casos (número absoluto)",col="lightblue",las=2)
dev.off()

#Publish the tweets:
tweet(paste("Número de nuevos casos por país con fecha",format(Sys.time(), "%d %b %Y"),"— Se ha omitido el país con mayor número de casos por motivos de claridad:",table[which.max(table[,3]),1],"con",table[which.max(table[,3]),3],"nuevas infecciones."),mediaPath="./graph.png",bypassCharLimit=TRUE)
tweet(paste("El país con mayor densidad de casos es ",table[which.max(table[,9]),1]," con ",table[which.max(table[,9]),9]," casos por cada millón de habitantes.",sep=""))
