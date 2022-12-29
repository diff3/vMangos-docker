FROM mariadb:latest

RUN apt-get update && apt-get -y install git unzip wget 

COPY --chmod=755 create.sh /docker-entrypoint-initdb.d
