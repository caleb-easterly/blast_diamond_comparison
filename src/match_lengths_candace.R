colNames <- c("QuerySeqID", "MatchSeqID", "PercIdentMatch", 
              "MatchLength", "NMismatch", "GapOpen",
              "QueryStart", "QueryEnd", "MatchStart", "MatchEnd",
              "Evalue", "Bitscore", "QueryLength")

query_lengths_df <- read.delim("../candace_data/seqlengths.tab", header=FALSE, col.names="QueryLength")
query_lengths_df$var <- "query"
query_lengths_df$run <- "query"

blast1_df <- read.delim("candace_out/blast1.tab", header=FALSE, col.names=colNames)
blast1_df$run <- "blast"
blast1_df$var <- "E<1e-3"

diamond1_df <- read.delim("candace_out/diamond1.tab", header=FALSE, col.names=colNames)
diamond1_df$run <- "diamond"
diamond1_df$var <- "E<1e-3"

blast3_df <- read.delim("candace_out/blast3.tab", header=FALSE, col.names=colNames)
blast3_df$run <- "blast"
blast3_df$var <- "E<2e5"

diamond6_df <- read.delim("candace_out/diamond6.tab", header=FALSE, col.names=colNames)
diamond6_df$run <- "diamond"
diamond6_df$var <- "E<2e5"

require(dplyr)
all_df <- rbind(
                select(
                       rbind(blast1_df,
                        diamond1_df,
                        blast3_df,
                        diamond6_df),
                QueryLength,
                run,
                var),
                query_lengths_df
                )
              
require(ggplot2)
cbbPalette <- c("#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")

ggplot(all_df) + 
    geom_density(aes(x=QueryLength,fill=run), alpha=0.3)+
    facet_grid(var~.) + 
    theme_bw(base_size=14) +
    scale_fill_manual(values=c("yellow", "red", "dodgerblue"))+
    scale_x_continuous(breaks=seq(5, 35, by = 5), limits = c(5, 35)) + 
    labs(y="Density", x="Sequence Length", title="Lengths of Matched Queries")
ggsave("candace_lengths.png", width=8, height=10, units="in")
