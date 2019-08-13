# load the data
dir <- '~/Work/Research/NegEvidenceInduction/jags2/data/'
data <- read.csv(paste0(dir,"experiment1_rules.txt"),sep="\t")

subj <- data$pp # subject
resp <- as.character(data$rules) # hypothesis generated
item <- as.numeric(data$items) # item type
cond <- data$premset # condition

tab <- xtabs(~resp+cond)
tab <- tab[c("base","sub","cat","super"),]

baseK <- tab[,"baseline"]; names(baseK) <- NULL
closeK <- tab[,"close negative"]; names(closeK) <- NULL
distK <- tab[,"distant negative"]; names(distK) <-NULL

baseN <- sum(baseK)
closeN <- sum(closeK)
distN <- sum(distK)

# dump it
dump(list = c("baseN","closeN","distN","baseK","closeK","distK"),
     file = paste0(dir,"jagsData1.R"))