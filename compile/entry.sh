#!/bin/sh

path='/opt/etc'
cd $path

echo "Hello"

if [ ! -d "$path/core" ]; then
   echo "no core"
   git clone -b development https://github.com/vmangos/core
elif [ -d "$path/core" ] && [ ! -d "$path/core/.git" ]; then
   echo "core but no .git"
   rm -r $path/core
   git clone -b development https://github.com/vmangos/core
elif [ -d "$path/core" ] && [ -d "$path/core/.git" ]; then
   echo "core and .git"
   cd core
   git pull
fi

if [ ! -d "/opt/etc/core/build" ]; then
   mkdir -p /opt/etc/core/build
fi

if [ ! -d "/opt/server/logs" ]; then
   mkdir -p /opt/server/logs
fi

if [ ! -d "/opt/server/honor" ]; then
   mkdir -p /opt/server/honor
fi

if [ ! -d "/opt/server/patches" ]; then
   mkdir -p /opt/server/patches
fi

cd /opt/etc/core/build

cmake .. -DCMAKE_INSTALL_PREFIX=/opt/server -DSUPPORTED_CLIENT_BUILD=$BUILD -DUSE_EXTRACTORS=$EXTRACTORS 

make clean
make -j$CORES
make install
