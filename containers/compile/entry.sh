#!/bin/sh

escape() {
  local tmp=`echo $1 | sed 's/[^a-zA-Z0-9\s:]/\\\&/g'`
  echo "$tmp"
}

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
make -j $(nproc) install

if [ -f /etc/realmd.conf.dist ]; then
   cp /etc/realmd.conf.dist /opt/server/etc
fi 

if [ -f /opt/server/etc/realmd.conf.dist ]; then
   cp /opt/server/etc/realmd.conf.dist /opt/server/etc/realmd.conf
fi 

if [ -f /etc/mangosd.conf.dist ]; then
   cp /etc/mangosd.conf.dist /opt/server/etc
fi 

if [ -f /opt/server/etc/mangosd.conf.dist ]; then
   cp /opt/server/etc/mangosd.conf.dist /opt/server/etc/mangosd.conf
fi 

# mangosd.conf
sed -i -e "/DataDir =/ s/= .*/= $(escape $DATA_DIR_PATH)/" $CONFIG_PATH/mangosd.conf
sed -i -e "/LogsDir =/ s/= .*/= $(escape $LOGS_DIR_PATH)/" $CONFIG_PATH/mangosd.conf
sed -i -e "/HonorDir =/ s/= .*/= $(escape $HONOR_DIR_PATH)/" $CONFIG_PATH/mangosd.conf
sed -i -e "/Warden.ModuleDir             =/ s/= .*/= $(escape $WARDEN_DIR_PATH)/" $CONFIG_PATH/mangosd.conf

sed -i -e "/LoginDatabase.Info              =/ s/= .*/= \"$(escape $DB_CONTAINER)\;3306\;$(escape $SERVER_DB_USER)\;$(escape $SERVER_DB_PWD)\;realmd\"/" $CONFIG_PATH/mangosd.conf
sed -i -e "/WorldDatabase.Info              =/ s/= .*/= \"$(escape $DB_CONTAINER)\;3306\;$(escape $SERVER_DB_USER)\;$(escape $SERVER_DB_PWD)\;mangos\"/" $CONFIG_PATH/mangosd.conf
sed -i -e "/CharacterDatabase.Info          =/ s/= .*/= \"$(escape $DB_CONTAINER)\;3306\;$(escape $SERVER_DB_USER)\;$(escape $SERVER_DB_PWD)\;characters\"/" $CONFIG_PATH/mangosd.conf
sed -i -e "/LogsDatabase.Info               =/ s/= .*/= \"$(escape $DB_CONTAINER)\;3306\;$(escape $SERVER_DB_USER)\;$(escape $SERVER_DB_PWD)\;logs\"/" $CONFIG_PATH/mangosd.conf

sed -i -e "/GameType =/ s/= .*/= $(escape $GAME_TYPE)/" $CONFIG_PATH/mangosd.conf
sed -i -e "/RealmZone =/ s/= .*/= $(escape $REALM_ZONE)/" $CONFIG_PATH/mangosd.conf
sed -i -e "/Motd =/ s/= .*/= $(escape $MOTD_MSG)/" $CONFIG_PATH/mangosd.conf

sed -i -e "/Ra.Enable =/ s/= .*/= $(escape $RA_ENABLE)/" $CONFIG_PATH/mangosd.conf
sed -i -e "/AHBot.Enable  =/ s/= .*/= $(escape $AH_ENABLE)/" $CONFIG_PATH/mangosd.conf
sed -i -e "/AHBot.itemcount =/ s/= .*/= $(escape $AH_ITEM_COUNT)/" $CONFIG_PATH/mangosd.conf

sed -i -e "/SOAP.Enabled =/ s/= .*/= $(escape $SOAP_ENABLE)/" $CONFIG_PATH/mangosd.conf
sed -i -e "/SOAP.IP =/ s/= .*/= $(escape $SOAP_IP)/" $CONFIG_PATH/mangosd.conf

# realmd.conf
sed -i -e "/LogsDir =/ s/= .*/= $(escape $LOGS_DIR_PATH)/" $CONFIG_PATH/realmd.conf
sed -i -e "/PatchesDir =/ s/= .*/= $(escape $PATCH_DIR_PATH)/" $CONFIG_PATH/realmd.conf
sed -i -e "/LoginDatabaseInfo =/ s/= .*/= \"$(escape $DB_CONTAINER)\;3306\;$(escape $SERVER_DB_USER)\;$(escape $SERVER_DB_PWD)\;realmd\"/" $CONFIG_PATH/realmd.conf


