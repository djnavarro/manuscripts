model in jagsModel1b.bug
data in jagsData1.R
compile, nchains(1)
initialize
update 10000
monitor set shiftmassC, thin(100)
monitor set shiftmassD, thin(100)
update 1000000 
coda *
