#initiate set
rm(list = ls())
setwd('E:/WMseegBoldFCanalysis/CorrelationAnalysis/Fig3_results2fig')
library(ggplot2)
library(R.matlab)
library(ggsci)
library(tidyverse)
library(ggtext)
library(dplyr)
library(gghalves)

theme_niwot <- function(){
  theme_bw() +
    theme(text = element_text(family = "Arial"),
          axis.line.x = element_line(color="black",size = 1), 
          axis.line.y = element_line(color="black",size = 1),
          axis.ticks.x = element_line(color="black",size = 1),
          axis.ticks.y = element_line(color="black",size = 1),
          axis.text.x = element_text(family = "Arial",size=22, color = "black"),
          axis.text.y = element_text(family = "Arial",size=22, color = "black"),
          panel.border = element_blank(),
          #plot.margin = unit(c(1, 1, 1, 1), units = ,"cm"),#上
          axis.title.x = element_text(margin = margin(t = 10),size=26,
                                      family = "Arial",color="black", hjust = 0.5, vjust = -1.2),
          axis.title.y = element_text(margin = margin(r = 10),size=26,
                                      family = "Arial",color="black", hjust = 0.5, vjust = 1),
          panel.grid.major.x = element_blank(),                                          
          panel.grid.minor.x = element_blank(),
          panel.grid.minor.y = element_blank(),
          panel.grid.major.y = element_blank(),  
          legend.text = element_text(size = 12,family ="Arial"),          
          legend.title = element_blank(),                          
          legend.key = element_blank(),
          panel.background = element_rect(fill = "white"),
          legend.background = element_rect(color = "black", 
                                           fill = "transparent",size = 2, linetype = "blank"))
}

Matdata <- readMat('Fig3c.mat')
corr1 = Matdata$Fig3c[,1] 
F1 = paste(1,4,sep = "-")
mydata <- data.frame(F1 = corr1)
myiris <- gather(mydata,Species,Relation)  
myplot <- ggplot(myiris)+
  geom_half_violin(aes(x=Species, y=Relation, fill=Species), width = 0.3, trim = FALSE, color = "white",position = position_nudge(x = 0.1),side=1,alpha = 0.8)+
  scale_fill_manual(values = c('#4292c6'))+
  geom_point(aes(x=Species, y=Relation, fill=Species), 
             position = (position_jitter(width = 0.08)),
             size = 1.5, alpha = 0.8)+labs(x=NULL)+
  geom_boxplot(aes(x=Species, y=Relation, fill=Species), width = 0.15, outlier.shape = NA,alpha = 0.8, color='black') +
  scale_x_discrete(breaks=NULL) +
  labs(family = 'Arial',y ="Correlation") +#x = "BOLD FC - DSI SC"
  guides(fill = FALSE, color = FALSE) +
  theme_niwot()

myplot

ggsave("Fig3c_DSISC_BOLDFC_violinplot.png", plot = myplot, dpi=300, width = 5.0, height = 5.0)   #*s
