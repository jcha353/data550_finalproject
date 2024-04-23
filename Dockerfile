FROM ubuntu as base 

ENV DEBIAN_FRONTEND=noninteractive
ENV R_VERSION=4.3.0
RUN apt-get update
RUN apt-get install -y gdebi-core curl
RUN curl -O https://cdn.rstudio.com/r/ubuntu-2204/pkgs/r-${R_VERSION}_1_amd64.deb
RUN gdebi -n r-${R_VERSION}_1_amd64.deb
RUN ln -s /opt/R/${R_VERSION}/bin/R /usr/local/bin/R
RUN ln -s /opt/R/${R_VERSION}/bin/Rscript /usr/local/bin/Rscript 

RUN apt-get install -y libcurl4-openssl-dev libglpk40 pandoc

RUN mkdir /project
WORKDIR /project

# make renv directory and copy all contensts
RUN mkdir -p renv
COPY renv.lock renv.lock
COPY .Rprofile .Rprofile
COPY renv/activate.R renv/activate.R
COPY renv/settings.json renv/settings.json

RUN mkdir renv/.cache 
ENV RENV_PATHS_CACHE renv/.cache

RUN Rscript -e "renv::restore()"



#RUN Rscript -e "BiocManager::install('BSgenome.Mmusculus.UCSC.mm10')"
#RUN Rscript -e "install.packages('here')"
###### DO NOT EDIT STAGE 1 BUILD LINES ABOVE ######

FROM rocker/r-ubuntu
WORKDIR /project
COPY --from=base /project .

COPY Makefile .
COPY finalproject_report.Rmd .

RUN mkdir /code
RUN mkdir /output
RUN mkdir /output/figures
RUN mkdir /data
RUN mkdir /report

# Copy over raw data
COPY data/seurat.rds data/seurat.rds

# Copy over code
COPY code/01_SCT_Analysis.R code/01_SCT_Analysis.R
COPY code/02_ATAC_Analysis.R code/02_ATAC_Analysis.R
COPY code/03_render_report.R code/03_render_report.R

CMD make finalproject_report.html report