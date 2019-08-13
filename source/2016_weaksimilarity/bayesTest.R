# Various useful functions:
#
# makeHypothesisSpace - list all trinomial distributions (grid with some granularity)
# simModes - simulate the distribution of modal frequencies (for cross checking)
# modeProb - analytically compute the probability that the modal frequency from 
#    N draws from a trinomial distribution with probabilities (P1,P2,P3) will be K
# expectedMode - compute the expected value of the modal frequency K given N draws
#    from a trinomial with probabilities (P1,P2,P3)
#
# Hypothesis tests:
#
# BayesianModeTest - compute the Bayes factor comparing two hypotheses for the 
#    modal frequency K given N draws from a trinomial. The null hypothesis is 
#    that the true probability distribution is uniform, and the alternative 
#    hypothesis is that it is not (i.e., places a uniform prior across all
#    possible trinomial distributions). Note that although the null hypothesis is
#    that all outcomes have probability 1/3, the expected value of the *modal*
#    frequency under the null is still larger than 1/3. (It's easy to compute this 
#    with the help of the expectedMode function)
#
#  BayesianGOFTest - compute the Bayes factor comparing the same two hypotheses
#     (i.e., uniform probabilities vs non-uniform) as above, but using the full
#     set of observed frequencies, not merely the modal value. 




# enumerate all possible probability distributions over 
# three response options, up to some level of granularity.
# this isn't particularly elegant, but it works!
makeHypothesisSpace <- function(scf=.01) {
  
  vals <- seq(from = scf,to = 1-scf,by = scf) # don't include zero probability cases
  nv <- length(vals)
  alternatives <- matrix(NA,nv^2,3)
  ind <- 0
  for( i in vals) {
    for( j in vals ) {
      if((i+j)<=(1-scf)) { # don't include zero probability cases
        ind <- ind + 1
        k <- max(1-i-j,0) # prevent stupid rounding errors
        alternatives[ind,] <- c(i,j,k)
      }
    }
  }
  alternatives <- alternatives[1:ind,]
  return(alternatives)
}

# create the hypothesis space to be used elsewhere
hypotheses <- makeHypothesisSpace()

# for a probability distribution over 3 options, simulate
# samples of size n to find the distribution over sample
# modes. this can be used to check that the other functions 
# do what they say they do!
simModes <- function(n,pA,pB,pC,nsamp=10000) {
  
  x <- rmultinom(nsamp,size=n,prob = c(pA,pB,pC))
  modes <- apply(x,2,max)
  count <- tabulate(modes,nbins = n)
  p <- count/sum(count)
  return(p)
} 

# Analytically compute the probability that a trinomial sample 
# of size n will have modal frequency k, if the true probability
# distribution is probs. What this function does is sum the
# probabilities of all possible frequency tables in which N objects
# are assigned to 3 categories in which the largest frequency turns
# out to be K. 
modeProb <- function( k, n, probs ) {
  
  # for my sanity, let's label the outcomes A, B and C, and 
  # give each one its own variable:
  pA <- probs[1] 
  pB <- probs[2]
  pC <- probs[3]
  
  # the modal frequency k must be at least n/3: if not the probability is 0. 
  minmode <- ceiling(n/3)
  if(k<minmode) return(0) 
  
  # helper function computing the probability of a unique mode at A with
  # frequency v (out of n trials), if the true probabilities are given by
  # pA, pB and pC
  uniqueMode <- function(v,n,pA,pB,pC) {
    mm <- floor((n+1)/3)+1 # check that it's possible to have a *unique* mode at v
    if(v < mm) return(0)
    
    p1 <- dbinom(v,n,pA) # marginal probability that A has frequency n(A) = V
    if( (n-v) >= v) { # if v is not an outright majority, we can only consider cases where v is still modal 
      bvals <- (n-2*v+1):(v-1) # what possible values of n(B) are allowed while still having v be the modal freq
      p1 <- p1*sum(dbinom(bvals,n-v,pB/(pB+pC))) # sum over the allowed ways of allocating n-v observations to to B and C
    }
    return(p1)
  }
  
  # as above, but for a two-way tie between options A and B
  sharedMode <- function(v,n,pA,pB,pC) {
    if((2*v)>n) return(0) # if v is too big to allow a two way tie, prob = 0
    if((n-2*v)>=v) return(0) # also, v needs to be big enough so that C isn't the mode
    p <- dmultinom(c(v,v,n-2*v),n,c(pA,pB,pC)) # otherwise, return the multinomial prob for (v,v,n-v)
    return(p)
  }
  
  # finally, compute the probability of a three way tie at modal frequency v
  threeWayMode <- function(v,n,pA,pB,pC) {
    
    if(3*v != n) return(0) # only possible if v = n/3 obviously
    return( dmultinom(c(v,v,v),n,c(pA,pB,pC))) # return the multinomial probability for (v,v,v)
    
  }
  
  # probability that there is a unique mode with frequency k
  p1 <- uniqueMode(k,n,pA,pB,pC) # ... mode is option A
  p2 <- uniqueMode(k,n,pB,pA,pC) # ... mode is option B
  p3 <- uniqueMode(k,n,pC,pA,pB) # ... mode is option C
  
  # shared mode with frequency k
  p4 <- sharedMode(k,n,pA,pB,pC) # ... mode is a tie between A and B
  p5 <- sharedMode(k,n,pA,pC,pB) # ... mode is a tie between A and C
  p6 <- sharedMode(k,n,pC,pB,pA) # ... mode is a tie between B and C
  
  # three way mode
  p7 <- threeWayMode(k,n,pC,pB,pA) # only one way to do a three way tie
  
  p <- p1+p2+p3+p4+p5+p6+p7 # prob of a mode at k is the sum of all 7 cases
  return(p) 
  
}


# compute the expected value of the modal frequency k among three possible
# outcomes when n events are generated from trinomial distribution with 
# probabilities probs
expectedMode <- function( n, probs=c(1,1,1)/3 ) {
  k <- 0:n 
  p <- vector()
  for( i in 1:length(k)) { 
    p[i] <- modeProb(k[i], n, probs) 
  }
  return( sum(k*p) )
}


# the Bayesian equivalent of the chi-square goodness of fit test
BayesianGOFTest <- function( x ) {
  
  # probability of the observed frequencies under the hypothesis
  # that the outcome probabilities are uniform
  nullprob <- dmultinom(x,size=sum(x),prob=rep.int(1/length(x),length(x)))
  
  # the alternative hypothesis is a (uniform) prior-weighted average of 
  # all possbile trinomial distributions
  altprob <- 0
  for( i in 1:dim(hypotheses)[1] ) {
    altprob <- altprob + dmultinom(x,size=sum(x),prob=hypotheses[i,])
  }
  altprob <- altprob / dim(hypotheses)[1]
  
  # bayes factor is the ratio of the two
  bf <- altprob / nullprob
  return(bf)
  
}

# the Bayesian equivalent of the test of suspiciously large modes
BayesianModeTest <- function( k, n ) {
  
  # the null hypothesis states that the outcomes are generated with 
  # uniform probabilities. calculate the probability under the null
  # that we would observe a modal frequency of k from n observations 
  nullprob <- modeProb(k,n,rep.int(1/3,3)) 
  
  # for the alternative hypothesis, we need to aggregate across all possible
  # trinomial distributions. this code assumes a uniform prior across all 
  # possible trinomials, so the "weighting by prior" just divides by the 
  # number of hypotheses. 
  altprob <- 0
  for( i in 1:dim(hypotheses)[1] ) {
    altprob <- altprob + modeProb(k,n,prob=hypotheses[i,])
  }
  altprob <- altprob / dim(hypotheses)[1] 
  
  # bayes factor is the ratio of these likelihoods
  bf <- altprob / nullprob
  return(bf)
  
}