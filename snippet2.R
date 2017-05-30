
library(dplyr)

# Map 1-based optional input ports to variables
appearances <- maml.mapInputPort(1) # class: data.frame

# Contents of optional Zip port are in ./src/
# source("src/yourfile.R");
# load("src/yourData.rdata");
g = group_by(appearances, playerID, yearID)
app_grp = dplyr::summarise(g, G_p=sum(G_p),G_c=sum(G_c),G_1b=sum(G_1b),G_2b=sum(G_2b),G_3b=sum(G_3b),G_ss=sum(G_ss),G_lf=sum(G_lf),G_cf=sum(G_cf),G_rf=sum(G_rf),G_of=sum(G_of))
gpbypos = select(app_grp,playerID,G_p,G_c,G_1b,G_2b,G_3b,G_ss,G_lf,G_cf,G_rf,G_of)
pos = data.frame(position=colnames(gpbypos[,-1])[max.col(as.matrix(gpbypos[,-1]), ties.method = 'first')])
pos$position[pos$position %in% c("G_lf", "G_rf", "G_cf")] = "G_of"
pos$position = as.factor(pos$position)
pos = droplevels(pos)
app_grp$position = pos$position



# Select data.frame to be sent to the output Dataset port
maml.mapOutputPort("appearances");