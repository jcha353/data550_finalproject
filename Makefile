# Rule to generate final report
finalproject_report.html: finalproject_report.Rmd code/01_SCT_Analysis.R code/02_ATAC_Analysis.R \
	output/SCT_gene.rds output/ATAC_peak.rds code/03_render_report.R
	Rscript code/03_render_report.R

output/SCT_gene.rds: code/01_SCT_Analysis.R
	Rscript code/01_SCT_Analysis.R

output/ATAC_peak.rds: code/02_ATAC_Analysis.R
	Rscript code/02_ATAC_Analysis.R

# Rule to clean
.PHONY: clean
clean:
	rm -f output/*.rds

# Rule to restore renv	
.PHONT: install
install:
	Rscript -e "renv::restore(prompt = FALSE)"

# Docker associated Files
PROJECTFILES = finalproject_report.Rmd code/01_SCT_Analysis.R code/02_ATAC_Analysis.R output/SCT_gene.rds output/ATAC_peak.rds code/03_render_report.R
RENVFILES = renv.lock renv/activate.R renv/settings.json

# Rule to build image
project_image: Dockerfile $(PROJECTFILES) $(RENVFILES)
	docker build -t final_project_image4 .
	touch$@

# Rule to run container and build report
report/final_report.html: 
	docker run -v "$$(pwd)"/report:/project/report jchan353/final_project_image4