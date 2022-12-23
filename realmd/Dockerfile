FROM debian:bullseye

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y tzdata libace-dev libtbb-dev libmariadb-dev-compat libmariadb-dev 

WORKDIR /opt/server/bin
CMD ./realmd -c /opt/server/etc/realmd.conf
# RUN /bin/bash
