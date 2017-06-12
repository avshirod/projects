# Load the libraries 
#install.packages("vars")
#install.packages("urca")
#install.packages("pcalg")
#library() vs require() - What to use?
library(vars)
library(urca)
library(tseries)
source("https://bioconductor.org/biocLite.R")
biocLite("RBGL")
biocLite("Rgraphviz")
library(pcalg)

# Read the input data
setwd("..")
setwd("Input Data")
price_data <- read.csv(file = "data.csv", head = TRUE, sep=",")
attach(price_data)

# Build a VAR model
# VARselect to select the appropriate Lag; SC is Schwartz Criterion
SCLag <- VARselect(price_data, lag.max = 10)
lag = SCLag$selection[3]
varmodel <- VAR(data, p=lag, type="both")

# Extract the residuals from the VAR model
res <- residuals(varmodel)
resMove <- res[,1]
resRPRICE <- res[,2]
resMPRICE <- res[,3]

# Check for stationarity using the Augmented Dickey-Fuller test
ur.df(resMove, lags = lag, selectlags = "BIC")
ur.df(resRPRICE, lags = lag, selectlags = "BIC")
ur.df(resMPRICE, lags = lag, selectlags = "BIC")
# Using adf.test() from tseries package shows that all three time series are stationary

# Check whether the variables follow a Gaussian distribution
ks.test(resMove, "rnorm")
ks.test(resRPRICE, "rnorm")
ks.test(resMPRICE, "rnorm")
# p-value < 0.05 in all cases. Hence, initial hypothesis rejected. Hence not Gaussian.

# Write the residuals to a csv file to build causal graphs using Tetrad software
# R Code as a substitute for Tetrad
# PC algorithm
suffStat=list(C=cor(price_data), n=1000)
pc_fit <- pc(suffStat, indepTest=gaussCItest, alpha=0.05, labels=colnames(data), skel.method="original")
plot(pc_fit, main="PC Output")

# LiNGAM algorithm
lingam_fit <- LINGAM(data)
show(lingam_fit)

# PC Algorithm gives a graph in which there are no directed edges.
# While LiNGAM gives a graph where RPRICE -> MPRICE
# This might be because PC assumes Linearity in the data, which is not present in our data as seen from KS test.
