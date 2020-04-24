#Import libraries
library(rtweet)
library(ggplot2)
library(ggmap)
library(RColorBrewer)

#Define the string to search and the number of tweets to find:
lookthisup = "whatever"
number=20000

#PART ONE. Downloading the tweets.
#Download a large number of tweets containing the string stored in 'lookthisup'
tweets=search_tweets(lookthisup,n=number,include_rts=FALSE, retryonratelimit=TRUE)

#Extract the geolocation info
geoinfo=lat_lng(tweets)

#Store latitude and longitude in a data frame, avoiding the NA-valued cells.
#Saving the information in a .csv file is a good idea, since importing tweets is time-consuming.
coordinates = na.omit(data.frame(cbind(geoinfo$lat,geoinfo$lng)))
colnames(coordinates)=c("Latitude","Longitude")
write.table(coordinates,file="./coordinates.txt",sep=",",dec=".")

#PART TWO. Importing the data and analysing it.
usefulinfo = read.csv("./coordinates.txt")

#Define the boundaries of the areas we want to study. Google Maps can be used for this.
area = c(left = -10, bottom = 35, right = 4, top = 45)

#Configure the map for each area:
coords_area = get_stamenmap(area, zoom = 7, maptype = "toner-lite")

#Configure the heat maps:
coords_area = ggmap(coords_area, extent="device", legend="none")
coords_area = coords_area + stat_density2d(data=usefulinfo,  aes(x=Longitude, y=Latitude, fill=..level.., alpha=..level..), geom="polygon")
coords_area = coords_area +   scale_fill_gradientn(colours=rev(brewer.pal(7, "Spectral")))

#Generate and save the images
coords_area = coords_area + theme_bw()
ggsave(filename="./area.png")

