FROM ubuntu:20.04
ENV DEBIAN_FRONTEND=noninteractive
RUN apt update && apt install -y tzdata build-essential gcc g++ automake git-core autoconf make patch libmysql++-dev libtool libssl-dev grep binutils zlibc libbz2-dev cmake libboost-all-dev

COPY --chmod=755 entry.sh / 
# CMD /entry.sh
CMD /bin/bash
