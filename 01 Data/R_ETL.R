require(tidyr)
require(dplyr)
require(ggplot2)

# Be sure to set working directory to whatever's right for your machine
setwd("~/Desktop/University of Texas Classwork/Elements of Data Visualization/JacobAndThePauls-DV_RProject3/01 Data")

file_path <- "US presidential election results by county.csv"

df <- read.csv(file_path, stringsAsFactors = FALSE)

# Replace "." (i.e., period) with "_" in the column names.
names(df) <- gsub("\\.+", "_", names(df))

str(df) # Uncomment this and  run just the lines to here to get column types to use for getting the list of measures.


measures <- c("County_Number", "FIPS_Code", "Precincts_Reporting", "Total_Precincts", "State_Candidate_Number_varies_between_state_", "TOTAL_VOTES_CAST", "Order", "Use_Junior", "Incumbent", "Votes", "National_Politician_ID_NPID_", "State_Candidate_Number_varies_between_state_1", "Order_1", "Use_Junior_1", "Incumbent_1", "Votes_1", "National_Politician_ID_NPID_1", "State_Candidate_Number_varies_between_state_2", "Order_2", "Use_Junior_2", "Incumbent_2",  "Votes_2", "National_Politician_ID_NPID_2", "State_Candidate_Number_varies_between_state_3", "Order_3", "Use_Junior_3", "Incumbent_3", "Votes_3", "National_Politician_ID_NPID_3", "State_Candidate_Number_varies_between_state_4", "Order_4", "Use_Junior_4", "Incumbent_4", "Votes_4", "National_Politician_ID_NPID_4", "State_Candidate_Number_varies_between_state_5", "Order_5", "Use_Junior_5", "Incumbent_5", "Votes_5", "National_Politician_ID_NPID_5", "State_Candidate_Number_varies_between_state_6", "Order_6", "Use_Junior_6", "Incumbent_6", "Votes_6", "National_Politician_ID_NPID_6", "State_Candidate_Number_varies_between_state_7",  "Order_7"  )
#measures <- NA # Do this if there are no measures.

# Get rid of special characters in each column.
# Google ASCII Table to understand the following:
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
# Fix date columns, this needs to be done by hand because | needs to be correct.
#                                                        \_/
#df$Order_Date <- gsub(" [0-9]+:.*", "", gsub(" UTC", "", mdy(as.character(df$Order_Date), tz="UTC")))
#df$Ship_Date  <- gsub(" [0-9]+:.*", "", gsub(" UTC", "", mdy(as.character(df$Ship_Date),  tz="UTC")))

# The following is an example of dealing with special cases like making state abbreviations be all upper case.
# df["State"] <- data.frame(lapply(df["State"], toupper))

# Get rid of all characters in measures except for numbers, the - sign, and period.dimensions
if( length(measures) > 1 || ! is.na(measures)) {
  for(m in measures) {
    df[m] <- data.frame(lapply(df[m], gsub, pattern="[^--.0-9]",replacement= ""))
  }
}

write.csv(df, paste(gsub(".csv", "", file_path), ".reformatted.csv", sep=""), row.names=FALSE, na = "")

tableName <- gsub(" +", "_", gsub("[^A-z, 0-9, ]", "", gsub(".csv", "", file_path)))
sql <- paste("CREATE TABLE", tableName, "(\n-- Change table_name to the table name you want.\n")
if( length(measures) > 1 || ! is.na(dimensions)) {
  for(d in dimensions) {
    sql <- paste(sql, paste(d, "varchar2(4000),\n"))
  }
}
if( length(measures) > 1 || ! is.na(measures)) {
  for(m in measures) {
    if(m != tail(measures, n=1)) sql <- paste(sql, paste(m, "number(38,4),\n"))
    else sql <- paste(sql, paste(m, "number(38,4)\n"))
  }
}
sql <- paste(sql, ");")
cat(sql)


