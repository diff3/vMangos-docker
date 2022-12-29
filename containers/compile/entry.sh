#!/bin/sh


CONFIG_PATH=/opt/server/etc

path_source='/opt/etc'
cd $path_source

if [ ! -d "$path_source/core" ]; then
   git clone -b development https://github.com/vmangos/core
elif [ -d "$path_source/core" ] && [ ! -d "$path_source/core/.git" ]; then
   rm -r $path_source/core
   git clone -b development https://github.com/vmangos/core
elif [ -d "$path_source/core" ] && [ -d "$path_source/core/.git" ]; then
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

if [ ! -d "/opt/server/etc" ]; then
   mkdir -p /opt/server/etc
fi

if [ ! -d "/opt/server/warden_modules" ]; then
   mkdir -p /opt/server/etc
fi

cd /opt/etc/core/build

cmake .. -DCMAKE_INSTALL_PREFIX=/opt/server -DSUPPORTED_CLIENT_BUILD=$BUILD -DUSE_EXTRACTORS=$EXTRACTORS

make clean
make -j$CORES
make install

if [ -f /etc/realmd.conf.dist ]; then
   cp /etc/realmd.conf.dist /opt/server/etc
fi 

if [ -f /etc/realmd.conf.dist ]; then
   cp /etc/mangosd.conf.dist /opt/server/etc
fi 

sed -i -e '/DataDir =/ s/= .*/= \"\/opt\/server\/data\"/' $CONFIG_PATH/mangosd.conf
sed -i -e '/LogsDir =/ s/= .*/= \"\/opt\/server\/logs\"/' $CONFIG_PATH/mangosd.conf
sed -i -e '/HonorDir =/ s/= .*/= \"\/opt\/server\/honor\"/' $CONFIG_PATH/mangosd.conf
sed -i -e '/Warden\.ModuleDir             =/ s/= .*/= \"\/opt\/server\/warden\_modules\"/' $CONFIG_PATH/mangosd.conf

sed -i -e '/LoginDatabase\.Info              =/ s/= .*/= \"mariadb\;3306\;mangos\;mangos\;realmd\"/' $CONFIG_PATH/mangosd.conf
sed -i -e '/WorldDatabase\.Info              =/ s/= .*/= \"mariadb\;3306\;mangos\;mangos\;mangos\"/' $CONFIG_PATH/mangosd.conf
sed -i -e '/CharacterDatabase\.Info          =/ s/= .*/= \"mariadb\;3306\;mangos\;mangos\;characters\"/' $CONFIG_PATH/mangosd.conf
sed -i -e '/LogsDatabase\.Info               =/ s/= .*/= \"mariadb\;3306\;mangos\;mangos\;logs\"/' $CONFIG_PATH/mangosd.conf

sed -i -e '/GameType =/ s/= .*/= 6/' $CONFIG_PATH/mangosd.conf
sed -i -e '/RealmZone =/ s/= .*/= 8/' $CONFIG_PATH/mangosd.conf
sed -i -e '/Motd =/ s/= .*/= \"Welcome to Winterspring server\"/' $CONFIG_PATH/mangosd.conf

sed -i -e '/Ra\.Enable =/ s/= .*/= 1/' $CONFIG_PATH/mangosd.conf
sed -i -e '/AHBot\.Enable =/ s/= .*/= 1/' $CONFIG_PATH/mangosd.conf
sed -i -e '/AHBot\.itemcount =/ s/= .*/= 5000/' $CONFIG_PATH/mangosd.conf

sed -i -e '/SOAP\.Enabled =/ s/= .*/= 1/' $CONFIG_PATH/mangosd.conf
sed -i -e '/SOAP\.IP =/ s/= .*/= 0\.0\.0\.0/' $CONFIG_PATH/mangosd.conf

sed -i -e '/LogsDir =/ s/= .*/= \"\/opt\/server\/logs\"/' $CONFIG_PATH/realmd.conf
sed -i -e '/PatchesDir =/ s/= .*/= \"\/opt\/server\/patches\"/' $CONFIG_PATH/realmd.conf
sed -i -e '/LoginDatabaseInfo =/ s/= .*/= \"mariadb\;3306\;mangos\;mangos\;realmd\"/' $CONFIG_PATH/realmd.conf


