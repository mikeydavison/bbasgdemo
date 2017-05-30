library(dplyr)

# Map 1-based optional input ports to variables
battingAndASG <- maml.mapInputPort(1) # class: data.frame
appearances <- maml.mapInputPort(2) # class: data.frame

# Contents of optional Zip port are in ./src/
# source("src/yourfile.R");
# load("src/yourData.rdata");

df = merge(battingAndASG, appearances, by=c("playerID", "yearID"), all.x = TRUE)

#get rid of pitchers and data from pre 1990
df = df %>% filter(yearID > 1990) %>% filter(G_p < 1)

# Select data.frame to be sent to the output Dataset port
maml.mapOutputPort("df");