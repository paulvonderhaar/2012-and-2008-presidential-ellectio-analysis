require(tidyr)
require(dplyr)
head(df2008)
df2012
dplyr::filter(df2008,CANDIDATE=="Obama")
dplyr::filter(df2008,CANDIDATE=="McCain")
dplyr::filter(df2008,CANDIDATE!="McCain"&CANDIDATE!="Obama")
dplyr::mutate(df2008,PercentVoters=TOTALVOTES/TOTALPOPULATION)