# Map 1-based optional input ports to variables
allstar <- maml.mapInputPort(1) # class: data.frame
batting <- maml.mapInputPort(2) # class: data.frame

# Contents of optional Zip port are in ./src/
# source("src/yourfile.R");
# load("src/yourData.rdata");

library(dplyr)

#merge players who played on multiple teams in a year into a single row
g = group_by(batting, playerID, yearID)
batting_grp = dplyr::summarise(g, G=sum(G), AB=sum(AB), R=sum(R), H=sum(H), X2B=sum(X2B), X3B=sum(X3B), HR=sum(HR), RBI=sum(RBI), SB=sum(SB), BB=sum(BB), SO=sum(SO), IBB=sum(IBB), HBP=sum(HBP), SH=sum(SH), SF=sum(SF))

#add batting stats
batting_grp = filter(batting_grp, AB>0) %>% mutate(BA = round(H/AB,3)) %>% mutate(PA = AB+BB+IBB+HBP+SH+SF) %>% mutate(OB = H + BB + IBB + HBP) %>% mutate (OBP = 0 + (AB > 0) * round(OB/PA, 3) )
batting_grp = mutate(batting_grp, TB = H + X2B + 2 * X3B + 3 * HR) %>% mutate(SLG = round(TB/AB, 3)) %>% mutate(OPS = SLG+OBP)

#merge batting and all star history
df = merge(batting_grp, allstar, by=c("playerID", "yearID"), all.x = TRUE)

#add indicator of whether player was all star last year#all star history
aspy = mutate(allstar, nextYear = yearID+1) %>% mutate(IsAllStarPrevYear=TRUE) %>% select(playerID, yearID=nextYear, IsAllStarPrevYear)
aspy[is.na(aspy)] = FALSE
df = merge(df, aspy, by=c("playerID", "yearID"), all.x = TRUE)
ind = is.na(df$IsAllStarPrevYear)
df$IsAllStarPrevYear[ind] = FALSE
df$IsAllStarPrevYear = as.factor(df$IsAllStarPrevYear)
df = mutate(df, IsAllStar = as.factor(!is.na(df$gameNum)))

#df$AllStarClass = "None"
#ind = df$IsAllStar==TRUE & df$position=="G_c"
#df$AllStarClass[ind] = "AS"
#ind = df$IsAllStar==TRUE & df$position=="G_1b"
#df$AllStarClass[ind] = "AS"
#ind = df$IsAllStar==TRUE & df$position=="G_2b"
#df$AllStarClass[ind] = "AS"
#ind = df$IsAllStar==TRUE & df$position=="G_3b"
#df$AllStarClass[ind] = "AS"
#ind = df$IsAllStar==TRUE & df$position=="G_ss"
#df$AllStarClass[ind] = "AS"
#ind = df$IsAllStar==TRUE & df$position=="G_of"
#df$AllStarClass[ind] = "AS"
#df$AllStarClass = as.factor(df$AllStarClass)
df$AllStarClass=as.factor(df$IsAllStar)

# Select data.frame to be sent to the output Dataset port
maml.mapOutputPort("df");