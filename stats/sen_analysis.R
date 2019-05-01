#THIS IS CODE FOR EEG/EYE
library(reshape)
library(stringr)
library(ez)
library(dplyr)
#library(ggplot2)
#library(plotly)

###################################################################
##
##  200-400
##
###################################################################
data = read.table("sen_amp200_400.txt",header = T)
data.Melt = melt(data,id=c("ERPset"))

#Extract electrode label
x = str_extract(data.Melt$variable,".{2,3}$")
data.Melt$Elec = substring(x,1,nchar(x))

#Extract condition
x = str_extract(data.Melt$ERPset,".{4}$")
data.Melt$condition = x

#Extract frequency
x = str_extract(data.Melt$condition,"^.{2}")
data.Melt$freq = x

#Extract lsa
x = str_extract(data.Melt$condition,".{2}$")
data.Melt$lsa = x

#Extract participant
x = str_extract(data.Melt$ERPset,"^.{6}")
data.Melt$subject = x

# data.Melt$condition = substr(str_extract(data.Melt$variable,"...$"),1,1)
# data.Melt$condition = as.factor(data.Melt$condition)

data.Melt.Clean = data.Melt

source('NemoROI.R')
x = sapply(data.Melt.Clean$Elec, nemoROI)


#add regions to list
data.Melt.Clean$region = x

#Remove undefined regions 
data.Melt.Clean = subset(data.Melt.Clean,region!='UNDEF')

#Remove redundant factor "variable"
#data.Melt$variable = NULL

#Remove unnecessary columns
data.Melt.Clean$variable = NULL
data.Melt.Clean$Elec = NULL
data.Melt.Clean$ERPset = NULL

#Make sure all are factors
data.Melt.Clean$condition = as.factor(data.Melt.Clean$condition)
data.Melt.Clean$region = as.factor(data.Melt.Clean$region)

#Average all electrodes for each region
data.Melt.Clean = aggregate(value~subject+freq+lsa+region,data.Melt.Clean, mean)


qplot(x = condition, value, data = subset(data.Melt.Clean.V),geom=c("boxplot", "jitter"), label = File)
ggplotly()

#####
# AMPLITUDE
#####

model.amplitude = ezANOVA(data.Melt.Clean %>% filter(region == 'M_C' | region == 'M_P' | region == 'M_F'),dv=.(value),wid=.(subject),within=.(lsa, freq, region),type=3)
describeBy(data.Melt.Clean$value, data.Melt.Clean$condition)
model.amplitude



##########################################################
# LOAD LATENCY 

data = read.table("sen_lat200_400.txt",header = T)
data.Melt = melt(data,id=c("ERPset"))

#Extract electrode label
x = str_extract(data.Melt$variable,".{2,3}$")
data.Melt$Elec = substring(x,1,nchar(x))

#Extract condition
x = str_extract(data.Melt$ERPset,".{4}$")
data.Melt$condition = x

#Extract frequency
x = str_extract(data.Melt$condition,"^.{2}")
data.Melt$freq = x

#Extract lsa
x = str_extract(data.Melt$condition,".{2}$")
data.Melt$lsa = x

#Extract participant
x = str_extract(data.Melt$ERPset,"^.{6}")
data.Melt$subject = x

# data.Melt$condition = substr(str_extract(data.Melt$variable,"...$"),1,1)
# data.Melt$condition = as.factor(data.Melt$condition)

data.Melt.Clean = data.Melt

source('NemoROI.R')
x = sapply(data.Melt.Clean$Elec, nemoROI)


#add regions to list
data.Melt.Clean$region = x

#Remove undefined regions 
data.Melt.Clean = subset(data.Melt.Clean,region!='UNDEF')

#Remove redundant factor "variable"
#data.Melt$variable = NULL

#Remove unnecessary columns
data.Melt.Clean$variable = NULL
data.Melt.Clean$Elec = NULL
data.Melt.Clean$ERPset = NULL

#Make sure all are factors
data.Melt.Clean$condition = as.factor(data.Melt.Clean$condition)
data.Melt.Clean$region = as.factor(data.Melt.Clean$region)

#Average all electrodes for each region
data.Melt.Clean = aggregate(value~subject+freq+lsa+region,data.Melt.Clean, mean)

#####
# LATENCY
#####

model.amplitude = ezANOVA(data.Melt.Clean %>% filter(region == 'M_C' | region == 'M_P' | region == 'M_F'),dv=.(value),wid=.(subject),within=.(lsa, freq, region),type=3)
describeBy(data.Melt.Clean$value, data.Melt.Clean$condition)
model.amplitude



###################################################################
##
##  400-700
##
###################################################################
data = read.table("sen_amp400_700.txt",header = T)
data.Melt = melt(data,id=c("ERPset"))

#Extract electrode label
x = str_extract(data.Melt$variable,".{2,3}$")
data.Melt$Elec = substring(x,1,nchar(x))

#Extract condition
x = str_extract(data.Melt$ERPset,".{4}$")
data.Melt$condition = x

#Extract frequency
x = str_extract(data.Melt$condition,"^.{2}")
data.Melt$freq = x

#Extract lsa
x = str_extract(data.Melt$condition,".{2}$")
data.Melt$lsa = x

#Extract participant
x = str_extract(data.Melt$ERPset,"^.{6}")
data.Melt$subject = x

# data.Melt$condition = substr(str_extract(data.Melt$variable,"...$"),1,1)
# data.Melt$condition = as.factor(data.Melt$condition)

data.Melt.Clean = data.Melt

source('NemoROI.R')
x = sapply(data.Melt.Clean$Elec, nemoROI)


#add regions to list
data.Melt.Clean$region = x

#Remove undefined regions 
data.Melt.Clean = subset(data.Melt.Clean,region!='UNDEF')

#Remove redundant factor "variable"
#data.Melt$variable = NULL

#Remove unnecessary columns
data.Melt.Clean$variable = NULL
data.Melt.Clean$Elec = NULL
data.Melt.Clean$ERPset = NULL

#Make sure all are factors
data.Melt.Clean$condition = as.factor(data.Melt.Clean$condition)
data.Melt.Clean$region = as.factor(data.Melt.Clean$region)

#Average all electrodes for each region
data.Melt.Clean = aggregate(value~subject+freq+lsa+region,data.Melt.Clean, mean)


#qplot(x = condition, value, data = subset(data.Melt.Clean.V),geom=c("boxplot", "jitter"), label = File)
#ggplotly()

#####
# AMPLITUDE
#####

model.amplitude = ezANOVA(data.Melt.Clean %>% filter(region == 'M_C' | region == 'M_P' | region == 'M_F'),dv=.(value),wid=.(subject),within=.(lsa, freq, region),type=3)
describeBy(data.Melt.Clean$value, data.Melt.Clean$condition)
model.amplitude



##########################################################
# LOAD LATENCY 

data = read.table("sen_lat400_700.txt",header = T)
data.Melt = melt(data,id=c("ERPset"))

#Extract electrode label
x = str_extract(data.Melt$variable,".{2,3}$")
data.Melt$Elec = substring(x,1,nchar(x))

#Extract condition
x = str_extract(data.Melt$ERPset,".{4}$")
data.Melt$condition = x

#Extract frequency
x = str_extract(data.Melt$condition,"^.{2}")
data.Melt$freq = x

#Extract lsa
x = str_extract(data.Melt$condition,".{2}$")
data.Melt$lsa = x

#Extract participant
x = str_extract(data.Melt$ERPset,"^.{6}")
data.Melt$subject = x

# data.Melt$condition = substr(str_extract(data.Melt$variable,"...$"),1,1)
# data.Melt$condition = as.factor(data.Melt$condition)

data.Melt.Clean = data.Melt

source('NemoROI.R')
x = sapply(data.Melt.Clean$Elec, nemoROI)


#add regions to list
data.Melt.Clean$region = x

#Remove undefined regions 
data.Melt.Clean = subset(data.Melt.Clean,region!='UNDEF')

#Remove redundant factor "variable"
#data.Melt$variable = NULL

#Remove unnecessary columns
data.Melt.Clean$variable = NULL
data.Melt.Clean$Elec = NULL
data.Melt.Clean$ERPset = NULL

#Make sure all are factors
data.Melt.Clean$condition = as.factor(data.Melt.Clean$condition)
data.Melt.Clean$region = as.factor(data.Melt.Clean$region)

#Average all electrodes for each region
data.Melt.Clean = aggregate(value~subject+freq+lsa+region,data.Melt.Clean, mean)

#####
# LATENCY
#####

model.latency = ezANOVA(data.Melt.Clean %>% filter(region == 'M_C' | region == 'M_P' | region == 'M_F'),dv=.(value),wid=.(subject),within=.(lsa, freq, region),type=3)
describeBy(data.Melt.Clean$value, data.Melt.Clean$condition)
model.latency
