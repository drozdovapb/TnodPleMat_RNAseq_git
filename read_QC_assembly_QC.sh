## read QC
fastQC $home/TnodPlMa/Borvinskaya_20181001/*.fastq.gz

## de novo assembly
$appdir/trinityrnaseq-Trinity-v2.4.0/Trinity --trimmomatic --seqType fq --max_memory 50G --left $home/TnodPlMa/Borvinskaya_20181001/Worms_RNA_S3_L008_R1_001.fastq.gz --right $home/TnodPlMa/Borvinskaya_20181001/Worms_RNA_S3_L008_R2_001.fastq.gz --CPU 11 --output TnodPleMat_take1_trinity --bypass_java_version_check 

## BUSCO
python $appdir/busco/scripts/run_BUSCO.py --in TnodPleMat.fasta -o TnodPleMat -m tran -f -l /media/main/databases/metazoa_odb9/ --cpu 9
## TransRate
$appdir/transrate-1.0.3-linux-x86_64/transrate --assembly TnodPleMat.fasta