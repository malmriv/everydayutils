#Load required packages
library(xml2)
library(rvest)
library(stringr)

#Read user related information: user id and number of pages to parse
id = "958982"
pages = 20

#Generate vectors in which we will save info
df = as.data.frame(matrix(data=NA,ncol=3,nrow=10000))

#Generate user URL
url = paste("https://www.filmaffinity.com/en/userratings.php?user_id=",id,sep="")

for(i in 1:pages) {
  url2 = paste(url,"&p=",i,"&orderby=4",sep="")
  rawinfo = read_html(url2)
  #Read titles, directors, ratings
  titles = html_nodes(rawinfo, ".mc-title")
  directors = html_nodes(rawinfo, ".mc-director")
  ratings = html_nodes(rawinfo, ".ur-mr-rat-img")
  
  for(j in 1:length(directors)) {
    
    #Title & director parsing is straightforward by navigating the title vector in Rstudio
    title = xml_attrs(xml_child(titles[[j]], 1))[["title"]]
    title = sub(",","",title)
    director = xml_attrs(xml_child(xml_child(xml_child(directors[[j]], 1), 1), 1))[["title"]]
    
    #Rating parsing is trickier: parsing the rating itself does not return anything,
    #but parsing the .png file with the number of stars returns a URL where the
    #actual rating can be extracted from
    
    rating = sub("/imgs/myratings/","",xml_attrs(xml_child(ratings[[j]], 1))[["src"]])
    rating = sub(".png","",rating)
    rating = sub("_","",rating)
    rating = as.integer(rating)
  
    #Now we add this info to our data frame (unless it's a TV show)
    if(!str_detect(title,"TV")) df[(i-1)*30+j,] = c(title,director,rating)
  }
}

#Change name of the columns and clean the data frame
colnames(df) = c("Title","Directors","Rating10")
df = na.omit(df)

#Save into .csv file
write.csv(df,file="output.csv",row.names=F,quote=F)
