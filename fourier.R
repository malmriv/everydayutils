transfourier = function(time,variable,npeaks) {
  
  #Plot the raw data (turn this line into a comment if unnecessary)
  plot(time,variable,type="l",xlab="time",ylab="variable",main="Variable vs. time")
  
  #Prepare the time series: it should start at zero
  time = time - min(time)
  
  #Measure data series length, and define Nyquist frequency (sampling freq. / 2 ) and frequency range
  n = length(variable)
  dt = time[5]-time[4]
  df = 1/(max(time))
  fnyquist = 1/(2*dt)
  
  #Define a frequency vector of adequate length
  f = seq(-fnyquist,fnyquist,by=df)
  if(length(f) > length(variable)) {
    f = seq(-fnyquist,fnyquist-df,by=df)
  }
  if(length(f) < length(variable)) {
    f = seq(-fnyquist,fnyquist+df,by=df)
  }
  
  #Execute the Fast Fourier Transform algorithm
  mask = rep(c(1,-1),length.out=n)
  spectrum = abs(fft(variable*mask))
  spectrum = spectrum/max(spectrum)
  
  #Plot the graph and show the data
  plot(f,spectrum,main="Relative intensity of each frequency.",xlab="frequency (1/time units)", ylab="rel. intensity",type="l",xlim=c(0,2), col="indianred2")
  polygon(c(0,f),c(0,spectrum),col="azure")
  results = as.data.frame(cbind(f,spectrum))
  
  #Extract frequencies corresponding to peaks.
  K = npeaks
  i = 0
  
  print(paste("Top ",K," frequencies:",sep=""))
  
  while(i<K) {
    maxfreq = which((results$spectrum) == max(results$spectrum))
    maxfreq = maxfreq[1] #Sometimes two or more symmetric peaks have the same intensity
    if(results$f[maxfreq] > 0.0) {
      print(paste("Freq = ",results$f[maxfreq]," - relative intensity = ",results$spectrum[maxfreq]))
      abline(v=results$f[maxfreq],col="navyblue",lty=2)
      results = results[-maxfreq,]
      i = i+1
    }
    if(results$f[maxfreq] < 0.0) {
      results = results[-maxfreq,]
    }
  }

}