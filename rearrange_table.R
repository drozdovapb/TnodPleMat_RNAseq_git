options(stringsAsFactors = F)
tbl <- read.delim("table3_2.tsv")

library(dplyr)

tbl2 <- 
tbl %>% group_by(Presence.absence.in.T..nodulosus.proteome, 
                 Compra.family..IHGC..2019., Category, #these two are important
                 Protein.domain.name, #this should match as well
                 High.level.annotation.category.Function #this should match as well
                 ) %>%
  summarize(TnodPleMat_SeqName = toString(TnodPleMat_SeqName), 
            X..orthologous_group = toString(X..orthologous_group)) 

write.table(tbl2, "table3_2_merged.tsv", sep = "\t", row.names = F)



###just in case
tbl2 <- 
  tbl %>% group_by(Compra.family..IHGC..2019.) %>%
  summarize(Presence.absence.in.T..nodulosus.proteome = toString(Presence.absence.in.T..nodulosus.proteome), 
            High.level.annotation.category.Function = toString(High.level.annotation.category.Function ),
            Category = toString(Category), 
            Protein.domain.name = toString(Protein.domain.name),
            TnodPleMat_SeqName = toString(TnodPleMat_SeqName), 
            X..orthologous_group = toString(X..orthologous_group)) 
