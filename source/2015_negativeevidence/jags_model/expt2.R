

source('~/Work/Research/NegEvidenceInduction/jags2/data/jagsData2.R')
source('~/Work/Research/NegEvidenceInduction/jags2/BayesianProportionTest.R')

counts <- c(baseK[3], distK[3]) # number of category level responses
sizes <- c(sum(baseK[1:3]),sum(distK[1:3])) # number of non-superordinate responses

bf <- BayesianPropTest(counts,sizes)
bf <- 1/bf # frame in terms of odds for alternative