install.packages(c("depmixS4", "ggplot2"))
library(depmixS4)
library(ggplot2)

curr_dir = getwd()
filename = "data_avshirod.csv"
file_dir = "C:/Users/Antha/Google Drive/Fall 2016/CSC 591 IoT Analytics/Project/5"
# file_path = file.path(curr_dir, filename)
file_path = file.path(file_dir, filename)
data = read.csv(file_path)
# head(data)

df <- data.frame(data)
train <- data.frame(data[seq(1600),])
test <- df[-seq(1600),]

mod <- depmix(,family = gaussian(), nstates = 3, data = train)
