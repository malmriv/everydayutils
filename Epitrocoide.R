#Trayectoria básica
theta = seq(0,2*pi,len=500)
R = runif(1,min=0.5,max=1.5)
r = R/floor(runif(1,min=1,max=10))
h = runif(1,min=r/2,max=R/2)
xtraj = (R+r)*cos(theta) + (r-h)*cos((R+r)/r*theta)
ytraj = (R+r)*sin(theta) + (r-h)*sin((R+r)/r*theta)


#Función dibujar circulo
dibuCirc = function(x,y,R) polygon(R*cos(theta)+x,R*sin(theta)+y,
            col=rgb(1,0,0.2,0.2), lwd=1.5)

#Animación
dir.create("./animacion")
for(k in 1:length(theta)) {
  png(paste("animacion/",k,".png",sep=""),width=900,height=900)
  plot(0,0,type="n",asp=1,xlim=c(-1.5*(R+r),1.5*(R+r)),
       xaxt="n",yaxt="n",xlab=NA,ylab=NA,frame=F,bg=NA)
  dibuCirc(0,0,R)
  dibuCirc((R+r)*cos(theta[k]),(R+r)*sin(theta[k]),r)
  x = (R+r)*cos(theta[k]) + (r-h)*cos((R+r)/r*theta[k])
  y = (R+r)*sin(theta[k]) + (r-h)*sin((R+r)/r*theta[k])
  arrows((R+r)*cos(theta[k]),(R+r)*sin(theta[k]),x,y,length=0,angle=0)
  lines(xtraj[1:k],ytraj[1:k],cex=0.1,col="black")
  dev.off()
}


