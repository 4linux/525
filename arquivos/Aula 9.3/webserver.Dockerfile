FROM ubuntu

RUN     apt update; \
        apt install wget git apache2 -yq

EXPOSE 80

CMD ["apachectl", "-D", "FOREGROUND"]
