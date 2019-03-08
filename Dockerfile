FROM rocker/shiny

ADD tmp/install /tmp/

RUN /tmp/install

ADD srv/shiny-server/ /srv/shiny-server/


