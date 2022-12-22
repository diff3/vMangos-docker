#!/bin/sh

if [ ! -f /opt/core/README.md && ];then
   cd /opt
   git clone -b development https://github.com/vmangos/core
   mkdir -p /opt/core/build
else
   cd /opt/core/build
   git pull
   make clean
fi

cd /opt/core/build

cmake .. -DCMAKE_INSTALL_PREFIX=${PREFX} -DSUPPORTED_CLIENT_BUILD=${BUILD} -DUSE_EXTRACTORS=${EXTRACTORS} 

make -j$CORES
make install
