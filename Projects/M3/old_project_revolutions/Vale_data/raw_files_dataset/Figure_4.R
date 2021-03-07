rm(list=ls())

setwd("where the data is located")

########################################################################################
################              REGIME DATA                    ###########################
########################################################################################

reg <- read.csv("DKW_countryyear.csv")

reg <- subset(reg, endyear==1848 & year==1848)
reg <- subset(reg, country.name!="Bolivia" & country.name!="Mexico" & country.name!="Guatemala" & country.name!="Canada"  )


#recoding prussia (fixing)
reg$endyear[reg$startyear==1701 & reg$endyear==1848] <- 1813
reg <- subset(reg, endyear!=1813)

reg$Date <- as.Date(reg$v3regenddate, "%d/%m/%Y")
reg$event <- 1


pdf("1848.pdf", h=8, w=10)
plot( reg$Date, reg$duration, xaxt="n", type = "h",  lwd=2, col="red",
      ylim=c(0,160),xlab="Date of regime change", ylab="Duration of regime (years)", main="Dated regime changes in Europe in 1848")
axis(1, reg$Date, format(reg$Date, "%b %d"), cex.axis = .8)
text(reg$Date, reg$duration+9, labels=reg$country.name, cex= .8, srt = 90)
dev.off()