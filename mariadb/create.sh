#!/bin/sh

echo "Updateing database from git"
cd /opt/etc/core 
git pull

echo "Starting Initialization of CMaNGOS DB..."

echo "Creating db user"
mysql -u $MYSQL_USERNAME -p$MYSQL_PASSWORD -e "create user '$SERVER_DB_USER'@'$SERVER_DB_USERIP' identified by '$SERVER_DB_PWD';"

echo "Creating databases"
mysql -u $MYSQL_USERNAME -p$MYSQL_PASSWORD -e "create database $CHAR_DB_NAME;"
mysql -u $MYSQL_USERNAME -p$MYSQL_PASSWORD -e "create database $LOGS_DB_NAME;"
mysql -u $MYSQL_USERNAME -p$MYSQL_PASSWORD -e "create database $REALM_DB_NAME;"
mysql -u $MYSQL_USERNAME -p$MYSQL_PASSWORD -e "create database $WORLD_DB_NAME;"

echo "Grant db user database privileges"
mysql -u $MYSQL_USERNAME -p$MYSQL_PASSWORD -e "grant all privileges on $CHAR_DB_NAME.* to '$SERVER_DB_USER'@'$SERVER_DB_USERIP';"
mysql -u $MYSQL_USERNAME -p$MYSQL_PASSWORD -e "grant all privileges on $LOGS_DB_NAME.* to '$SERVER_DB_USER'@'$SERVER_DB_USERIP';"
mysql -u $MYSQL_USERNAME -p$MYSQL_PASSWORD -e "grant all privileges on $REALM_DB_NAME.* to '$SERVER_DB_USER'@'$SERVER_DB_USERIP';"
mysql -u $MYSQL_USERNAME -p$MYSQL_PASSWORD -e "grant all privileges on $WORLD_DB_NAME.* to '$SERVER_DB_USER'@'$SERVER_DB_USERIP';"

echo "Crating merge files"
cd /opt/etc/core/sql/migrations
sh merge.sh

echo "Downloading latest db"
cd /tmp
wget $DB_WORLD_FILE -O /tmp/db.zip
unzip db.zip

echo "Adding base data to databases"
mysql -u $MYSQL_USERNAME -p$MYSQL_PASSWORD $CHAR_DB_NAME < /opt/etc/core/sql/characters.sql
mysql -u $MYSQL_USERNAME -p$MYSQL_PASSWORD $LOGS_DB_NAME < /opt/etc/core/sql/logs.sql
mysql -u $MYSQL_USERNAME -p$MYSQL_PASSWORD $REALM_DB_NAME < /opt/etc/core/sql/logon.sql
mysql -u $MYSQL_USERNAME -p$MYSQL_PASSWORD $WORLD_DB_NAME < /tmp/db_dump/mangos.sql

echo "Adding updates to databases"
mysql -u $MYSQL_USERNAME -p$MYSQL_PASSWORD $CHAR_DB_NAME < /opt/etc/core/sql/migrations/characters_db_updates.sql
mysql -u $MYSQL_USERNAME -p$MYSQL_PASSWORD $LOGS_DB_NAME < /opt/etc/core/sql/migrations/logs_db_updates.sql
mysql -u $MYSQL_USERNAME -p$MYSQL_PASSWORD $REALM_DB_NAME < /opt/etc/core/sql/migrations/logon_db_updates.sql
mysql -u $MYSQL_USERNAME -p$MYSQL_PASSWORD $WORLD_DB_NAME < /opt/etc/core/sql/migrations/world_db_updates.sql

echo "Configure users, and removal"
# mysql -u $MYSQL_USERNAME -p$MYSQL_PASSWORD $REALM_DB_NAME -e "UPDATE account SET gmlevel = '4', locked = '1' WHERE id = '1' LIMIT 1;"

echo "Add user"
# mysql -u $MYSQL_USERNAME -p$MYSQL_PASSWORD $REALM_DB_NAME -e "INSERT INTO account (username, gmlevel, v, s, expansion, locale) VALUES ('MAPE', 4, '598439E55FF93613E12E89B23A1348D38BDCEA98C77347C2A84EE1CC210C3BDE', 'B09701BDE2AAEF7E068438E831BAA8A2FF8301338C4F6420D26CCF4EA2683A47', 1, 'enUS');"

echo "Adding realm"
mysql -u $MYSQL_USERNAME -p$MYSQL_PASSWORD $REALM_DB_NAME -e "INSERT INTO realmlist (name, address, port, icon, realmflags, timezone, allowedSecurityLevel, population, gamebuild_min, gamebuild_max, realmbuilds) VALUES ('$REALM_NAME', '$REALM_ADRESS', '$REALM_PORT', '$REALM_ICON', '$REALM_FLAG', '$REALM_TIMEZONE', '$REALM_SECURITY', '$REALM_POP', '$REALM_GAMEBUILD_MIN', '$REALM_GAMEBUILD_MAX', '$REALM_BUILD');"