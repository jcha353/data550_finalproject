finalproject_report.html: finalproject_report.Rmd code/01_SCT_Analysis.R code/02_ATAC_Analysis.R
	Rscript code/03_render_report.R

output/SCT_gene.rds: code/01_SCT_Analysis.R
	Rscript code/01_SCT_Analysis.R

output/ATAC_peak.rds: code/02_ATAC_Analysis.R
	Rscript code/02_ATAC_Analysis.R

.PHONY: clean
clean:
	rm -f output/*.rds