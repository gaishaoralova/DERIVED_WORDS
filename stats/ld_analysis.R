#THIS IS CODE FOR EEG/EYE
library(reshape)
library(stringr)
library(ez)
library(dplyr)
#library(ggplot2)
#library(plotly)

###################################################################
##
##  150-300 positive
##
###################################################################
data = read.table("ld_amp150_300.txt",header = T)
data.Melt = melt(data,id=c("ERPset"))

#Extract electrode label
x = str_extract(data.Melt$variable,".{2,3}$")
data.Melt$Elec = substring(x,1,nchar(x))

#Extract condition
x = str_extract(data.Melt$ERPset,".{7}$")
data.Melt$condition = x

#Delete ld at the end of condition
x = str_remove(data.Melt$condition,".{3}$")
data.Melt$condition = x

#Extract frequency
x = str_extract(data.Melt$condition,"^.{2}")
data.Melt$freq = x

#Extract lsa
x = str_extract(data.Melt$condition,".{2}$")
data.Melt$lsa = x

#Extract participant
x = str_extract(data.Melt$ERPset,"^.{5}")
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
"""$ANOVA
Effect DFn DFd         F          p p<.05          ges
2             lsa   1   8 0.7224030 0.42006437       0.0053350834
3            freq   1   8 2.8195750 0.13163571       0.0121066650
4          region   2  16 4.2232306 0.03366913     * 0.0531306899
5        lsa:freq   1   8 7.6506509 0.02444792     * 0.0174531879
6      lsa:region   2  16 0.3966684 0.67899079       0.0006005343
7     freq:region   2  16 0.1205554 0.88722549       0.0001979198
8 lsa:freq:region   2  16 0.2123049 0.81095988       0.0002843785

$`Mauchly's Test for Sphericity`
Effect         W          p p<.05
4          region 0.2868742 0.01264505     *
  6      lsa:region 0.4136999 0.04554061     *
  7     freq:region 0.6159949 0.18345096      
8 lsa:freq:region 0.4503372 0.06128896      

$`Sphericity Corrections`
Effect       GGe      p[GG] p[GG]<.05       HFe      p[HF] p[HF]<.05
4          region 0.5837283 0.06477927           0.6225434 0.06092356          
6      lsa:region 0.6303977 0.59017831           0.6934913 0.60842015          
7     freq:region 0.7225407 0.82273980           0.8395019 0.85408195          
8 lsa:freq:region 0.6453017 0.71564955           0.7165644 0.73922914        
"""


##########################################################
# LOAD LATENCY 

data = read.table("ld_lat150_300.txt",header = T)
data.Melt = melt(data,id=c("ERPset"))

#Extract electrode label
x = str_extract(data.Melt$variable,".{2,3}$")
data.Melt$Elec = substring(x,1,nchar(x))

#Extract condition
x = str_extract(data.Melt$ERPset,".{7}$")
data.Melt$condition = x

#Delete ld at the end of condition
x = str_remove(data.Melt$condition,".{3}$")
data.Melt$condition = x

#Extract frequency
x = str_extract(data.Melt$condition,"^.{2}")
data.Melt$freq = x

#Extract lsa
x = str_extract(data.Melt$condition,".{2}$")
data.Melt$lsa = x

#Extract participant
x = str_extract(data.Melt$ERPset,"^.{5}")
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
"""
$ANOVA
           Effect DFn DFd         F          p p<.05          ges
2             lsa   1   8 4.5491819 0.06549849       0.0192250515
3            freq   1   8 1.0017133 0.34620387       0.0039191135
4          region   2  16 1.7551595 0.20457140       0.0686663410
5        lsa:freq   1   8 0.2095976 0.65926117       0.0006586478
6      lsa:region   2  16 0.8326524 0.45288797       0.0035771497
7     freq:region   2  16 0.4132750 0.66834275       0.0023785512
8 lsa:freq:region   2  16 0.2780962 0.76080990       0.0012156712

$`Mauchly's Test for Sphericity`
           Effect         W          p p<.05
4          region 0.5944206 0.16193042      
6      lsa:region 0.3714571 0.03123778     *
7     freq:region 0.7830215 0.42482289      
8 lsa:freq:region 0.9738906 0.91156072      

$`Sphericity Corrections`
           Effect       GGe     p[GG] p[GG]<.05       HFe     p[HF] p[HF]<.05
4          region 0.7114504 0.2162862           0.8214949 0.2121064          
6      lsa:region 0.6140458 0.4077981           0.6684102 0.4157926          
7     freq:region 0.8217072 0.6310701           1.0061006 0.6683427          
8 lsa:freq:region 0.9745550 0.7554558           1.2842730 0.7608099
"""


###################################################################
##
##  300-500 negative
##
###################################################################
data = read.table("ld_amp300_500.txt",header = T)
data.Melt = melt(data,id=c("ERPset"))

#Extract electrode label
x = str_extract(data.Melt$variable,".{2,3}$")
data.Melt$Elec = substring(x,1,nchar(x))

#Extract condition
x = str_extract(data.Melt$ERPset,".{7}$")
data.Melt$condition = x

#Delete ld at the end of condition
x = str_remove(data.Melt$condition,".{3}$")
data.Melt$condition = x

#Extract frequency
x = str_extract(data.Melt$condition,"^.{2}")
data.Melt$freq = x

#Extract lsa
x = str_extract(data.Melt$condition,".{2}$")
data.Melt$lsa = x

#Extract participant
x = str_extract(data.Melt$ERPset,"^.{5}")
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
"""
$ANOVA
           Effect DFn DFd         F         p p<.05          ges
2             lsa   1   8 0.8130479 0.3935572       0.0039201376
3            freq   1   8 1.6509582 0.2347798       0.0154915273
4          region   2  16 0.7298312 0.4973626       0.0141813702
5        lsa:freq   1   8 0.6767620 0.4345377       0.0014709783
6      lsa:region   2  16 1.9657791 0.1724368       0.0021614786
7     freq:region   2  16 0.3205141 0.7303291       0.0003006396
8 lsa:freq:region   2  16 0.2543297 0.7785122       0.0004708276

$`Mauchly's Test for Sphericity`
Effect         W           p p<.05
4          region 0.3251761 0.019607187     *
6      lsa:region 0.2374322 0.006522116     *
7     freq:region 0.4765745 0.074723585      
8 lsa:freq:region 0.2369741 0.006478182     *

$`Sphericity Corrections`
Effect       GGe     p[GG] p[GG]<.05       HFe     p[HF] p[HF]<.05
4          region 0.5970777 0.4381595           0.6426387 0.4466023          
6      lsa:region 0.5673541 0.1956611           0.5981081 0.1942267          
7     freq:region 0.6564154 0.6431883           0.7339038 0.6664099          
8 lsa:freq:region 0.5672066 0.6555605           0.5978892 0.6672259
"""


##########################################################
# LOAD LATENCY 

data = read.table("ld_lat300_500.txt",header = T)
data.Melt = melt(data,id=c("ERPset"))

#Extract electrode label
x = str_extract(data.Melt$variable,".{2,3}$")
data.Melt$Elec = substring(x,1,nchar(x))

#Extract condition
x = str_extract(data.Melt$ERPset,".{7}$")
data.Melt$condition = x

#Delete ld at the end of condition
x = str_remove(data.Melt$condition,".{3}$")
data.Melt$condition = x

#Extract frequency
x = str_extract(data.Melt$condition,"^.{2}")
data.Melt$freq = x

#Extract lsa
x = str_extract(data.Melt$condition,".{2}$")
data.Melt$lsa = x

#Extract participant
x = str_extract(data.Melt$ERPset,"^.{5}")
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
"""
$ANOVA
           Effect DFn DFd         F          p p<.05         ges
2             lsa   1   8 1.3160891 0.28444434       0.018853304
3            freq   1   8 1.3290635 0.28225281       0.024037250
4          region   2  16 0.7171753 0.50316876       0.008951808
5        lsa:freq   1   8 0.4665114 0.51388622       0.002041301
6      lsa:region   2  16 0.0620914 0.94002230       0.000722375
7     freq:region   2  16 3.5069667 0.05457994       0.021483240
8 lsa:freq:region   2  16 1.6828841 0.21711110       0.016284447

$`Mauchly's Test for Sphericity`
           Effect          W            p p<.05
4          region 0.98183795 0.9378629041      
6      lsa:region 0.08195213 0.0001575654     *
7     freq:region 0.43790208 0.0555673282      
8 lsa:freq:region 0.42971357 0.0520147762      

$`Sphericity Corrections`
           Effect       GGe      p[GG] p[GG]<.05       HFe      p[HF] p[HF]<.05
4          region 0.9821619 0.50104376           1.2988532 0.50316876          
6      lsa:region 0.5213634 0.81929872           0.5307066 0.82340041          
7     freq:region 0.6401647 0.08325288           0.7085887 0.07682459          
8 lsa:freq:region 0.6368265 0.22886055           0.7034187 0.22721521          
"""