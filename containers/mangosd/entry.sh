#!/bin/sh

CONFIG_PATH=/opt/server/etc

test="Hello World"

cp $CONFIG_PATH/mangosd.conf.dist $CONFIG_PATH/mangosd.conf

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
sed -i -e '/Motd =/ s/= .*/= \"Welcome to "$test" server\"/' $CONFIG_PATH/mangosd.conf
# sed -i -e '/AllowTwoSide\.Accounts =/ s/= .*/= 1/' $CONFIG_PATH/mangosd.conf
# sed -i -e '/AllowTwoSide\.Interaction\.Chat =/ s/= .*/= 1/' $CONFIG_PATH/mangosd.conf
# sed -i -e '/AllowTwoSide\.Interaction\.Channel =/ s/= .*/= 1/' $CONFIG_PATH/mangosd.conf
# sed -i -e '/GM\.JoinOppositeFactionChannels =/ s/= .*/= 1/' $CONFIG_PATH/mangosd.conf
# sed -i -e '/AllowTwoSide\.Interaction\.Group =/ s/= .*/= 1/' $CONFIG_PATH/mangosd.conf
# sed -i -e '/AllowTwoSide\.Interaction\.Guild =/ s/= .*/= 1/' $CONFIG_PATH/mangosd.conf
# sed -i -e '/AllowTwoSide\.Interaction\.Trade =/ s/= .*/= 1/' $CONFIG_PATH/mangosd.conf
# sed -i -e '/AllowTwoSide\.Interaction\.Auction =/ s/= .*/= 1/' $CONFIG_PATH/mangosd.conf
# sed -i -e '/AllowTwoSide\.Interaction\.Mail =/ s/= .*/= 1/' $CONFIG_PATH/mangosd.conf
# sed -i -e '/AllowTwoSide\.WhoList =/ s/= .*/= 1/' $CONFIG_PATH/mangosd.conf
# sed -i -e '/AllowTwoSide\.AddFriend =/ s/= .*/= 1/' $CONFIG_PATH/mangosd.conf
sed -i -e '/Ra\.Enable =/ s/= .*/= 1/' $CONFIG_PATH/mangosd.conf
sed -i -e '/AHBot\.Enable =/ s/= .*/= 1/' $CONFIG_PATH/mangosd.conf
sed -i -e '/AHBot\.itemcount =/ s/= .*/= 5000/' $CONFIG_PATH/mangosd.conf

./mangosd -c $CONFIG_PATH/mangosd.conf
