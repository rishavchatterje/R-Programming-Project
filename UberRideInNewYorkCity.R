
# really nice way to install packages if they are not installed using require.
if (!require('ggplot2')) install.packages('ggplot2')
if (!require('readr')) install.packages('readr')
if (!require('animation')) install.packages('animation')

# Data visualization
library(ggplot2)
library(readr)
# Animation
library(animation)

# set the directory to be - change to your directory.
setwd("~/dev/r/uber")

# Input data files are available in the "input/" directory.
uber = read.csv('input/uber-raw-data-sep14.csv', stringsAsFactors = F)

# create a new column for date.
uber$Date = sapply(strsplit(uber$Date.Time, split = " "), function(x) x[[1]][1])
uber$Date = as.Date(uber$Date, format = "%m/%d/%Y")
uber = uber[order(uber$Date),]

# used to size the initial canvas
min_long = min(uber$Lon)
max_long = max(uber$Lon)
min_lat = min(uber$Lat)
max_lat = max(uber$Lat)

l = length(uber$Date.Time)
i = 1

# create an animated gif - which takes the data 25000 at a time
# for each panel of the gif - also include the day in the gif.
saveGIF(while (i <= l) {
  print(m <- ggplot(data=uber[1:i,],aes(Lon[1:i],Lat[1:i])) + 
          geom_point(size=0.06, color="white", alpha = 0.2) +
          scale_x_continuous(limits=c(min_long, max_long)) +
          scale_y_continuous(limits=c(min_lat, max_lat)) +
          theme(panel.background = element_rect(fill = "black"),
                panel.grid.major = element_blank(),
                panel.grid.minor = element_blank()) +
          annotate("text", x =-73.0, y=41.2, label = uber$Date[i], colour = 'white', size = 8))
  i = i+25000
}, movie.name = "uber.gif", interval = 0.1, convert = "convert", ani.width = 800, ani.height = 800)