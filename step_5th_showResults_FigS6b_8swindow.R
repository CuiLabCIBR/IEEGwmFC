#initiate set
rm(list = ls())
setwd('E:/WMseegBoldFCanalysis/CorrelationAnalysis/Fig2SM_results2fig')
library(ggplot2)
library(R.matlab)
library(ggsci)
library(tidyverse)
library(ggtext)
library(dplyr)
library(gghalves)

#
theme_niwot <- function(){
  theme_bw() +
    theme(text = element_text(family = "Arial"),
          axis.line.x = element_line(color="black",size = 0.6), 
          axis.line.y = element_line(color="black",size = 0.6),
          #axis.ticks.x = element_line(color = 'red'),
          #axis.ticks.y = element_line(color = 'red'),
          axis.text.y = element_text(family = "Arial",size=14, color = "black"),
          panel.border = element_blank(),
          axis.title.x = element_text(margin = margin(t = 10),size=14,
                                      family = "Arial",color="black", hjust = 0.5, vjust = 3),#vjust title到x轴的距离
          axis.title.y = element_text(margin = margin(r = 10),size=14,
                                      family = "Arial",color="black", hjust = 0.5, vjust = 1),
          panel.grid.major.x = element_blank(),                                          
          panel.grid.minor.x = element_blank(),
          panel.grid.minor.y = element_blank(),
          panel.grid.major.y = element_blank(),  
          #plot.margin = unit(c(1, 1, 1, 1), units = ,"cm"),
          legend.title = element_blank(),                          
          legend.key = element_blank(),
          panel.background = element_rect(fill = "white"),
          legend.background = element_rect(color = "black", 
                                           fill = "transparent",size = 2, linetype = "blank"))
}

#main
Matdata <- readMat('Fig2SM8swindow.mat')
Rvalue <- Matdata$Fig2SM8swindow

corr1 = Rvalue[,1]    
corr2 = Rvalue[,2]
corr3 = Rvalue[,3]
corr4 = Rvalue[,4]
corr5 = Rvalue[,5]
corr6 = Rvalue[,6]
corr7 = Rvalue[,7]
F1 = paste(1,4,sep = "-")
F2 = paste(4,8,sep = "-")
F3 = paste(8,13,sep = "-")
F4 = paste(13,30,sep = "-")
F5 = paste(30,40,sep = "-")
F6 = paste(40,70,sep = "-")
F7 = paste(70,170,sep = "-")
mydata <- data.frame(F1 = corr1, F2 = corr2, F3 = corr3, F4 = corr4, F5 = corr5, F6 = corr6, F7 = corr7)
#gather(mydata, key = "group", value = "relation", na.rm = FALSE, convert = FALSE, factor_key = FALSE) 
myiris <- gather(mydata,Species,Relation)  

### violin plot
p <- ggplot(data = myiris, aes(Species,Relation,fill=Species))+
  geom_half_violin(trim = FALSE, color = "white", position = position_nudge(x = 0.15),side=2,alpha = 0.8)+ #平移position = position_nudge(x = 0.15)
  geom_point(aes(y=Relation, color = Species), 
             position = position_jitter(width = 0.08),#圆点距离（圆点抖动程度）
             size = 1.5, alpha = 0.6)+labs(x=NULL)+
  geom_boxplot(width = 0.2, outlier.shape = NA,alpha = 0.8, color = 'black')+
  scale_x_discrete(breaks=c("F1", "F2", "F3","F4","F5","F6","F7"), 
                   labels=c("<span style='color:#E64B35FF'>1-4</span>", 
                            "<span style='color:#4DBBD5FF'>4-8</span>", 
                            "<span style='color:#00A087FF'>8-13</span>",
                            "<span style='color:#3C5488FF'>13-30</span>",
                            "<span style='color:#F39B7FFF'>30-40</span>",
                            "<span style='color:#8491B4FF'>40-70</span>",
                            "<span style='color:#91D1C2FF'>70-170</span>"))+
  labs(y ="Correlation", x = "Frequency band (Hz)") +
  guides(fill = "none", color = "none") +
  scale_color_npg()+scale_fill_npg()+
  theme_niwot()
p

myplot <- p + theme(axis.text.x = element_markdown(family = "Arial",
                                                   angle = 20,
                                                   hjust = 1,
                                                   size = 14))
myplot

ggsave("Fig2SM8swindow_FigS7b.png", plot = myplot, dpi=300, width = 5.50, height = 4.40)




