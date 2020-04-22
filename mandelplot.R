#Author: Manuel Almagro Rivas (malmriv@correo.ugr.es)
#Description: generates a .png file of the Mandelbrot set in the selected
#coordinates, with the selected domain. I have followed the nomenclature 
# used in Wikipedia's article on the Mandelbrot set.

#Basic parameters: center the plot and select the half-length of the domain
domain = 8E-12
centerx = -1.476302100815873935234
centery = -0.003547374853168591055

#Create a folder:
dir.create("./mandelplot")

#Choose ad adequate resolution & iterations combination.
resolution = 600
iter = 1700

#This color palette works fine: black - blue - yellow - orange - black.
colpalette = c("#000000","#07090E","#0E121C","#161C2A","#1D2538",
                "#242F46","#2C3854","#334262","#3A4B70","#42557E",
               "#536BA0","#6679A0","#7987A0","#8C96A0","#9FA4A0",
               "#B2B2A0","#C5C1A0","#D8CFA0","#EBDDA0","#FFECA0",
               "#FFE16B","#EFC553","#DFAA3C","#DE7F2C","#D35F17",
               "#A84C12","#7E390D","#542609","#2A1304","#000000")
  
#Domain:
x = seq(-domain,domain,len=resolution) + centerx
y = seq(-domain,domain,len=resolution) + centery
  
#Create a list of complex numbers to evaluate
c = matrix(nrow=resolution,ncol=resolution)
for(i in 1:resolution) {
  for(j in 1:resolution) {
    c[i,j] = x[i]+1i*y[j]
  }
}
  
#Create an empty matrix where the value of the n-th iteration will be saved
#and a vector to assign a color to each
z = matrix(0,nrow=resolution,ncol=resolution)
k = matrix(0,nrow=resolution,ncol=resolution)
  
#Check which complex numbers belong to the Mandelbrot set. R already
# takes care of assigning each integer the adequate pair of  indexes
#in the matrices.
for(i in 1:iter) { 
  j = which(Mod(z) < 2)
  z[j] = z[j]^2 + c[j]
  k[j] = k[j] + 1
}
  
#Create a PNG file, eliminate margins, make axis & bg black and plot
png(paste("./mandelplot/",x,y,".png",sep=""),width=resolution,height=resolution)
par(bg="black",col.lab="black",col.axis="black",mar=c(0,0,0,0))
image(x,y,k,col=colpalette,asp=1)
dev.off()
