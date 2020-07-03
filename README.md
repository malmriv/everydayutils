# R lab
Little R scripts that don't deserve a repository of their own. So far:
  - **coronabot.R**. My first incursion in parsing data from online sources. This script no longer works because the web it read data from changed and I don't think I could gain any knowledge from constantly updating it. Initially it read live info about the coronavirus outbreak and plotted the evolution of the number of cases in different countries.
  - **fourier.R**. Performs a FFT of any time series. Still have to implement an option to account for the presence of any type of up or down-going tendency, but it works fine for most purposes if the data has been nicely formatted.
  - **heatmap.R**. I wrote [a blog post about this](https://malmriv.github.io/posts/2020/02/emoji-heatmap/). This script downloads recent tweets containing a search term and analyses their spatial location, generating a heat map in the process. I think this script is actually very interesting because of its versatility and how quickly it can be tweaked to suit other purposes. Relevant images: [/output/andalucia.png](https://github.com/malmriv/r-lab/blob/master/output/andalucia.png) and [/output/spain-africa.png](https://github.com/malmriv/r-lab/blob/master/output/spain-africa.png).
  - **mandelplot.R**. Generates a nice picture of the selected coordinates in the Mandelbrot set. Can be easily modified to generate zooming animations (see [my guide](https://malmriv.github.io/posts/2020/04/make-animations-with-R/)). Getting clear, aesthetically pleasing images is very computationally intensive, even though I optimized the algorithm using R natively quick indexing features. Nevertheless it's possible to obtain images that illustrate emerging structures with a low number of iterations and a low resolution. Relevant images: [/output/mandelbrot.jpg](https://github.com/malmriv/r-lab/blob/master/output/mandelbrot.jpg) & [/output/mandelgif.gif](https://github.com/malmriv/r-lab/blob/master/output/mandelgif.gif)
  - **randomwalk.R**. I wrote this out of boredom. It generates frames corresponding to a 2D random walk. Relevant images: [/output/randomwalk.gif](https://github.com/malmriv/r-lab/blob/master/output/randomwalk.gif)
  -This is a one liner! The LGTB flag can be generated using this one liner:
  ```R
  image(matrix(data=c(1:6^2),nrow=6,ncol=6),asp=0.6,axes=F,col=c(rainbow(3,rev=T,start=0.35,end=0.82,v=0.9),rainbow(3,rev=T,start=0,end=0.18)))
  ```
Which results in:
![](https://github.com/malmriv/malmriv.github.io/blob/master/_posts/images/flag.png?raw=true)
(The trick is to plot a matrix with increasing values using only six different colours picked from a rainbow palette; the aspect ratio can be set to an adequate value, and the axix and labels can be turned off).
