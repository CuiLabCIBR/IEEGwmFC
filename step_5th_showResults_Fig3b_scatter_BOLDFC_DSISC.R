#initiate set
rm(list = ls())
setwd('E:/WMseegBoldFCanalysis/CorrelationAnalysis/Fig3_results2fig')
library('ggplot2')
library('R.matlab')
library('ggsci')

#
theme_niwot <- function(){
  theme_bw() +
    theme(text = element_text(family = "Arial"),
          axis.line.x = element_line(color="black",size = 1.0), 
          axis.line.y = element_line(color="black",size = 1.0),
          axis.ticks.x = element_line(color="black",size = 1.0),
          axis.ticks.y = element_line(color="black",size = 1.0),
          
          axis.text.x = element_text(family = "Arial",size=26, color = "black"),
          axis.text.y = element_text(family = "Arial",size=26, color = "black"),
          
          panel.border = element_blank(),
          
          axis.title.x = element_text(margin = margin(t = 10),size=27,
                                      family = "Arial",color="black", hjust = 0.5, vjust = 0.5),
          axis.title.y = element_text(margin = margin(r = 10),size=27,
                                      family = "Arial",color="black", hjust = 0.5, vjust = 0),
          
          panel.grid.major.x = element_blank(),                                          
          panel.grid.minor.x = element_blank(),
          panel.grid.minor.y = element_blank(),
          panel.grid.major.y = element_blank(),  
          
          legend.text = element_text(size = 20,family ="Arial"),          
          legend.title = element_blank(),                          
          legend.key = element_blank(),
          panel.background = element_rect(fill = "white"),
          legend.background = element_rect(color = "black", 
                                           fill = "transparent",size = 2, linetype = "blank"))
}


#main function
Data <- readMat('Fig3b.mat')
DsiSCboldFC = data.frame(DSISC = as.numeric(Data$Fig3b[1, 1:511]))
DsiSCboldFC$BOLDFC = as.numeric(Data$Fig3b[2, 1:511])
p <- ggplot(DsiSCboldFC, aes(DSISC, BOLDFC)) + 
  geom_point(color="gray78", size=2) + 
  labs(x = "log(SC)", y = "BOLD FC") +
  geom_smooth(color = 'black', formula = y ~ x, fill = "gray78", method = "lm", size=1) + 
  scale_x_continuous(breaks=seq(-1, 4, 1), labels = c(-1, 0, 1, 2, 3, 4), limits = c(-1.6,2.3)) +
  scale_y_continuous(breaks=seq(-0.6, 0.9, 0.3), labels = c(-0.6, -0.3, 0, 0.3, 0.6, 0.9), limits = c(-0.7, 0.7)) +
  scale_color_npg() + 
  scale_fill_npg() +
  theme_niwot()
p
#save fig
ggsave("Fig3b_dsisc_boldfc.png", plot = p, dpi=300, width = 6.2, height = 5.3)
