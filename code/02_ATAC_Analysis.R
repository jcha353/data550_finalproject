here::i_am("code/02_ATAC_Analysis.R")
# set path from project directory 

# load seurat data 
seurat <- readRDS(file = here::here("data/seurat.rds"))

seurat$cell_name <- paste(seurat$cell_type, seurat$batch, sep = "_")
Idents(seurat) <- "cell_name"

# Set assay to ATAC
DefaultAssay(seurat) <- "ATAC"

peak_result <- FindMarkers(seurat, ident.1 = "1_control", ident.2 = "1_treated", verbose = FALSE)
peak_result$peak <- row.names(peak_result)

sig_peak <- peak_result$peak[which(peak_result$p_val < 0.05)]

sig1_ATAC <- peak_result[peak_result$peak %in% sig_peak[1:10], c('peak', 'avg_log2FC', 'p_val')]
row.names(sig1_ATAC) <- NULL
sig1_ATAC<- sig1_ATAC%>%
  mutate(`p_val` = ifelse(`p_val` < 0.01, "<0.01", `p_val`))

saveRDS(
  sig1_ATAC,
  file = here::here("output/ATAC_peak.rds")
)

# Plot DE peaks results
perform_DE_analysis_peaks <- function(seurat, ident_1, ident_2, output_file) {
  # Perform differential expression analysis
  de_result <- FindMarkers(seurat, ident.1 = ident_1, ident.2 = ident_2, verbose = FALSE)
  
  # Set row names (genes) as a column called genes
  de_result$peak <- row.names(de_result)
  
  # Select significant genes with p-value < 0.05
  sig_peak <- de_result$peak[which(de_result$p_val < 0.05)]
  
  # Set identity classes
  Idents(seurat) <- "cell_name"
  
  # Create individual violin plots for the top 2 most significant genes
  plots <- lapply(sig_peak[1:2], function(feature) {
    plot <- VlnPlot(seurat, features = feature, idents = c(ident_1, ident_2), group.by = "batch")
    # Manually modify the y-axis label
    plot$labels$y <- "Accessibility Level"
    return(plot)
  })
  
  # Combine the plots with cowplot
  combined_plot <- cowplot::plot_grid(plotlist = plots, labels = c("", ""), align = "hv", ncol = 2)
  print(combined_plot)
  # Save output plot 
  ggsave(output_file, combined_plot, device = "png", width = 8, height = 6)
}

perform_DE_analysis_peaks(seurat, ident_1 = "1_control", ident_2 = "1_treated", output_file = here::here("output/figures/ATAC/DE_cell1.png"))
