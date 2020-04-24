#Define number of steps and directory to save the frames
N = 1000
dir = "./randomwalk"
dir.create(dir)

#Generate two all-zero vectors of length N
x=seq(0,0,len=N)
y=seq(0,0,len=N)

#Then, generate the random steps in one direction, picking from a uniform distribution
xrand = runif(N,min=-0.0001,max=0.0001)

#If we want to test the prediction we need a constant step length, which we decide to be the span of the interval we picked values from
yrand = seq(0,0,len=N)
for(i in 1:N) {
  yrand[i]=sqrt(abs(0.0001^2-xrand[i]^2)) #This is just Pythagoras
  yrand[i]=yrand[i]*(-1)^as.integer(runif(1,min=0,max=99)) #This randomizes the sign of each y-direction step
}

#Define each element of the vectors as the previous one plus a random step
for(i in 2:N) {
  x[i] = x[i-1]+xrand[i]
  y[i] = y[i-1]+yrand[i]
}

#Generate the frames of the gif. If no limits are defined for each axis, the gif will gradually zoom out as the "particle" gets further from the origin, which is visually nice
for(i in 2:N) {
  if(i%%4 == 0) { #I decided to pick only every 5th frame, since I'm considering using large N values
    png(filename=paste(dir,"/",i,".png",sep=""),width=450,height=400,type="quartz")
    plot(x[1:i],y[1:i],asp=1,type="l",col="darkblue",xlab="x",ylab="y",main="Random walk.")
    lines(x[i],y[i],type="p",col="red",cex=1.5)
    dev.off()
  }
}
