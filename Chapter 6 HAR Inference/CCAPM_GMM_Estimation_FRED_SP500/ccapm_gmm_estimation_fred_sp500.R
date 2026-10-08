library(quantmod)
z <- read.csv('ch06_ccapm_vintage.csv')
z <- z[order(z$month), ]
stopifnot(all(diff(as.integer(substr(z$month,1,4))*12L+
  as.integer(substr(z$month,6,7))) == 1L), !anyNA(z))
gc0 <- diff(log(z$C)); inflation <- diff(log(z$P))
Rm <- exp(diff(log(z$stock))-inflation)
Rf <- (1+head(z$bill,-1)/1200)*exp(-inflation)
# Instruments precede the payoff by two months.
Z <- cbind(1,as.numeric(scale(head(gc0,-2))),
  as.numeric(scale(head(Rm-Rf,-2))))
gc <- tail(gc0,-2)
R <- cbind(market=tail(Rm,-2),bill=tail(Rf,-2))
n <- length(gc); L <- floor(4*(n/100)^(2/9))
mom <- function(th) {
  err <- R * (th[1]*exp(-th[2]*gc)) - 1
  cbind(Z*err[,1], Z*err[,2])
}
hac <- function(v,L) {
  v <- scale(v,center=TRUE,scale=FALSE)
  n <- nrow(v); S <- crossprod(v)/n
  for(j in seq_len(L)) {
    G <- crossprod(v[(j+1):n,,drop=FALSE],v[1:(n-j),,drop=FALSE])/n
    S <- S+(1-j/(L+1))*(G+t(G))
  }
  (S+t(S))/2
}
# At fixed gamma the moments are linear in beta, so profile it analytically.
b <- c(colMeans(Z),colMeans(Z))
profile <- function(gamma,W,bounds=c(-Inf,Inf)) {
  a <- colMeans(mom(c(1,gamma)))+b
  beta <- drop(crossprod(a,W%*%b)/crossprod(a,W%*%a))
  beta <- max(bounds[1],min(bounds[2],beta))
  g <- beta*a-b
  c(beta=beta,gamma=gamma,criterion=drop(crossprod(g,W%*%g)))
}
fit_profile <- function(W,interval,bounds=c(-Inf,Inf)) {
  grid <- seq(interval[1],interval[2],length.out=2001)
  vals <- vapply(grid,function(g) profile(g,W,bounds)[3],numeric(1))
  i <- which.min(vals)
  opt <- optimize(function(g) profile(g,W,bounds)[3],
    c(grid[max(1,i-1)],grid[min(length(grid),i+1)]))
  candidates <- rbind(profile(opt$minimum,W,bounds),
    profile(interval[1],W,bounds),profile(interval[2],W,bounds))
  candidates[which.min(candidates[,3]),]
}
first <- fit_profile(diag(6),c(-100,100))
Omega1 <- hac(mom(first[1:2]),L)
stopifnot(min(eigen(Omega1,symmetric=TRUE)$values)>0)
W <- solve(Omega1)
free <- fit_profile(W,c(-100,100))
bounded <- fit_profile(W,c(.001,100),c(.8,1))
stopifnot(abs(free[2])<99,free[1]>0)
fits <- rbind(Unrestricted=free,Constrained=bounded)
print(data.frame(fits,J=n*fits[,3]))
print(c(n=n,start=tail(z$month,n)[1],end=tail(z$month,1),bandwidth=L))
D <- sapply(1:2,function(j) {
  e <- c(0,0); e[j] <- 1e-5
  (colMeans(mom(free[1:2]+e))-colMeans(mom(free[1:2]-e)))/(2e-5)
})
A <- solve(t(D)%*%W%*%D)
V <- A%*%t(D)%*%W%*%hac(mom(free[1:2]),L)%*%W%*%D%*%A/n
print(c(SE_beta=sqrt(V[1,1]),SE_gamma=sqrt(V[2,2]),
  nominal_J_p=pchisq(n*free[3],4,lower.tail=FALSE)))
# Whitening and parameter scales are explicit: 0.01 in beta and 1 in gamma.
print(svd(chol(W)%*%D%*%diag(c(.01,1)))$d)
gamma_grid <- c(-10,-1,-.5,0,.5,2,10,40,100)
prof <- t(vapply(gamma_grid,function(g) profile(g,W),numeric(3)))
print(data.frame(prof,J=n*prof[,3]))
write.csv(data.frame(fits,J=n*fits[,3]),'ccapm_estimates.csv')
write.csv(data.frame(prof,J=n*prof[,3]),'ccapm_profile.csv',row.names=FALSE)
saveRDS(list(fits=fits,V=V,W=W,n=n,profile=prof),'ccapm_results.rds')
# Separate the costs of the economic restrictions.
gamma_only <- fit_profile(W,c(.001,100))
beta_only <- fit_profile(W,c(-100,100),c(.8,1))
print(c(J_gamma_only=n*gamma_only[3],J_beta_only=n*beta_only[3]))
# Stock-Wright statistic with a covariance estimated at each trial value.
Sstat <- function(beta,gamma) {
  mm <- mom(c(beta,gamma)); gbar <- colMeans(mm)
  n*drop(crossprod(gbar,solve(hac(mm,L),gbar)))
}
S_profile <- function(gamma) {
  beta_grid <- seq(.5,1.5,length.out=2001)
  scores <- vapply(beta_grid,Sstat,numeric(1),gamma=gamma)
  i <- which.min(scores)
  oo <- optimize(function(beta)Sstat(beta,gamma),
    beta_grid[c(max(1L,i-1L),min(length(beta_grid),i+1L))],tol=1e-10)
  c(gamma=gamma,beta=oo$minimum,S=oo$objective)
}
s_values <- t(vapply(c(-.5,0,.5,1,2,5),S_profile,numeric(3)))
print(s_values,digits=8)
print(c(chi_square_6_95=qchisq(.95,6),mean_real_bill=mean(R[,2])))
write.csv(s_values,'ccapm_S_profile.csv',row.names=FALSE)
