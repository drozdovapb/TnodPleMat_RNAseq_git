## get the sequences
wget ftp://ftp.ebi.ac.uk/pub/databases/wormbase/parasite/releases/WBPS13/species/dibothriocephalus_latus/PRJEB1206/dibothriocephalus_latus.PRJEB1206.WBPS13.protein.fa.gz
wget ftp://ftp.ebi.ac.uk/pub/databases/wormbase/parasite/releases/WBPS13/species/clonorchis_sinensis/PRJNA386618/clonorchis_sinensis.PRJNA386618.WBPS13.protein.fa.gz
wget ftp://ftp.ebi.ac.uk/pub/databases/wormbase/parasite/releases/WBPS13/species/echinococcus_canadensis/PRJEB8992/echinococcus_canadensis.PRJEB8992.WBPS13.protein.fa.gz
wget ftp://ftp.ebi.ac.uk/pub/databases/wormbase/parasite/releases/WBPS13/species/echinococcus_granulosus/PRJEB121/echinococcus_granulosus.PRJEB121.WBPS13.protein.fa.gz
wget ftp://ftp.ebi.ac.uk/pub/databases/wormbase/parasite/releases/WBPS13/species/echinococcus_multilocularis/PRJEB122/echinococcus_multilocularis.PRJEB122.WBPS13.protein.fa.gz
wget ftp://ftp.ebi.ac.uk/pub/databases/wormbase/parasite/releases/WBPS13/species/hydatigera_taeniaeformis/PRJEB534/hydatigera_taeniaeformis.PRJEB534.WBPS13.protein.fa.gz
wget ftp://ftp.ebi.ac.uk/pub/databases/wormbase/parasite/releases/WBPS13/species/hymenolepis_diminuta/PRJEB507/hymenolepis_diminuta.PRJEB507.WBPS13.protein.fa.gz
wget ftp://ftp.ebi.ac.uk/pub/databases/wormbase/parasite/releases/WBPS13/species/hymenolepis_microstoma/PRJEB124/hymenolepis_microstoma.PRJEB124.WBPS13.protein.fa.gz
wget ftp://ftp.ebi.ac.uk/pub/databases/wormbase/parasite/releases/WBPS13/species/hymenolepis_nana/PRJEB508/hymenolepis_nana.PRJEB508.WBPS13.protein.fa.gz
wget ftp://ftp.ebi.ac.uk/pub/databases/wormbase/parasite/releases/WBPS13/species/mesocestoides_corti/PRJEB510/mesocestoides_corti.PRJEB510.WBPS13.protein.fa.gz
wget ftp://ftp.ebi.ac.uk/pub/databases/wormbase/parasite/releases/WBPS13/species/schistocephalus_solidus/PRJEB527/schistocephalus_solidus.PRJEB527.WBPS13.protein.fa.gz
wget ftp://ftp.ebi.ac.uk/pub/databases/wormbase/parasite/releases/WBPS13/species/spirometra_erinaceieuropaei/PRJEB1202/spirometra_erinaceieuropaei.PRJEB1202.WBPS13.protein.fa.gz
wget ftp://ftp.ebi.ac.uk/pub/databases/wormbase/parasite/releases/WBPS13/species/taenia_asiatica/PRJEB532/taenia_asiatica.PRJEB532.WBPS13.protein.fa.gz
wget ftp://ftp.ebi.ac.uk/pub/databases/wormbase/parasite/releases/WBPS13/species/taenia_multiceps/PRJNA307624/taenia_multiceps.PRJNA307624.WBPS13.protein.fa.gz
wget ftp://ftp.ebi.ac.uk/pub/databases/wormbase/parasite/releases/WBPS13/species/taenia_saginata/PRJNA71493/taenia_saginata.PRJNA71493.WBPS13.protein.fa.gz
wget ftp://ftp.ebi.ac.uk/pub/databases/wormbase/parasite/releases/WBPS13/species/taenia_solium/PRJNA170813/taenia_solium.PRJNA170813.WBPS13.protein.fa.gz
#outgroup
wget ftp://ftp.ebi.ac.uk/pub/databases/wormbase/parasite/releases/WBPS13/species/clonorchis_sinensis/PRJNA386618/clonorchis_sinensis.PRJNA386618.WBPS13.protein.fa.gz
wget ftp://ftp.ebi.ac.uk/pub/databases/wormbase/parasite/releases/WBPS13/species/schistosoma_mansoni/PRJEA36577/schistosoma_mansoni.PRJEA36577.WBPS13.protein.fa.gz

## run proteinortho
$appdir/proteinortho_v6.0b/proteinortho6.pl -singles -project=Tnod -cpus=6 -nograph *fa
## this file is processed with `sort_po_table.R` => and we have lists of names by group, as well as by organism. We'll need both.

## now extract the sequences from all fasta files (by species so far)
for file in *fa; do xargs faidx $file < $file.names.txt | fasta_formatter >tree/$file.oto.fa ; done
cd ../tree/
cat *fa >all.fasta
## and now extract for each protein group one-by-one
for names in family*names.txt; do xargs faidx all.fasta < $names > $names.fasta ; done

## align each protein group
for multifasta in family*fasta; do mafft --auto $multifasta >$multifasta.aln; done
## gblocks filtering
ls *aln* >gblocks.paths.txt
$appdir/Gblocks_0.91b/Gblocks gblocks.paths.txt 

## a bit more formatting
for file in family*.names.txt.fasta.aln-gb; do fasta_formatter -i $file >$file.singleline.fa; done
paste -d="" *singleline.fa | sed -e 's/=>//g' | sed -e 's/=//g' | sed -e 's/*//g' | sed -e's/ //g' >cestodes_concatenated_aln.fasta
## may require a bit of manual cleanup if iqtree throws an error about some symbols, but hopefully not

## finally build the tree! 
$appdir/iqtree-1.6.10-Linux/bin/iqtree -s cestodes_concatenated_aln.fasta -abayes -alrt 1000

## then use ggtree to plot it and inkscape to make it pretty (`build_tree.R`)