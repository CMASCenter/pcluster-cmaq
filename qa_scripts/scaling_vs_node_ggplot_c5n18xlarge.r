library(ggplot2)
library(patchwork) # To display 2 charts together

# Script author: Liz Adams
# Affiliation: UNC CMAS Center 
# example from http://monashbioinformaticsplatform.github.io/2015-11-30-intro-r/ggplot.html
# 2nd example from https://r-graph-gallery.com/line-chart-dual-Y-axis-ggplot2.html

png(file = paste('c5n18xlarge','_','Scaling','_','Node','.png',sep=''), width = 1024, height = 768, bg='white')
csv_data<- read.csv("/shared/pcluster-cmaq/docs/user_guide_pcluster/qa/scaling_c5n18xlarge.csv",sep="\t", skip =0, header = TRUE, comment.char = "",check.names = FALSE, quote="", )
print(csv_data)
p1 <- ggplot(csv_data, aes(y=Scaling, x=Nodes, size=SBATCHexclusive, color=COLROW, size=CPUs)) +
    geom_point() + ggtitle("2 Day Benchmark Scaling versus Node (36cpu/node) using c5n.18xlarge") + xlim(0,8) + ylim(0,8)
    

p2 <- ggplot(csv_data, aes(y=Efficiency, x=Nodes, size=SBATCHexclusive, color=COLROW, size=CPUs)) +
    geom_point() + ggtitle("2 Day Benchmark Parallel Efficiency versus Node (36cpu/node) using c5n.18xlarge")

# Display both charts side by side thanks to the patchwork package
p1 + geom_abline(intercept = 0, slope = 1) + p2
