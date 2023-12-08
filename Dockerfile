FROM rocker/shiny-verse:latest

## copy files
# Additional packages
COPY install_packages.R /install_packages.R

## install packages 
RUN Rscript /install_packages.R

RUN apt-get update \
    && apt-get install -y libglpk40