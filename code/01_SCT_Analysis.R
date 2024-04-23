here::i_am("code/01_SCT_Analysis.R")
# set path from project directory 

# load Libraries 
options(warn=-1)
# load the pacman library 
if(!require('pacman')) { 
  install.packages('pacman') 
  library('pacman') 
} 

library(here)
suppressMessages(
  {
    p_load(Seurat, SeuratData,dplyr, ggplot2, Signac, qlcMatrix, BSgenome.Mmusculus.UCSC.mm10, knitr, here)
  }
)
#"BSgenome.Mmusculus.UCSC.mm10@1.4.3"

# load seurat data 
seurat <- readRDS(file = here::here("data/seurat.rds"))

# Add a column in the metadata to contain the cell type number and whether it is treatment or control
# Cluster to that column
seurat$cell_name <- paste(seurat$cell_type, seurat$batch, sep = "_")
Idents(seurat) <- "cell_name"

# SCT Analysis- Perform DE analysis

de_result <- FindMarkers(seurat, ident.1 = "1_control", ident.2 = "1_treated", verbose = FALSE, recorrect_umi = FALSE)
de_result$gene <- row.names(de_result)
sig_genes <- de_result$gene[which(de_result$p_val < 0.05)]
sig1_SCT <- de_result[de_result$gene %in% sig_genes[1:10], c('gene','avg_log2FC', 'p_val')]
row.names(sig1_SCT) <- NULL
sig1_SCT <- sig1_SCT %>%
  mutate(`p_val` = ifelse(`p_val` < 0.01, "<0.01", `p_val`))


saveRDS(
  sig1_SCT,
  file = here::here("output/SCT_gene.rds")
)


# Function Plots DE gene results
perform_DE_analysis <- function(seurat, ident_1, ident_2, output_file) {
  # Perform differential expression analysis
  de_result <- FindMarkers(seurat, ident.1 = ident_1, ident.2 = ident_2, verbose = FALSE,  recorrect_umi = FALSE)
  
  # Set row names (genes) as a column called genes
  de_result$gene <- row.names(de_result)
  
  # Select significant genes with p-value < 0.05
  sig_genes <- de_result$gene[which(de_result$p_val < 0.05)]
  
  # Set identity classes
  Idents(seurat) <- "cell_name"
  
  # Create violin plots for the top 2 most significant genes
  plot <- VlnPlot(seurat, features = sig_genes[1:2], idents = c(ident_1, ident_2), group.by = "batch")
  print(plot)
  # Save output plot 
  ggsave(output_file, plot, device = "png", width = 8, height = 6)
}

# Plot DE cell graph for control vs treatment groups 
perform_DE_analysis(seurat, ident_1 = "1_control", ident_2 = "1_treated", output_file = here::here("output/figures/SCT/DE_cell1.png"))

