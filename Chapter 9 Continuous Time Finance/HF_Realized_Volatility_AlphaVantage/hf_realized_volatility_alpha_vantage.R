# One simulated trading day; no observed stock prices are used here.
library(ggplot2)
set.seed(909)
n <- 390
minute <- 0:n
x <- c(0,cumsum(rnorm(n,sd=.02/sqrt(n))))
y <- x+rnorm(n+1,sd=.0006)
bad <- y
bad[181] <- bad[181]+.12  # one erroneous quote, reversed next minute
rv <- function(z,k) {
  idx <- unique(c(seq(1,length(z),by=k),length(z)))
  sum(diff(z[idx])^2)
}
series <- list(Latent=x,Noisy=y,Contaminated=bad)
tab <- do.call(rbind,lapply(names(series),function(nm)
  data.frame(Series=nm,Minutes=c(1,10),
    RV=vapply(c(1,10),function(k) rv(series[[nm]],k),numeric(1)))))
print(tab)
df <- data.frame(Minute=rep(1:n,2),
  Return=c(diff(y),diff(bad)),
  Series=rep(c('Noisy price','One erroneous quote'),each=n))
p1 <- ggplot(df,aes(Minute,Return,colour=Series,linetype=Series))+
  geom_line(linewidth=.55)+theme_minimal(base_size=11)+
  labs(title='Simulated intraday returns',y='Log return')+
  theme(legend.position='bottom',legend.title=element_blank())
ggsave('log_returns_1min.png',p1,width=6.5,height=3.8,dpi=300)
signature <- do.call(rbind,lapply(names(series),function(nm)
  data.frame(Series=nm,Minutes=1:20,
    RV=vapply(1:20,function(k) rv(series[[nm]],k),numeric(1)))))
p2 <- ggplot(signature,aes(Minutes,RV,colour=Series,linetype=Series))+
  geom_line(linewidth=.7)+geom_point(size=1)+scale_y_log10()+
  theme_minimal(base_size=11)+
  labs(title='Volatility signature plot',x='Sampling interval (minutes)',
    y='Realised variance (log scale)')+
  theme(legend.position='bottom',legend.title=element_blank())
ggsave('volatility_comparison.png',p2,width=6.5,height=3.8,dpi=300)
write.csv(data.frame(minute,x,y,bad),'simulated_intraday_prices.csv',row.names=FALSE)
