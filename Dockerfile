FROM rocker/shiny-verse:latest

## copy files
# Additional packages
COPY install_packages.R /install_packages.R
COPY requirements.txt /requirements.txt

## install packages 
RUN Rscript /install_packages.R

RUN apt-get update \
    && apt-get install -y libglpk40
    
RUN apt-get update && apt-get install -y --no-install-recommends build-essential libpq-dev python3.11 python3-pip python3-setuptools python3-dev
RUN pip3 install --upgrade pip

ENV PYTHONPATH "${PYTHONPATH}:/app"

RUN pip3 install -r requirements.txt
