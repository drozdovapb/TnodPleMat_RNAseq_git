options(stringsAsFactors = F)

tbl <- read.delim("data/Tnod.proteinortho", na.strings = "*")

### now unique transcripts
#how many unique transcripts? 
unique_transcripts <- unique(sub(".p.*", "", tnod$TnodPleMat_final.fasta.transdecoder.fa))
length(unique_transcripts) #transcripts
#16999 transcripts
presentTnod <- tbl[! is.na(tbl$TnodPleMat_final.fasta.transdecoder.fa), ] #32k
View(colSums(!is.na(presentTnod[,2:21])))

expTnod <- presentTnod[grepl(",", presentTnod$TnodPleMat_final.fasta.transdecoder.fa), 1:4]


onlyone <- tbl[tbl$X..Species == 1,]

#this is for unique in each
colSums(!is.na(onlyone[,2:21]))

#unique proteins #are these the same as unique groups? 
tnod <- tbl[tbl$X..Species == 1 & !is.na(tbl$TnodPleMat_final.fasta.transdecoder.fa), ]
length(tnod$TnodPleMat_final.fasta.transdecoder.fa) #protein groups
sum(tnod$Genes) #protein groups
#yeap! #cool!


onlytwo <- tbl[tbl$X..Species == 2,] #19k
twowithTnod <- onlytwo[! is.na(onlytwo$TnodPleMat_final.fasta.transdecoder.fa), ]
View(colSums(!is.na(twowithTnod[,2:23])))

##and now add uniqueness information to the transcripts
annotation <- read.delim("./TnodPleMat_AnnotationTable.txt")
annotation$Unique <- ifelse(annotation$Sequence.Name %in% unique_transcripts, "unique for T. nodulosus", "")

write.table(annotation, "./TnodPleMat_AnnotationTable_uniqueness2.txt", row.names = F, sep = "\t")


#one-to-one orthologs?
presentinall <- tbl[complete.cases(tbl), ]
#onetoone <- presentinall[presentinall$X..Species == presentinall$Genes, ] #too naive
has.commas <- apply(presentinall, 1, function(x) grep(",", x))
nocommas <- sapply(has.commas, function(x) length(x) == 0)
onetoone <- presentinall[nocommas, ]


#write name lists
for (i in 4:ncol(onetoone)) {
  writeLines(onetoone[,i], paste0(names(onetoone[i]), ".names.txt"))
}

# and families
for (i in 1:nrow(onetoone)) {
  oo <- as.matrix(onetoone)
  writeLines(oo[i, 4:21], paste0("family", as.character(i), ".names.txt"))
}
