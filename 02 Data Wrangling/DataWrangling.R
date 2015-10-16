require("jsonlite")
require(dplyr)
require("RCurl")
require(tidyr)
require(ggplot2)
require(dplyr)
#Data From 2008
df2008 <- data.frame(fromJSON(getURL(URLencode('129.152.144.84:5001/rest/native/?query="select * from ELECTIONOF2008 where CANDIDATE is not null"'),httpheader=c(DB='jdbc:oracle:thin:@129.152.144.84:1521/PDBF15DV.usuniversi01134.oraclecloud.internal', USER='cs329e_pmv347', PASS='orcl_pmv347', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE), ))
head(df2008)
df2008$NUMVOTES<-as.numeric(gsub(",","",as.character(df2008$VOTES)))
head(df2008)









#Data From 2012
df2012 <- data.frame(fromJSON(getURL(URLencode('129.152.144.84:5001/rest/native/?query="select * from ELECTIONOF2012 where STATE is not null"'),httpheader=c(DB='jdbc:oracle:thin:@129.152.144.84:1521/PDBF15DV.usuniversi01134.oraclecloud.internal', USER='cs329e_pmv347', PASS='orcl_pmv347', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE), ))
head(df2012)
df2012$VOTESD<-as.numeric(gsub(",","",as.character(df2012$DEMOCRATVOTES)))
df2012$TOTPOP<-as.numeric(gsub(",","",as.character(df2012$TOTALPOPULATION)))
df2012$VOTESI<-as.numeric(gsub(",","",as.character(df2012$OTHERVOTES)))
df2012$VOTESD<-as.numeric(gsub(",","",as.character(df2012$DEMOCRATVOTES)))
df2012$VOTESR<-as.numeric(gsub(",","",as.character(df2012$REPUBLICANVOTES)))
df2012<-dplyr::mutate(df2012,PercentVoters=as.numeric((VOTESI+VOTESR+VOTESD)*100/TOTPOP))

head(df2012)










#want to make a new data frame, adding these collumns from df2008 and df2012, note New York and DC are weird in our data, so I took the liberty of
#Removing them
finalDF<-data.frame(dplyr::filter(df2008,CANDIDATE=="Obama",STATE!="New York",STATE!="District of Columbia"))
finalDF$NumVotesR<-dplyr::filter(df2008,CANDIDATE=="McCain",STATE!="New York",STATE!="District of Columbia")$NUMVOTES
finalDF$TOTPOP<-as.numeric(filter(df2012,STATE!="New York")$TOTPOP)
#Add a collum for percent of voters in 2008, note that this number will be a little low, because we are using 2012 population. Shouldn't
#Lead to more than a 2 or 3 % difference though.
finalDF<-dplyr::mutate(finalDF,PercentVoters2008=as.numeric((NumVotesR+NUMVOTES)*100/TOTPOP))
#Now join our new data frame with the df2012 data frame, and we have our visualizer
dfVisualizer<-dplyr::inner_join(finalDF,df2012, by="STATE")
dfVisualizer<-dplyr::mutate(dfVisualizer,PercentVoters2008=as.numeric((NumVotesR+NUMVOTES)*100/TOTPOP.y))


