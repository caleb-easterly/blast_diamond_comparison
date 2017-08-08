require(ggplot2)


colNames <- c("QuerySeqID", "MatchSeqID", "PercIdentMatch", 
              "MatchLength", "NMismatch", "GapOpen",
              "QueryStart", "QueryEnd", "MatchStart", "MatchEnd",
              "Evalue", "Bitscore", "QueryLength")

blast3_df <- read.delim("out/blast3.tab", header=FALSE, col.names=colNames)
# blast3_df$run <- "blast"
# blast3_df$var <- "E<1e-3"
diamond9_df <- read.delim("out/diamond9.tab", header=FALSE, col.names=colNames)

# change to ggplot hex thing
#par(mfrow=c(1, 2))
#plot(Evalue ~ MatchLength, data=blast3_df)
#plot(Evalue ~ MatchLength, data = diamond9_df)
#par(mfrow=c(1,1))

ggplot(blast3_df) + 
    geom_hex(aes(x=MatchLength,y=Evalue))+
    theme_bw()
ggsave("length_versus_evalue.png")
