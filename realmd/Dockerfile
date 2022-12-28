FROM debian:bullseye

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y tzdata libace-dev libtbb-dev libmariadb-dev-compat libmariadb-dev 

WORKDIR /opt/server/bin
COPY --chmod=755 ./entry.sh /

ENTRYPOINT ["/entry.sh"]
