

rm(list=ls())
setwd("C:/Users/torewig_adm/Dropbox/Regimes and types of breakdowns paper/Data")
library(changepoint)
library(MCMCpack)
library(coda)
library(haven)
data <- read_dta("data_v3.dta")

#TRYING THIS OUT WITH REGEND
names(data)
data$regchange <- data$regchange
c <- aggregate(data$regchange, by=list(data$year), FUN=mean, na.rm=T)
colnames(c) <- c("year", "regtrans")
c <- c[order(c$year),]

c2 <- as.ts(c$regtrans, start=1789)

summary(c2)
sd(c2)

fit.1 <- MCMCregressChange(c2 ~ 1, m=4,
                           b0=mean(c2), B0=0.035, c0=0.001, d0=0.001,
                           burnin=1000, mcmc=30000, thin=10, verbose=0)
summary(fit.1)
names(fit.1)
structure(fit.1)
pdf("regendchangepoints_v2.pdf",h=8,w=12)
plotState(fit.1, start=1789, main="Posterior probability of different states (All transitions)", )
dev.off()


pdf("regendchangepoints2_v2.pdf")
plotChangepoint(fit.1, start=1789, main="Posterior probability of change-points (All transitions)")
dev.off()


points <- plotChangepoint(fit.1, start=1789, main="Posterior probability of change-points (All transitions)")
print(points)
change
pdf("regendchangepoints3_v2.pdf", h=8,w=12)
par(mfrow=c(1,1))

c3 <- data.frame(c2)
years <- seq(from=1, to=227, by=1)
years2 <- years+1789
c3 <- cbind(c3, years2)
loess <- predict(loess(c3$c2 ~ c3$years, span=0.3))

plot(c3$years,c3$c2, type="l", xlab="Year", ylab="% of countries experiencing regime change",
     col="red", lwd=1, main="% regime changes and change-points, 1789-2016", cex.axis=1.5,cex.lab=1.5)
lines(c3$years,loess, col="grey", type="l", add=T,lwd=6)
for(i in 1:4){
  abline(v=points[i], col="blue", lwd=2) 
  text(points[i]+8,.16, paste(points[i]), col = "black", cex=1.2) 
}
legend("bottomright", legend=c("Frequency", "Changepoint", "Loess smoothed average"), col=c("red", "blue", "grey"), lwd=2)
dev.off()



####USING THE ABOVE CHAGE POINT FUNCTIONS TO ANALYZE COUPS, UPRISINGS AND LIBERALIZATION


###############COUPS
data$regtrans <- data$coup
name <- "coups"

  c <- aggregate(data$regtrans, by=list(data$year), FUN=mean, na.rm=T)
  colnames(c) <- c("year", "regchange")
  c <- c[order(c$year),]
  c2 <- as.ts(c$regchange, start=1789)

  fit.1 <- MCMCregressChange(c2 ~ 1, m=2,
                             b0=mean(c2), B0=sd(c2), c0=0.001, d0=0.001,
                             burnin=1000, mcmc=30000, thin=10, verbose=0)
  
  pdf(paste(name,"changepoints.pdf"),h=8,w=12)
  plot1 <- plotState(fit.1, start=1789, main=paste("Posterior probability of different states (",name,")"))
  dev.off()
  
  pdf(paste(name,"changepoints2.pdf"))
  plotChangepoint(fit.1, start=1789, main=paste("Posterior probability of change-points (",name,")"))
  dev.off()
  
  points <- plotChangepoint(fit.1, start=1789)
  print(points)
  
  pdf(paste(name,"changepoints3.pdf"),h=8,w=12)
  par(mfrow=c(1,1))
  c3 <- data.frame(c2)
  years <- seq(from=1, to=227, by=1)
  years2 <- years+1789
  c3 <- cbind(c3, years2)
  loess <- predict(loess(c3$c2 ~ c3$years, span=0.3))

  plot(c3$years,c3$c2, type="l", xlab="Year", ylab=paste("% of countries experiencing",name),
       col="red", lwd=1, main=paste("%",name,"and change-points, 1789-2016"))
  
  lines(c3$years,loess, col="grey", type="l", add=T,lwd=6)
  for(i in 1:2){
    abline(v=points[i], col="blue", lwd=2) 
    text(points[i]+8,.06, paste(points[i]), col = "black", cex=1.2) 
  }
  legend("bottomright", legend=c("Frequency", "Changepoint", "Loess smoothed average"), col=c("red", "blue", "grey"), lwd=2)
  dev.off()
  

  
####UPRISINGS

  data$regtrans <- data$uprising
  name <- "uprisings"
  
  c <- aggregate(data$regtrans, by=list(data$year), FUN=mean, na.rm=T)
  colnames(c) <- c("year", "regchange")
  c <- c[order(c$year),]
  c2 <- as.ts(c$regchange, start=1789)
  
  fit.1 <- MCMCregressChange(c2 ~ 1, m=6,
                             b0=mean(c2), B0=sd(c2), c0=0.001, d0=0.001,
                             burnin=1000, mcmc=30000, thin=10, verbose=0)
  
  pdf(paste(name,"changepoints.pdf"), h=8, w=12)
  plot1 <- plotState(fit.1, start=1789, main=paste("Posterior probability of different states (",name,")"))
  dev.off()
  
  pdf(paste(name,"changepoints2.pdf"))
  plotChangepoint(fit.1, start=1789, main=paste("Posterior probability of change-points (",name,")"))
  dev.off()
  
  points <- plotChangepoint(fit.1, start=1789)
  print(points)
  
  pdf(paste(name,"changepoints3.pdf"), h=8, w=12)
  par(mfrow=c(1,1))
  c3 <- data.frame(c2)
  years <- seq(from=1, to=227, by=1)
  years2 <- years+1789
  c3 <- cbind(c3, years2)
  loess <- predict(loess(c3$c2 ~ c3$years, span=0.3))
  
  plot(c3$years,c3$c2, type="l", xlab="Year", ylab=paste("% of countries experiencing",name),
       col="red", lwd=1, main=paste("%",name,"and change-points, 1789-2016"))
  
  lines(c3$years,loess, col="grey", type="l", add=T,lwd=6)
  for(i in 1:4){
    abline(v=points[i], col="blue", lwd=2) 
    text(points[i]+8,.06, paste(points[i]), col = "black", cex=1.2) 
  }
  legend("bottomright", legend=c("Frequency", "Changepoint", "Loess smoothed average"), col=c("red", "blue", "grey"), lwd=2)
  dev.off()
  
  

  
  ####LIBERALIZATION
  
  data$regtrans <- data$reglib
  name <- "liberalization"
  
  c <- aggregate(data$regtrans, by=list(data$year), FUN=mean, na.rm=T)
  colnames(c) <- c("year", "regchange")
  c <- c[order(c$year),]
  c2 <- as.ts(c$regchange, start=1789)
  
  fit.1 <- MCMCregressChange(c2 ~ 1, m=4,
                             b0=mean(c2), B0=0.05, c0=0.001, d0=0.001,
                             burnin=1000, mcmc=30000, thin=10, verbose=0)
  
  pdf(paste(name,"changepoints.pdf"))
  plot1 <- plotState(fit.1, start=1789, main=paste("Posterior probability of different states (",name,")"))
  dev.off()
  
  pdf(paste(name,"changepoints2.pdf"))
  plotChangepoint(fit.1, start=1789, main=paste("Posterior probability of change-points (",name,")"))
  dev.off()
  
  points <- plotChangepoint(fit.1, start=1789)
  print(points)
  
  pdf(paste(name,"changepoints3.pdf"))
  par(mfrow=c(1,1))
  c3 <- data.frame(c2)
  years <- seq(from=1, to=227, by=1)
  years2 <- years+1789
  c3 <- cbind(c3, years2)
  plot(c3$years,c3$c2, type="l", xlab="Year", ylab=paste("% of countries experiencing",name),
       col="red", lwd=1, main=paste("%",name,"and change-points, 1789-2016"))
  for(i in 1:4){
    abline(v=points[i], col="blue", lwd=2) 
    text(points[i]+5,(max(c3$c2)-.01), paste(points[i]), col = "black") 
  }
  dev.off()
  
  
  
  ####INTERSTATE WARS
  
  data$regtrans <- data$warint
  name <- "war"
  
  c <- aggregate(data$regtrans, by=list(data$year), FUN=mean, na.rm=T)
  colnames(c) <- c("year", "regchange")
  c <- c[order(c$year),]
  c2 <- as.ts(c$regchange, start=1789)
  
  fit.1 <- MCMCregressChange(c2 ~ 1, m=4,
                             b0=mean(c2), B0=0.05, c0=0.001, d0=0.001,
                             burnin=1000, mcmc=30000, thin=10, verbose=0)
  
  pdf(paste(name,"changepoints.pdf"))
  plot1 <- plotState(fit.1, start=1789, main=paste("Posterior probability of different states (",name,")"))
  dev.off()
  
  pdf(paste(name,"changepoints2.pdf"))
  plotChangepoint(fit.1, start=1789, main=paste("Posterior probability of change-points (",name,")"))
  dev.off()
  
  points <- plotChangepoint(fit.1, start=1789)
  print(points)
  
  pdf(paste(name,"changepoints3.pdf"))
  par(mfrow=c(1,1))
  c3 <- data.frame(c2)
  years <- seq(from=1, to=227, by=1)
  years2 <- years+1789
  c3 <- cbind(c3, years2)
  plot(c3$years,c3$c2, type="l", xlab="Year", ylab=paste("% of countries experiencing",name),
       col="red", lwd=1, main=paste("%",name,"and change-points, 1789-2016"))
  for(i in 1:4){
    abline(v=points[i], col="blue", lwd=2) 
    text(points[i]+5,(max(c3$c2)-.01), paste(points[i]), col = "black") 
  }
  dev.off()
  

