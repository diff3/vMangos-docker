FROM debian:bullseye-slim

RUN apt-get update && apt-get install -y libace-dev libtbb-dev libmariadb-dev-compat libmariadb-dev

WORKDIR /opt/server/bin
COPY --chmod=755 entry.sh /

ENTRYPOINT ["/entry.sh"]
