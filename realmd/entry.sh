#!/bin/sh

CONFIG_PATH=/opt/server/etc

cp $CONFIG_PATH/realmd.conf.dist $CONFIG_PATH/realmd.conf

sed -i -e '/LogsDir =/ s/= .*/= \"\/opt\/server\/logs\"/' $CONFIG_PATH/realmd.conf
sed -i -e '/PatchesDir =/ s/= .*/= \"\/opt\/server\/patches\"/' $CONFIG_PATH/realmd.conf
sed -i -e '/LoginDatabaseInfo =/ s/= .*/= \"mariadb\;3306\;mangos\;mangos\;realmd\"/' $CONFIG_PATH/realmd.conf

./realmd -c $CONFIG_PATH/realmd.conf
