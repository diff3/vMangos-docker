#!/bin/sh

cd /opt

if [ $DOWNLOAD_SOURCE = 'ON' ]; then
    git clone https://github.com/cmangos/mangos-tbc
    git clone https://github.com/cmangos/tbc-db
fi

if [ $UPDATE_SOURCE = 'ON' ]; then
   cd /opt/mangos-tbc
   git pull

   cd /opt/tbc-db
   git pull
fi

mkdir -p /opt/mangos-tbc/build
cd /opt/mangos-tbc/build

if [ $CREATE_DIRS = 'ON' ]; then
    mkdir -p $INSTALL_PREFIX/logs
    mkdir -p $INSTALL_PREFIX/data
fi

cmake .. -DCMAKE_INSTALL_PREFIX=$INSTALL_PREFIX -DBUILD_EXTRACTORS=$EXTRACTORS -DPCH=$PCH -DDEBUG=$DEBUG -DBUILD_PLAYERBOT=$PLAYERBOT -DBUILD_AHBOT=$AHBOT -DBUILD_METRICS=$METRICS -DBUILD_LOGIN_SERVER=$LOGIN_SERVER -DBUILD_GAME_SERVER=$GAME_SERVER -DBUILD_GIT_ID=$GIT_ID -DBUILD_RECASTDEMOMOD=$RECASTDEMOMOD -DBUILD_DOCS=$DOCS -DBUILD_WARNINGS=$WARNINGS -DBUILD_POSTGRESQL=$POSTGRESQL

make clean
make -j $CORES
make install
