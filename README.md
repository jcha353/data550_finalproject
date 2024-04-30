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
  - use `make` or `make finalproject_report.html` to generate the report
  - `make .output/SCT_gene.rds` will generate the table of significant genes
  - `make .output/ATAC_peak.rds` will generate the table of significant peaks
  - `make clean` will remove all .rds files in the output folder
  - `make install` will restore all needed packages from the renv.lock file
  - `make project_image` will generate the docker image
  - `make report/final_report.html` will generate the report inside the docker container in a Mac/Linux-OS-specific target,
  the report will be found in a local directory called `report`

`Dockerfile`

  - contains the instructions to construct the Docker image: final_project_image4 
  - the docker image can be downloaded from Dockerhub: https://hub.docker.com/r/jchan353/final_project_image4 
  - the docker image can also be downloaded by running `docker pull jchan353/final_project_image4` in the terminal
  
------------------------------------------------------------------------

## To generate the report
1. Fork and clone this github repository to your desired location.
2. In an R console, use `setwd` and `getwd` to confirm that the working directory is the project directory.
3. Use `make install` in the terminal to download packages from renv.lock file 
4. Execute `make` or `make finalproject_report.html` in terminal to build report.

------------------------------------------------------------------------

## Using Docker to make the report
1. The Docker image can be constructed automatically by running `make project_image` or can be built by downloading the image from \
   https://hub.docker.com/r/jchan353/final_project_image4 or running `docker pull jchan353/final_project_image4` in the terminal
2. Once the Docker image is built, run the command `make report/final_report.html` to generate the report in the container \
  WARNING: This process takes a very long time (>2 hours)
3. The report will be generated in a local directory called `report`
