require(tidyr)
require(dplyr)
head(df1)
df2
dplyr::filter(df1,CANDIDATE=="Obama")
dplyr::filter(df1,CANDIDATE=="McCain")
dplyr::filter(df1,CANDIDATE!="McCain"&CANDIDATE!="Obama")