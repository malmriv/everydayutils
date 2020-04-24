# R lab
Little R scripts that don't deserve a repository of their own. So far:
  - **coronabot.R**. My first incursion in parsing data from webs. This script no longer works because the web it read data from changed and I don't think I could gain any knowledge from constantly updating it. Originally, it read live info about the coronavirus outbreak and plotted the evolution of the number of cases in different countries.
  - **fourier.R**. Performs a FFT of any time series. Still have to implement an option to account for the presence of any type of up or down-going tendency, but it works fine for most purposes if the data has been nicely formatted.
  - **heatmap.R**. I wrote [a blog post about this](https://malmriv.github.io/posts/2020/02/emoji-heatmap/). I think this script is actually very interesting, because of its versatility and how quickly it can be tweaked to suit other purposes. Relevant images: /output/andalucia.png and /output/spain-africa.png.
  - **mandelplot.R**. Generates a nice picture of the selected coordinates in the Mandelbrot set. Can be easily modified to generate zooming animations (see [my guide](https://malmriv.github.io/posts/2020/04/make-animations-with-R/)). Relevant images: /output/mandelbrot.png
  - **randomwalk.R**. I write this one out of boredom. It generates frames corresponding to a 2D random walk. Relevant images: /output/randomwalk.gif
