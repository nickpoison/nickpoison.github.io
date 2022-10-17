library(astsa)
library(ggplot2)


png(file='ggexp.png', width=600, height=400 )

library(reshape)            # install 'reshape' if you don't have it
df   = melt(eqexp[,9:16])   # reshape the data frame
Time = rep(1:2048, 8)
ggplot(data=df, aes(x=Time, y=value, col=variable))   +
     geom_line( )                                    +
     theme(legend.position="none")              +
      facet_wrap(~variable, ncol=2, scales='free_y')  +
      ylab('')	
	  
dev.off()	 

png(file='tsexp.png', width=600, height=400 )

tsplot(eqexp[,9:16], col= 1:8, ncol=2, gg=TRUE)

dev.off()	 

png(file='gglap.png', width=600, height=400 )

mortality = c(cmort)
temperature  = c(tempr)
pollution  = c(part)
df = melt(data.frame(mortality, temperature, pollution))
Time = c(time(cmort), time(tempr), time(part))
ggplot(data=df, aes(x=Time, y=value, col=variable)) +
    geom_line( )                                    +
    ylab("LA Pollution Study")

dev.off()


Cairo::CairoPNG(file='tslap.png', width=600, height=400 ) 

culer = astsa.col(c(6,3,4), .7)
tsplot(cbind(cmort, tempr,part),  ylab='LA Pollution Study', col=culer, spag=TRUE)
legend('topright', legend=c('Mortality', 'Temperature', 'Pollution'), lty=1, lwd=2, col=culer, bg='white')

dev.off()

Cairo::CairoPNG(file='tsblood.png', width=600, height=600 )

tsplot(blood, type='o', col=c(4,6,2), pch=19, cex=1, gg=TRUE) 

dev.off()