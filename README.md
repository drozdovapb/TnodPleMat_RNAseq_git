
## Readme

This repository contains companion data for the *Triaenophorus nodulosus* transcriptome manuscript (...). It is intended to provide code and raw data for reproducibility but not for use as a pipeline. However, you are free to reuse the code at your own risk. 

## Folder structure

The main folder contains code chunks used to create the materials described in the manuscript.
The `data` folder 

## Data analysis pipeline
1. The raw data are available from SRA.
2. They were assembled with Trinity. The assembly  was subjected to quality control, filtering, and submitted to TSA: **add**
3. Proteome prediction, orthology clustering, and tree construction: `run_po_build_tree.sh`.
4. Tree visualization: **add**
5. Helper scripts to rearrange the data: `sort_po_table.R`, `rearrange_table.R`.
