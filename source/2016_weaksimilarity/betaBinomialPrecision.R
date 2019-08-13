betaBinomialPrecision <- function(N,K) {
  
  nSubj <- length(N)
  require(rjags)
  
  jagsData <- list(
    N = N,
    K = K,
    nSubj = nSubj
  )
  
  jagsModelString <- 
    "model {
      a_tmp ~ dexp(1)
      b_tmp ~ dexp(1)
      a <- a_tmp + 1
      b <- b_tmp + 1
      for( s in 1:nSubj) {
        P[s] ~ dbeta(a,b)
        K[s] ~ dbin(P[s],N[s])
      }
      sig <- sd(P)
    }"
  
  burnin <- 1000
  nsamp <- 1000
  thin <- 10
  
  jagsModel <- jags.model(
    file = textConnection(jagsModelString), 
    data = jagsData, 
    n.adapt = burnin,
    quiet=TRUE 
  )
  
  samples <- jags.samples(
    model = jagsModel, 
    variable.names = "sig", 
    n.iter = nsamp*thin,
    thin = thin,
    progress.bar="none"
  )
  
  sig <- as.matrix( samples[[1]] )
  sig <- as.vector(sig)
  return(sig)
  
}

# example 1: low precision
K <- c(0,10,2,8,5) # element s = number of times person s chose pair ij
N <- c(10,10,10,10,10) # element s = number of times pair ij was presented to person s
sigma_posterior <- betaBinomialPrecision(N,K)
sigma_hat <- mean(sigma_posterior)
hist(sigma_posterior)


# example 2: high precision
K <- c(5,5,5,5,5) # element s = number of times person s chose pair ij
N <- c(10,10,10,10,10) # element s = number of times pair ij was presented to person s
sigma_posterior <- betaBinomialPrecision(N,K)
sigma_hat <- mean(sigma_posterior)
hist(sigma_posterior)


