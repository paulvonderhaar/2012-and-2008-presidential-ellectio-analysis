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


df <- dplyr::left_join(df1, df2, by="STATE_ABBREVIATION")

df <- df %>% mutate(OBAMA_2012_PERCENT = (OBAMA_VOTES_2012 / TOTAL_VOTES_2012)) %>% tbl_df

head(df)

