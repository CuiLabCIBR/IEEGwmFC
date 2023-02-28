#initiate set
rm(list = ls())
setwd('E:/WMseegBoldFCanalysis/CorrelationAnalysis/Fig1_results2fig')
library(ggplot2)
library(R.matlab)
library(ggsci)
library(tidyverse)
library(ggtext)
library(dplyr)

#main
Matdata <- readMat('Fig1d_barplot_sub01_spermanSEEGFCBOLDFC.mat')
BOLDSEEGcorr = Matdata$Fig1d
corr = t(BOLDSEEGcorr)
xname <- c("1-4", "4-8", "8-13", "13-30", "30-40", "40-70", "70-170")
fname <- c("F1", "F2", "F3", "F4", "F5", "F6", "F7");
fname <- factor(fname)
Rdata <- data.frame(xname,fname,corr)
### plot the bar fig
p <- ggplot(data = Rdata,aes(x = fname, y = corr, fill=fname)) + 
  geom_bar(stat = 'identity', width = 0.8, size = 0.5, alpha = 0.8,color = 'black')+
  scale_x_discrete(breaks=c("F1", "F2", "F3","F4","F5","F6","F7"), 
                   labels=c("<span style='color:#E64B35FF'>1-4</span>", 
                            "<span style='color:#4DBBD5FF'>4-8</span>", 
                            "<span style='color:#00A087FF'>8-13</span>",
                            "<span style='color:#3C5488FF'>13-30</span>",
                            "<span style='color:#F39B7FFF'>30-40</span>",
                            "<span style='color:#8491B4FF'>40-70</span>",
                            "<span style='color:#91D1C2FF'>70-170</span>"))+
  scale_y_continuous(breaks=c(0, 0.2, 0.4, 0.6, 0.8), labels=c("0","0.2","0.4", "0.6", "0.8"),limits =c(0, 0.7) ,expand = c(0,0))+  ## 将刻度线放在（0, 0.2, 0.4, 0.6）的位置
  labs(y ="Correlation", x = "Frequency band (Hz)")+
  guides(fill = FALSE, color = FALSE) +
  scale_color_npg()+scale_fill_npg()+
  theme_bw() +
  theme(text = element_text(family = "Arial"),
        axis.line.x = element_line(color="black",size = 0.8), 
        axis.line.y = element_line(color="black",size = 0.8),
        axis.ticks.x = element_line(color="black",size = 0.8),
        axis.ticks.y = element_line(color="black",size = 0.8),
        
        axis.text.y = element_text(family = "Arial",size=24, color = "black"),
        
        axis.title.x = element_text(margin = margin(t = 10),size=25,
                                    family = "Arial",color="black", hjust = 0.5, vjust = 3),
        axis.title.y = element_text(margin = margin(r = 10),size=25,
                                    family = "Arial",color="black", hjust = 0.5, vjust = 0),
        panel.border = element_blank(),
        plot.margin = unit(c(1, 0, 0, 0), units = ,"cm"),#上
        panel.background = element_rect(fill = "white"),
        panel.grid.major.x = element_blank(),                                          
        panel.grid.minor.x = element_blank(), #panel.grid.minor.x = element_blank()表示x轴方向不添加虚线
        panel.grid.minor.y = element_blank(),
        panel.grid.major.y = element_blank(),  
        legend.text = element_text(size = 12,family ="Arial"),          
        legend.title = element_blank(),                          
        legend.key = element_blank(),
        
        legend.background = element_rect(color = "black", 
                                         fill = "transparent",size = 2, linetype = "blank"))
  #scale_y_continuous(limits =c(0, 1) ,expand = c(0,0))#将直方图的柱子与x轴连接一起
 

myplot <- p + theme(axis.text.x = element_markdown(family = "Arial",
                                         angle = 30,
                                         hjust = 1,
                                         size = 24))
myplot

ggsave("Fig1d_barplot_sub01_Rvalue.png", plot = myplot, dpi=300, width = 5.5, height = 5.5)

