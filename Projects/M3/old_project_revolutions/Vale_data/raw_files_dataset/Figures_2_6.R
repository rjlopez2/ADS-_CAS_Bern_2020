rm(list=ls())

setwd("where the data is located")


########################################################################################
################              REGIME DATA                    ###########################
########################################################################################

reg <- read.csv("DKW_countryyear.csv")


########################################################################################################
#######################          SOME DESCRIPTIVES WITH THE UN-AGGREGATED DATA    ######################     
########################################################################################################

#creating a regime-change variable
head(reg)
reg$regchange <- ifelse(reg$endyear==reg$year,1,0)


######################################
#figure 2 - regimes over time         ##
######################################

reg2 <- subset(reg, year>1788 & year<2016)
reg2$regime <- 1

regimes <- aggregate(reg2$regime, by=list(reg2$year), FUN=sum)

pdf("fig1_v2.pdf", h=8, w=12)
par(mai=c(1,1.2,1,1))
plot(regimes$Group.1, regimes$x, type="l",
     xlab="Year", ylab="Number of regimes", cex=2.5, cex.lab=2.5, col="red", cex.axis=2)
dev.off()
rm(regimes)


######################################
#figure - regime changes over time##
######################################

rchng <- aggregate(reg2$regchange, by=list(reg2$year), FUN=mean)
pdf("fig2_v2.pdf", h=10, w=16)
par(mai=c(1,1.2,1,1))
plot(rchng$Group.1, rchng$x, type="l",
     xlab="Year", ylab="Avg. regime-changes", cex=2.5, col="red",
     cex.lab=2.5,cex.axis=2 )
dev.off()
rm(rchng)

##########################################
#figure - AVERAGE DURATION OF REGIMES ##
##########################################


dur <- aggregate(reg2$cumulative_duration, by=list(reg2$year), FUN=mean)
head(reg)
pdf("fig3_v2.pdf", h=10, w=16)
par(mai=c(1,1.2,1,1))
plot(dur$Group.1, dur$x, type="l",
     xlab="Year", ylab="Avg. duration of regimes (up until the given year)", cex=1.3, col="red",cex.lab=2.5,cex.axis=2.5)
dev.off()
rm(dur)


##################################################
#figure 6 - Avg number of different regendtypes ##
##################################################

#coup
reg2$v3regendtype <- as.numeric(as.character(reg2$v3regendtype))
reg2$coup <- ifelse((reg2$v3regendtype==1 | reg2$v3regendtype==0) & reg2$regchange==1,1,0)
table(reg2$coup)

#uprising
reg2$uprising <- ifelse(reg2$v3regendtype==8  & reg2$regchange==1,1,0)
table(reg2$uprising)

#loss in war or foreign intervention
reg2$warint <- ifelse((reg2$v3regendtype==6)  & reg2$regchange==1 ,1,0)

#regime-guided liberalization
reg2$reglib <- ifelse(reg2$v3regendtype==9  & reg2$regchange==1,1,0)

cols <- aggregate(with(reg2,cbind(year,coup,uprising,warint,reglib)), by=list(reg2$year), FUN=mean,na.rm=T)

lcoup <- predict(loess(coup ~ year, data=cols, span=0.3))
luprising <- predict(loess(uprising ~ year, data=cols, span=0.3))
lwar <-  predict(loess(warint ~ year, data=cols, span=0.3))
llib <- predict(loess(reglib ~ year, data=cols, span=0.3))

pdf("fig4_v2.pdf", h=10, w=16)
par(mai=c(1,1.2,1,1))
plot(cols$Group.1,cols$coup, col="green", type="n",ylim=c(0,0.04), xlab="year", ylab="Frequency of regime-change type", cex.lab=2.5,cex.axis=2.5)
lines(cols$Group.1,lcoup, col="green", type="l", add=T)
lines(cols$Group.1,luprising, col="red", type="l", add=T)
lines(cols$Group.1,lwar, col="blue", type="l", add=T)
lines(cols$Group.1,llib, col="orange", type="l", add=T)

legend("topleft", c("Coup", "Uprising", "Interstate war", "Guided liberalization"),
       col=c("green", "red", "blue", "orange"), lty=1, cex=2, lwd=3)
dev.off()

##############################################
#figure 5 - Frequency of different endtypes ##
##############################################

#rcoding some strange cases
reg2$v3regendtype[reg2$v3regendtype==0.8] <- 0
reg2$v3regendtype[reg2$v3regendtype==10.7] <- 10

#making identity variable for aggregation
reg2$id <- as.factor(as.character(paste(reg2$v3regstartdate,reg2$v3regenddate,reg2$country_id)))
reg2b <- aggregate(reg2$v3regendtype, FUN=min, by=list(reg2$id))
colnames(reg2b) <- c("regime_id", "v3regendtype")
reg2b$label[reg2b$v3regendtype==0] <- "Military coup"
reg2b$label[reg2b$v3regendtype==1] <- "Coup by other"
reg2b$label[reg2b$v3regendtype==2] <- "Autogolpe"
reg2b$label[reg2b$v3regendtype==3] <- "Assasination"
reg2b$label[reg2b$v3regendtype==4] <- "Natural death of leader"
reg2b$label[reg2b$v3regendtype==5] <- "Civil war"
reg2b$label[reg2b$v3regendtype==6] <- "Inter-state war"
reg2b$label[reg2b$v3regendtype==7] <- "Foreign intervention"
reg2b$label[reg2b$v3regendtype==8] <- "Uprising"
reg2b$label[reg2b$v3regendtype==9] <- "Guided liberalization"
reg2b$label[reg2b$v3regendtype==10] <- "Other guided transformation"
reg2b$label[reg2b$v3regendtype==11] <- "Unguided liberalization"
reg2b$label[reg2b$v3regendtype==12] <- "Other"
reg2b$label[reg2b$v3regendtype==13] <- "Still exists"


freq = sort(table(reg2b$label))
freq = freq / nrow(reg2b)
par(mai=c(1,3,1,1))
#pdf("fig5_v2.pdf")
par(mai=c(1,3,1,1))
barplot(freq,  horiz=T, xlim=c(0,0.25),
        beside=TRUE, las=1, main="Relative frequency of different regime-end types", cex=1.3,cex.lab=4,cex.axis=2) 
#dev.off()
