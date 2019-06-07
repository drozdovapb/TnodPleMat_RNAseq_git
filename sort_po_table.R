options(stringsAsFactors = F)

## read the proteinortho table
tbl <- read.delim("data/Tnod.proteinortho", na.strings = "*")

## total number of protein group in each species
colSums(!is.na(tbl[,2:21]))

## species-specific proteins
onlyone <- tbl[tbl$X..Species == 1,]
## how many species-specific groups for each
colSums(!is.na(onlyone[,4:21]))

## unique proteins #are these the same as unique groups? 
tnod <- tbl[tbl$X..Species == 1 & !is.na(tbl$TnodPleMat_final.fasta.transdecoder.fa), ]
length(tnod$TnodPleMat_final.fasta.transdecoder.fa) #protein groups
sum(tnod$Genes) #protein groups
#yeap! #cool!

### now unique transcripts (just in case)
## how many unique transcripts? 
unique_transcripts <- unique(sub(".p.*", "", tbl$TnodPleMat_final.fasta.transdecoder.fa))
length(unique_transcripts) ## transcripts (of course more than proteins)

## present in T. nodulosus
presentTnod <- tbl[! is.na(tbl$TnodPleMat_final.fasta.transdecoder.fa), ] #32k
## shared with T. nodulosus
colSums(!is.na(presentTnod[,2:21]))

## Present in two species only
onlytwo <- tbl[tbl$X..Species == 2,] #19k
## One of these species in T. nodulosus
twowithTnod <- onlytwo[! is.na(onlytwo$TnodPleMat_final.fasta.transdecoder.fa), ]
View(colSums(!is.na(twowithTnod[,2:23])))

##and now add uniqueness information to the transcripts
#annotation <- read.delim("./TnodPleMat_AnnotationTable.txt")
#annotation$Unique <- ifelse(annotation$Sequence.Name %in% unique_transcripts, "unique for T. nodulosus", "")
#write.table(annotation, "./TnodPleMat_AnnotationTable_uniqueness2.txt", row.names = F, sep = "\t")

## one-to-one orthologs for the tree!
## present in each species
presentinall <- tbl[complete.cases(tbl), ]
## present in each species only once
onetoone <- presentinall[presentinall$X..Species == presentinall$Genes, ] #too naive
## 70 proteins as potential one-to-one orthologs

## another way to check these calculations
#has.commas <- apply(presentinall, 1, function(x) grep(",", x))
#nocommas <- sapply(has.commas, function(x) length(x) == 0)
#onetoone <- presentinall[nocommas, ]
## 70 proteins as potential one-to-one orthologs

## write name lists to later extract
for (i in 4:ncol(onetoone)) {
  writeLines(onetoone[,i], paste0(names(onetoone[i]), ".names.txt"))
}

## and gene lists grouped by families
for (i in 1:nrow(onetoone)) {
  oo <- as.matrix(onetoone)
  writeLines(oo[i, 4:21], paste0("family", as.character(i), ".names.txt"))
}
