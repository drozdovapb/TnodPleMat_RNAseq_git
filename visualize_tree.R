## if installing ggtree doesn't work
#install.packages("tidytree") #it is on CRAN!

## install the main package
#if (!requireNamespace("BiocManager", quietly = TRUE))
#  install.packages("BiocManager")
#BiocManager::install("ggtree", version = "3.8")

library(ggtree)

## read the tree file
tr <- read.iqtree("data/cestodes_concatenated_aln.fasta.treefile")

## play around with labels to get only >70 & >0.7
label <- tr@phylo$node.label
alrt <- as.numeric(sub("/.*", "", label))
bigalrt <- alrt > 70 & !is.na(alrt)
##the first number
bayes <- as.numeric(sub(".*/", "", label))
bigbayes <- bayes > 0.7 & !is.na(bayes)
## subset
newlabel <- ifelse( bigalrt & bigbayes, label, "")
tr@phylo$node.label <- newlabel


## some things are not used, but keeping here just in case
p1 <- ggtree(tr) + 
  geom_nodelab(size = 2, nudge_x = -0.003, nudge_y = 0.2, geom="text") +
  #geom_nodepoint(aes(subset = as.logical(newlabel == ""))) + 
  #geom_point2(aes(subset = as.logical(newlabel == "") & !isTip)) + 
  #geom_nodepoint(aes(subset = 
  #          (as.numeric(sub("/.*", "", label)) > 70 | 
  #            as.numeric(sub(".*/", "", label) > 0.7))  & !isTip)) + 
#  geom_tiplab(size = 2.5, fontface = "italic", align = T) +
  geom_tiplab(size = 3.5, fontface = "italic") + 
  ggplot2::xlim(0, 1)

p1
#identify(p1)


## and save the tree file
ggsave("tree.svg")
