#9046 missing age.  n = 12127
sf <- readRDS("full-sf-data.rds")
#Fully observed
sw <- readRDS("full-sw-data.rds")

library(tidyverse)
sf %>% mutate(missing = is.na(age)) %>% group_by(missing) %>% summarise(mean(length))
sf %>% mutate(missing = is.na(age)) %>% ggplot(aes(x = missing, y = length)) + geom_boxplot()
ggplot(aes(x = age,y = length),data = sf) + geom_point() + geom_smooth()

library(mice)
set.seed(2014)
mids <- mice(sf, m  = 100, method = "pmm")
comp <- list()
for (i in 1:100){
comp[[i]]<-complete(mids,i)
comp[[i]]$m <- i
}

df <- do.call(rbind,comp)

ggplot()  + geom_density(aes(x = age, group = factor(m)),data = df,bw = .75, col = "gray") + geom_density(aes(x = age,),data = df,bw = .75, lwd = 1) + geom_density(aes(x = age),data = sf,bw = .75, col = "red", lwd = 1)

mean(df$age)
mean(sf$age, na.rm = TRUE)
