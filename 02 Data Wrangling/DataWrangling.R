require("jsonlite")
require(dplyr)
require("RCurl")
require(tidyr)
require(ggplot2)
require(dplyr)
#Data From 2008
df2008 <- data.frame(fromJSON(getURL(URLencode('129.152.144.84:5001/rest/native/?query="select * from ELECTIONOF2008 where CANDIDATE is not null"'),httpheader=c(DB='jdbc:oracle:thin:@129.152.144.84:1521/PDBF15DV.usuniversi01134.oraclecloud.internal', USER='cs329e_pmv347', PASS='orcl_pmv347', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE), ))
head(df2008)



#Data From 2012
df2012 <- data.frame(fromJSON(getURL(URLencode('129.152.144.84:5001/rest/native/?query="select * from ELECTIONOF2012 where STATE is not null"'),httpheader=c(DB='jdbc:oracle:thin:@129.152.144.84:1521/PDBF15DV.usuniversi01134.oraclecloud.internal', USER='cs329e_pmv347', PASS='orcl_pmv347', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE), ))
head(df2012)


#want to make a new data frame, adding these collumns to df2012
dplyr::filter(df2008,CANDIDATE=="Obama")
dplyr::filter(df2008,CANDIDATE=="McCain")
#Wanted to find the turnout for 2012, was unable. I believe the votes are cast as a string, and I don't know how to recast them
dplyr::mutate(df2012,PercentVoters=TOTALVOTES/TOTALPOPULATION)
#2008 Turnout, again, wasn't able to because I believe the votes are in string form.
dplyr::mutate(df2008,PercentVoters08=(ObamaVotes+MccainVotes/TotalPopulation))

#Had trouble making the graph do what I wanted. When I told it to take democrat votes as an integer, the max value was around 50, which doesn't
#Make any sense to me. If the string can be recast as an int, I think i could figure this out. I'll look it up, email the professor, etc, the afternoon
#But if either of you know how to do it, the rest of this should be pretty easy.
#Also, The Democrats have a red dot on the graphs and the republicans have a blue, I don't know how to fix it, but it actually bugs me.
require(extrafont)
ggplot(df2012, 
       aes(STATE, y = value, color = variable)) + 
  geom_point(aes(y = as.integer(DEMOCRATVOTES), col = "Democrat Votes")) + 
  geom_point(aes(y = as.integer(REPUBLICANVOTES), col = "Republican Votes"))

new_df <- df %>% mutate(average = ((VOTES_2012 - VOTES_2008) / VOTES_2008) * 100)

#This second graph, I don't understand what it does. It takes the 
ggplot() + 
  coord_cartesian() + 
  scale_x_discrete() +
  scale_y_continuous() +
  #facet_wrap(~SURVIVED) +
  #facet_grid(.~SURVIVED, labeller=label_both) + # Same as facet_wrap but with a label.
  #facet_grid(PCLASS~SURVIVED, labeller=label_both) +
  labs(title='Democrat vs Republican votes by State') +
  labs(x="State", y=paste("Number of Votes")) +
  layer(data=df2012, 
        mapping=aes(x=as.character(STATE), y=as.integer(DEMOCRATVOTES),color="Democratic Votes"), 
        stat="identity", 
        stat_params=list(), 
        geom="point",
        geom_params=list(), 
        #position=position_identity()
        position=position_jitter(width=0, height=0)
  )+
  layer(data=df2012, 
        mapping=aes(x=as.character(STATE), y=as.integer(REPUBLICANVOTES),color="Republican Votes"), 
        stat="identity", 
        stat_params=list(), 
        geom="point",
        geom_params=list(), 
        #position=position_identity()
        position=position_jitter(width=0, height=0)
  )