# get bayes factor

dir <- '~/Work/Research/NegEvidenceInduction/jags2/bayesFactor1/'
prob <- mean(read.csv(paste0(dir,"CODAchain1.txt"),sep=" ")[[3]])
BF <- prob/(1-prob)
print(BF)

