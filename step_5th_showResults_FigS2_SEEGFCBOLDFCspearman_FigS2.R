#initiate set
rm(list = ls())
setwd('E:/WMseegBoldFCanalysis/CorrelationAnalysis/Fig2SM_results2fig')
library(ggplot2)
library(R.matlab)
library(ggsci)
library(tidyverse)
library(ggtext)
library(dplyr)
library(ggpubr)
library(cowplot)

#
#
theme_niwot <- function(){
    theme_bw() +
    theme(text = element_text(family = "Arial"),
          axis.line.x = element_line(color="black",size = 0.8), 
          axis.line.y = element_line(color="black",size = 0.8),
          axis.ticks.x = element_line(color="black",size = 0.8),
          axis.ticks.y = element_line(color="black",size = 0.8),
          
          axis.text.x = element_markdown(family = "Arial", angle = 30, hjust = 1, size = 28),
          axis.text.y = element_text(family = "Arial", size=26, color = "black"),
          
          axis.title.x = element_text(margin = margin(t = 10),size=30,
                                      family = "Arial",color="black", hjust = 0.5, vjust = 0),
          axis.title.y = element_text(margin = margin(r = 10),size=30,
                                      family = "Arial",color="black", hjust = 0.5, vjust = 0),
          panel.border = element_blank(),
          plot.margin = unit(c(1, 1, 1, 1), "lines"),
          panel.background = element_rect(fill = "white"),
          panel.grid.major.x = element_blank(),                                          
          panel.grid.minor.x = element_blank(), #panel.grid.minor.x = element_blank()表示x轴方向不添加虚线
          panel.grid.minor.y = element_blank(),
          panel.grid.major.y = element_blank(),  
          legend.text = element_text(size = 12,family ="Arial"),          
          legend.title = element_blank(),                          
          legend.key = element_blank(),
          plot.title = element_text(family = "Arial", color = "black", size = 30, hjust=0.5),
          
          legend.background = element_rect(color = "black", 
                                           fill = "transparent",size = 2, linetype = "blank"))
}

#main
#sub02
Matdata <- readMat('Fig2SMSEEGFCBOLDFCspearman_FigS2.mat')
plotlist = list()
for (subNum in 1:15) {
  BOLDSEEGcorr = Matdata$Fig2SMSEEGFCBOLDFCspearman[subNum,]
  BOLDSEEGcorrP = Matdata$Fig2SMSEEGFCBOLDFCspearmanP[subNum,]
  corr = BOLDSEEGcorr
  xname <- c("1-4", "4-8", "8-13", "13-30", "30-40", "40-70", "70-170")
  fname <- c("F1", "F2", "F3", "F4", "F5", "F6", "F7");
  fname <- factor(fname)
  Rdata <- data.frame(xname,fname,corr)
  subID <- paste("sub", as.character(subNum+1), sep = "")
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
              scale_y_continuous(breaks=c(0, 0.2, 0.4, 0.6, 0.8), labels=c("0","0.2","0.4", "0.6", "0.8"),limits =c(0, 0.7) ,expand = c(0,0))+
              labs(title = subID, y ="Correlation", x = "Frequency band (Hz)")+
              guides(fill = FALSE, color = FALSE) +
              scale_color_npg() + 
              scale_fill_npg() + 
              theme_niwot()
  for (i in 1:7) {
    if (BOLDSEEGcorrP[i] < 0.001){
      p <- p + annotate("text", x=i, y=Rdata$corr[i]+0.02, label="**", size = 13)
    }else if (BOLDSEEGcorrP[i] < 0.05){
      p <- p + annotate("text", x=i, y=Rdata$corr[i]+0.02, label="*", size = 13)
    }
  }
  p
  plotlist[[subNum]] = p
}
mp <- plot_grid(plotlist = plotlist, 
                labels = c("a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o"),
                ncol = 3, label_size = 30, label_fontfamily = "Arial")
ggsave("Fig2SMSEEGFCBOLDFCspearman_FigS2.png", plot = mp, dpi = 300, width = 21, height = 30)
