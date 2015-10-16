require("jsonlite")
require(dplyr)
require(ggplot2)
require("RCurl")

df1 <- data.frame(fromJSON(getURL(URLencode(gsub("\n", " ", '129.152.144.84:5001/rest/native/?query=
                                                 "SELECT STATE_ABBREVIATION, SUM(GENERAL_RESULTS) as Votes_2008
                                                 FROM COPY_OF_2008PRESREFORMATTED
                                                 WHERE FIRST_NAME is null AND STATE_ABBREVIATION is not null
                                                 GROUP BY STATE_ABBREVIATION;"
                                                 ')),httpheader=c(DB='jdbc:oracle:thin:@129.152.144.84:1521/PDBF15DV.usuniversi01134.oraclecloud.internal', USER='cs329e_jam8789', PASS='orcl_jam8789', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE)));

df2 <- data.frame(fromJSON(getURL(URLencode(gsub("\n", " ", '129.152.144.84:5001/rest/native/?query=
                                                 "SELECT STATE_ABBREVIATION, SUM(TOTAL_VOTES_CAST) as Votes_2012
                                                 FROM US_ELECTION_RESULTS
                                                 GROUP BY STATE_ABBREVIATION;"
                                                 ')),httpheader=c(DB='jdbc:oracle:thin:@129.152.144.84:1521/PDBF15DV.usuniversi01134.oraclecloud.internal', USER='cs329e_jam8789', PASS='orcl_jam8789', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE)));

df <- dplyr::full_join(df1, df2, by="STATE_ABBREVIATION")

require(extrafont)
ggplot(df, 
        aes(STATE_ABBREVIATION, y = value, color = variable)) + 
        geom_point(aes(y = VOTES_2008, col = "y1")) + 
        geom_point(aes(y = VOTES_2012, col = "y2"))

new_df <- df %>% mutate(average = ((VOTES_2012 - VOTES_2008) / VOTES_2008) * 100)

ggplot() + 
  coord_cartesian() + 
  scale_x_discrete() +
  scale_y_continuous() +
  #facet_wrap(~SURVIVED) +
  #facet_grid(.~SURVIVED, labeller=label_both) + # Same as facet_wrap but with a label.
  #facet_grid(PCLASS~SURVIVED, labeller=label_both) +
  labs(title='Percent Change Between Last Two Elections') +
  labs(x="State", y=paste("Percent Change")) +
  layer(data=new_df, 
        mapping=aes(x=as.character(STATE_ABBREVIATION), y=as.numeric(average)), 
        stat="identity", 
        stat_params=list(), 
        geom="point",
        geom_params=list(), 
        #position=position_identity()
        position=position_jitter(width=0.3, height=0)
  )