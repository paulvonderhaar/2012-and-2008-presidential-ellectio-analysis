require("jsonlite")
require(dplyr)
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

df %>% mutate(average = ((VOTES_2012 - VOTES_2008) / VOTES_2008) * 100) %>% View