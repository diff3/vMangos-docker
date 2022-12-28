FROM debian:bullseye

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y tzdata wget vim tree g++ libace-dev libtbb-dev git cmake libmariadb-dev-compat libmariadb-dev openssl libssl-dev zlib1g-dev checkinstall build-essential 

COPY --chmod=755 entry.sh / 

CMD /entry.sh
