#load Shiny docker container
FROM rocker/shiny

#install R packages
RUN R -e "install.packages(c('shiny', 'leaflet', 'maps', 'readxl', 'scales', 'DT'), repos='http://cran.rstudio.com/')"

#copy configuration file into the Docker image
COPY /shiny-server.conf  /etc/shiny-server/shiny-server.conf

#copy app script and data into the Docker image
COPY /app /srv/shiny-server/

#make app avaliable at port 80
EXPOSE 80

#run shell script
CMD ["/usr/bin/shiny-server.sh"]
