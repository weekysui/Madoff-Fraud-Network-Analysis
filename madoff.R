setwd("C:/Users/weeky/Desktop/Madoff")
library(statnet)
library(igraph)
library(intergraph)
library(RColorBrewer)
library(readr)
library(haven)
library(UserNetR)
library(sna)

madoff <- read.csv('madoff.csv',row.names=1)
firms <- read.csv("firms.csv")
madoffnet<- network(madoff, mode='adjacency', ignore.eval=FALSE, directed = T)
madoffnet %v% 'px_class' <- firms$px_class
madoffnet %v% 'country_code' <- firms$country_code
madoffnet %v% 'continent_code' <- firms$continent_code
madoffnet %v% 'investor_code' <- firms$investor_code

op<-par(mar=c(0,0,0,0),mfrow=c(1,1))# madoffnet$layout <- layout.kamada.kawai
plot(madoffnet, vertex.cex=madoffnet %v% 'px_class'*0.5, displaylabels=T, vertex.col = madoffnet %v% 'country_code',edge.col="grey", label.pos =1,label.cex=0.6)
legend("bottomleft",c("DOMESTIC","UNKNOWN","INTERNATIONAL"),cex=.5,pch=19,col=c(1,2,3),title = "Country", box.col = 'red', bg="lightblue",text.font = 4)
plot(madoffnet, vertex.cex=madoffnet %v% 'px_class', displaylabels=T, vertex.col = madoffnet %v% 'continent_code', edge.col="darkgrey", label.pos = 1,label.cex=0.6)
legend("topleft",c("EUROPE","NORTH AMERICA","SOUTH AMERICA", "ASIA", "UNKNOWN", "AFRICA", "ANTARCTICA", "AUSTRALIA"),cex=.5,pch=19,col=c(1,2,3,4,5,6,7,8),title = "Continents", box.col = 'red', bg="lightyellow",text.font = 2)
plot(madoffnet, vertex.cex=1.5, displaylabels=T, vertex.col = madoffnet %v% 'investor_code', edge.col="darkgrey", label.pos = 1,label.cex=0.6)
legend("topleft",c("bank","financial services company","hedge funds", "insurer", "Investment management firm", "brokerage", "asset manager", "others"),cex=.5,pch=19,col=c(1,2,3,4,5,6,7,8),title = "Investor types", box.col = 'red', bg="lightyellow",text.font = 2)
par(op)

network.size(madoffnet)
network.density(madoffnet)
components(madoffnet)
diameter(asIgraph(madoffnet))
transitivity(asIgraph(madoffnet))


net_mat <- as.matrix(madoff)
madnet <- network(net_mat,matrix.type='adjacency',directed = T)
df.prom <- data.frame(
  deg = degree(madnet, gmode='graph'),
  cls = closeness(madnet, gmode='graph'),
  btw = betweenness(madnet, gmode='graph'),
  evc = evcent(madnet, gmode='graph'),
  row.names = row.names(net_mat)
)
head(df.prom[order(-df.prom$deg),],n=20)
cor(df.prom)

null_model <- ergm(madoffnet ~ edges)
summary(null_model) 

reciprocity_model <- ergm(madoffnet ~ edges + mutual)
summary(reciprocity_model)


