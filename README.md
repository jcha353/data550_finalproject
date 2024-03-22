# DATA 550 Final Project
Single-Cell Multiome Lung Report
------------------------------------------------------------------------

## Initial code description

`code/01_SCT_Analysis.R`

  - performs gene differential expression analysis for control and treated genes in cell type 1
  - tables the top 10 most significantly expressed genes in cell type 1 and saves as a .rds file
  - makes plot of the top 2 most significant genes in cell type 1 and saves as a .png

`code/02_ATAC_Analysis.R`

  - performs differential expression analysis on the chromatin accessibility (peaks) region in cell type 1
  - tables the top 10 most significant peaks in cell type 1 and saves as a .rds file
  - makes plot of the top 2 most significant peaks in cell type 1 and saves as a .png

`code/03_render_report.R`

  - renders `finalproject_report.Rmd`

`finalproject_report.Rmd`

  - reads in table of top 10 most significantly expressed genes in cell type 1 generated from `code/01_SCT_Analysis.R`
  - reads in table of top 10 most significantly expressed peaks in cell type 1 generated from `code/02_ATAC_Analysis.R`
  - displays plots of top 2 significant genes and peaks

`Makefile`

  - contains rules for building the report
  - `make .output/SCT_gene.rds` will generate the table of significant genes
  - `make .output/ATAC_peak.rds` will generate the table of significant peaks
  - `make .clean` will remove all .rds files in the output folder

------------------------------------------------------------------------