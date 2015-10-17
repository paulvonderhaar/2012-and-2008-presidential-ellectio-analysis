require("jsonlite")
require(dplyr)
require("RCurl")

df1 <- data.frame(fromJSON(getURL(URLencode(gsub("\n", " ", '129.152.144.84:5001/rest/native/?query=
"SELECT STATE_ABBREVIATION, LAST_NAME, GENERAL_RESULTS as TOTAL_VOTES_2008, GENERAL_ as OBAMA_2008_PERCENT
FROM COPY_OF_2008PRESREFORMATTED
ORDER BY STATE_ABBREVIATION asc;"
')),httpheader=c(DB='jdbc:oracle:thin:@129.152.144.84:1521/PDBF15DV.usuniversi01134.oraclecloud.internal', USER='cs329e_jam8789', PASS='orcl_jam8789', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE)));

df1 <- df1 %>% filter(LAST_NAME %in% c("Obama")) %>% select(STATE_ABBREVIATION, TOTAL_VOTES_2008, OBAMA_2008_PERCENT)

df2 <- data.frame(fromJSON(getURL(URLencode(gsub("\n", " ", '129.152.144.84:5001/rest/native/?query=
"SELECT STATE_ABBREVIATION, SUM(TOTAL_VOTES_CAST) as TOTAL_VOTES_2012, SUM(VOTES) as Obama_Votes_2012 FROM US_ELECTION_RESULTS GROUP BY STATE_ABBREVIATION ORDER BY STATE_ABBREVIATION asc;"
')),httpheader=c(DB='jdbc:oracle:thin:@129.152.144.84:1521/PDBF15DV.usuniversi01134.oraclecloud.internal', USER='cs329e_jam8789', PASS='orcl_jam8789', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE)));

head(df2)

df <- dplyr::left_join(df1, df2, by="STATE_ABBREVIATION")

df <- df %>% mutate(OBAMA_2012_PERCENT = (OBAMA_VOTES_2012 / TOTAL_VOTES_2012) * 100) %>% tbl_df

head(df)

measures <- c("TOTAL_VOTES_2008","OBAMA_2008_PERCENT","TOTAL_VOTES_2012","OBAMA_VOTES_2012","OBAMA_2012_PERCENT")

for(n in names(df)) {
  df[n] <- data.frame(lapply(df[n], gsub, pattern="[^ -~]",replacement= ""))
}

dimensions <- setdiff(names(df), measures)
if( length(measures) > 1 || ! is.na(dimensions)) {
  for(d in dimensions) {
    # Get rid of " and ' in dimensions.
    df[d] <- data.frame(lapply(df[d], gsub, pattern="[\"']",replacement= ""))
    # Change & to and in dimensions.
    df[d] <- data.frame(lapply(df[d], gsub, pattern="&",replacement= " and "))
    # Change : to ; in dimensions.
    df[d] <- data.frame(lapply(df[d], gsub, pattern=":",replacement= ";"))
  }
}

library(lubridate)

# Get rid of all characters in measures except for numbers, the - sign, and period.dimensions
if( length(measures) > 1 || ! is.na(measures)) {
  for(m in measures) {
    df[m] <- data.frame(lapply(df[m], gsub, pattern="[^--.0-9]",replacement= ""))
  }
}

head(df)
str(df)

#df$TOTAL_VOTES_2008 <- as.numeric(df$TOTAL_VOTES_2008)
df$OBAMA_2008_PERCENT <- as.numeric(levels(df$OBAMA_2008_PERCENT))[df$OBAMA_2008_PERCENT]
#df$TOTAL_VOTES_2012 <- as.integer(df$TOTAL_VOTES_2012)
#df$OBAMA_VOTES_2012 <- as.integer(df$OBAMA_VOTES_2012)
df$OBAMA_2012_PERCENT <- as.numeric(levels(df$OBAMA_2012_PERCENT))[df$OBAMA_2012_PERCENT]

head(df)

new_df <- df %>% mutate(VOTE_CHANGE = OBAMA_2012_PERCENT - OBAMA_2008_PERCENT)


require(extrafont)
require(ggplot2)

ggplot() + 
  coord_cartesian() + 
  scale_x_discrete() +
  scale_y_continuous() +
  #facet_wrap(~SURVIVED) +
  #facet_grid(.~SURVIVED, labeller=label_both) + # Same as facet_wrap but with a label.
  #facet_grid(PCLASS~SURVIVED, labeller=label_both) +
  labs(title='Change in Popular Vote Percentages for Obama in 2012 Elections') +
  labs(x="State", y=paste("Deviation from 2008 Vote Percentages")) +
  layer(data=new_df, 
        mapping=aes(x=as.character(STATE_ABBREVIATION), y=as.numeric(VOTE_CHANGE)), 
        stat="identity", 
        stat_params=list(), 
        geom="point",
        geom_params=list(), 
        #position=position_identity()
        position=position_jitter(width=0.3, height=0)
  )


