require(ggplot2)


colNames <- c("QuerySeqID", "MatchSeqID", "PercIdentMatch", 
              "MatchLength", "NMismatch", "GapOpen",
              "QueryStart", "QueryEnd", "MatchStart", "MatchEnd",
              "Evalue", "Bitscore", "QueryLength")

blast3_df <- read.delim("out/blast3.tab", header=FALSE, col.names=colNames)
blast3_df$method <- "blast"

diamond9_df <- read.delim("out/diamond9.tab", header=FALSE, col.names=colNames)
diamond9_df$method <- "diamond"

all_df <- rbind(blast3_df, diamond9_df)

# change to ggplot hex thing
#par(mfrow=c(1, 2))
#plot(Evalue ~ MatchLength, data=blast3_df)
#plot(Evalue ~ MatchLength, data = diamond9_df)
#par(mfrow=c(1,1))

ggplot(subset(all_df)) + 
    geom_hex(aes(x=MatchLength,y=Evalue))+
    theme_bw() +
    theme(aspect.ratio =1) +
    facet_grid(.~method)
ggsave("images/length_versus_evalue.png", width=10, height=7, units="in")

ggplot(subset(all_df, Evalue < 10)) + 
    geom_hex(aes(x=MatchLength,y=Evalue))+
    theme_bw() +
    theme(aspect.ratio =1) +
    facet_grid(.~method)
ggsave("images/length_versus_small_evalue.png", width=10, height=7, units="in")


