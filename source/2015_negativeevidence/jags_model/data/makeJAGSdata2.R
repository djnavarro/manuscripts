# load the data
dir <- '~/Work/Research/NegEvidenceInduction/jags2/data/'
data <- read.csv(paste0(dir,"experiment2_rules.txt"),sep="\t")


subj <- data$pp # subject
resp <- as.character(data$rules) # hypothesis generated
item <- as.numeric(data$items) # item type
cond <- data$premset # condition

tab <- xtabs(~resp+cond)
tab <- tab[c("base","sub","cat","super"),]

baseK <- tab[,"posA"]; names(baseK) <- NULL
distK <- tab[,"posAnegC"]; names(distK) <-NULL

baseN <- sum(baseK)
distN <- sum(distK)

# dump it
dump(list = c("baseN","distN","baseK","distK"),
     file = paste0(dir,"jagsData2.R"))
