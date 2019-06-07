### it's just a piece of code to prepare the suppl table 3
### let me just leave it here

## this is *heavily* based on the dplyr library
library(dplyr)
options(stringsAsFactors = F)

### Table 3.2
##### 
tbl <- read.delim("../table3_2.tsv")

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
##### 


## Table 3.1
#####

tbl1 <- read.csv2("../table3_1.csv")

tbl2 <- 
  tbl1 %>% group_by(IHGC.Compra_family..Plathyhelminthes.) %>%
  summarize(homologs..Platyhelminthes. = toString(homologs..Platyhelminthes.), 
            homolog.T.nodulosus = toString(homolog.T.nodulosus)) 

tbl2 <- as.data.frame(tbl2)

only_unique_proteins <- function(x) {
  ## here x is each value in the homolog.T.nodulosus column
    ## for testing
    # x <- tbl2$homolog.T.nodulosus[11]
  allnames <- as.vector(strsplit(x, ", "))
  uniq <- unique(unlist(allnames))
  uv <- as.vector(uniq)
  uv <- uv[!(uv == "")]
  xnew <- paste(uv, collapse = ", ")
  return(xnew)
}

tbl2$homolog.T.nodulosus <- sapply(tbl2$homolog.T.nodulosus, FUN = only_unique_proteins)

write.table(tbl2, "../table3_1_merged.tsv", sep = "\t", row.names = F)
