library(ggplot2)
library(patchwork) # To display 2 charts together

# Script author: Liz Adams
# Affiliation: UNC CMAS Center 
# example from http://monashbioinformaticsplatform.github.io/2015-11-30-intro-r/ggplot.html
# 2nd example from https://r-graph-gallery.com/line-chart-dual-Y-axis-ggplot2.html

png(file = paste('c5n9xlarge','_','Time','_','CPUs','.png',sep=''), width = 1024, height = 768, bg='white')
csv_data<- read.csv("/shared/pcluster-cmaq/docs/user_guide_pcluster/qa/timing_c5n9xlarge.csv",sep="\t", skip =0, header = TRUE, comment.char = "",check.names = FALSE, quote="", )
print(csv_data)
p1 <- ggplot(csv_data, aes(y=TotalTime, x=CPUs, size=InputData, color=COLROW)) +
    geom_point() + ggtitle("2 Day Benchmark Total Time versus CPUs")

p2 <- ggplot(csv_data, aes(y=OnDemandCost, x=CPUs, size=InputData, color=COLROW)) +
    geom_point() + ggtitle("2 Day Benchmark On Demand Cost versus CPUs")

# Display both charts side by side thanks to the patchwork package
p1 + p2
