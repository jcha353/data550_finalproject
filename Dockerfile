FROM dbenkeser/r430 as base 

RUN apt-get update && apt-get install -y libxml2-dev
RUN apt-get install -y libssl-dev
RUN apt-get install -y libglpk-dev
RUN apt-get install -y libpng-dev

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

RUN Rscript -e "install.packages('XML')"
RUN Rscript -e "renv::restore()"

###### DO NOT EDIT STAGE 1 BUILD LINES ABOVE ######

FROM dbenkeser/r430
WORKDIR /project
COPY --from=base /project .

COPY Makefile .
COPY finalproject_report.Rmd .

RUN mkdir code
RUN mkdir output
RUN mkdir output/figures
RUN mkdir output/figures/SCT
RUN mkdir output/figures/ATAC
RUN mkdir data
RUN mkdir report

# Copy over raw data
COPY data/seurat.rds data/seurat.rds

# Copy over code
COPY code/01_SCT_Analysis.R code/01_SCT_Analysis.R
COPY code/02_ATAC_Analysis.R code/02_ATAC_Analysis.R
COPY code/03_render_report.R code/03_render_report.R

CMD make && mv finalproject_report.html report