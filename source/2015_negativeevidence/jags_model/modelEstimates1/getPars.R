# get parameters
require(coda)
dir <- '~/Work/Research/NegEvidenceInduction/jags2/modelEstimates1/'
samp <- as.matrix(read.coda(paste0(dir,"CODAchain1.txt"),
                            paste0(dir,"CODAindex.txt")))

mean <- colMeans(samp)
ci <- apply(samp,2,quantile,prob=c(.025,.975))
# prob <- mean(read.csv(paste0(dir,"CODAchain1.txt"),sep=" ")[[3]])
# BF <- prob/(1-prob)
# print(BF)

